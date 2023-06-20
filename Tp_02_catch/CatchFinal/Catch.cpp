#include "Catch.h"
#include "ui_Catch.h"
#include "Player.h"

#include <QDebug>
#include <QMessageBox>
#include <QActionGroup>
#include <QSignalMapper>
#include <QStack>

#include <bits/stdc++.h>

Catch::Catch(QWidget *parent)
    : QMainWindow(parent),
    ui(new Ui::Catch),
    m_player(Player::player(Player::Red)) {

    ui->setupUi(this);

    QObject::connect(ui->actionNew, SIGNAL(triggered(bool)), this, SLOT(reset()));
    QObject::connect(ui->actionQuit, SIGNAL(triggered(bool)), qApp, SLOT(quit()));
    QObject::connect(ui->actionAbout, SIGNAL(triggered(bool)), this, SLOT(showAbout()));

    QSignalMapper* map = new QSignalMapper(this);
    for (int row = 0; row < 8; ++row) {
        for (int col = 0; col < 8; ++col) {
            QString cellName = QString("cell%1%2").arg(row).arg(col);
            Cell* cell = this->findChild<Cell*>(cellName);
            Q_ASSERT(cell != nullptr);
            Q_ASSERT(cell->row() == row && cell->col() == col);

            m_board[row][col] = cell;

            int id = row * 8 + col;
            map->setMapping(cell, id);
            QObject::connect(cell, SIGNAL(clicked(bool)), map, SLOT(map()));
            QObject::connect(cell, SIGNAL(mouseOver(bool)), this, SLOT(updateSelectables(bool)));
        }
    }
#if QT_VERSION < QT_VERSION_CHECK(6,0,0)
    QObject::connect(map, SIGNAL(mapped(int)), this, SLOT(play(int)));
#else
    QObject::connect(map, SIGNAL(mappedInt(int)), this, SLOT(play(int)));
#endif

    // When the turn ends, switch the player.
    QObject::connect(this, SIGNAL(turnEnded()), this, SLOT(switchPlayer()));

    this->reset();

    this->adjustSize();
    this->setFixedSize(this->size());
}

Catch::~Catch() {
    delete ui;
}



void Catch::acabaJogo (){
    Cell* cell = nullptr;
    Cell* adj_cell = nullptr;

    for(int i = 0; i < 8; i++){
        for(int j = 0; j < 8; j++){
            cell = m_board[i][j];
            if(m_player->orientation() == Player::Horizontal && cell->col() != 7){
                adj_cell = m_board[cell->row()][cell->col()+1];
            }
            else if(m_player->orientation() == Player::Vertical && cell->row() != 7){
                adj_cell = m_board[cell->row()+1][cell->col()];
            }

            if(cell->isEmpty() && adj_cell != nullptr && adj_cell->isEmpty()){
                return;
            }
            adj_cell = nullptr;
        }
    }

    if(m_player->count() > m_player->other()->count()){
        QMessageBox::information(this, tr(""), tr("Parabéns, o %1 venceu por %2 a %3").arg(m_player->name()).arg(m_player->count()).arg(m_player->other()->count()));
    }else if (m_player->count() < m_player->other()->count()){
        QMessageBox::information(this, tr(""), tr("Parabéns, o %1 venceu por %2 a %3").arg(m_player->other()->name()).arg(m_player->other()->count()).arg(m_player->count()));
    }else {
        QMessageBox::information(this, tr(""), tr("O jogo empatou em %1 a %2").arg(m_player->count()).arg(m_player->other()->count()));
    }


    reset();
}


bool analisaFila (std::queue<std::pair<int,int>> proximos, int lin,int col){

    std::queue<std::pair<int,int>> copia (proximos);

    for (std::pair<int,int> aux;!copia.empty();copia.pop()){

        aux = copia.front();
        if ((aux.first == lin) && (aux.second == col)) return false;
    }

    return true;// pode colocar na fila
}

bool valida_posicao(std::pair<int, int> u, bool (&vis_d)[8][8]) {
    return u.first >= 0 && u.second >= 0 && u.first < 8 && u.second < 8 && !vis_d[u.first][u.second];
}

std::vector<std::pair<int, int>> mov = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

void bfs_d(std::pair<int, int> s, std::vector<std::pair<int,int>>& andei, bool (&vis_d)[8][8])
{
    std::queue<std::pair<int,int>> q;
    q.push(s); vis_d[s.first][s.second] = 1;
    andei.push_back(s); // onde comeca a "andar"

    while(!q.empty()) {
        std::pair<int, int> v = q.front(); q.pop();

        for(auto u : mov){
            u.first += v.first;
            u.second += v.second;

            if(valida_posicao(u, vis_d))
            {
                if (analisaFila(q,u.first,u.second)) q.push(u);
                andei.push_back(u);
                q.push(u);
                vis_d[u.first][u.second] = 1;
            }
        }
    }
}

void Catch::play(int id) {


    Cell* cell = m_board[id / 8][id % 8];
    if (cell == nullptr || !cell->isSelectable())
        return;


    Cell* adj_cell;
    if(m_player->orientation() == Player::Horizontal){
        adj_cell = m_board[cell->row()][cell->col()+1];
    }
    else{
        adj_cell = m_board[cell->row()+1][cell->col()];
    }

    cell->setState(Cell::Blocked);
    adj_cell->setState(Cell::Blocked);

    // codigo de bfs
    bool visitados[8][8] = {};
    bool visitadosCopia[8][8] = {};

    // zerar toda a matriz
    for (int i=0;i<8;i++){
        for (int j=0;j<8;j++){
            visitados[i][j] = false;
        }
    }


    for (int i=0;i<8;i++){
        for (int j=0;j<8;j++){
            if (m_board[i][j]->isBlocked() || m_board[i][j]->isCaptured()){
                visitados[i][j] = true;
            }
        }
    }

    bool verificadorMatriz = true;

    while (verificadorMatriz){

        for (int i=0;i<8;i++){
            for (int j=0;j<8;j++){
                visitadosCopia[i][j] = visitados[i][j];
            }
        }

        std::queue<std::pair<int,int>> proximos; // fila de analise
        // decidir onde comeca, tem q varrer ate achar algum vazio
        bool verificadorFor1 = false;
        int col,lin;

        for (int i=0;i<8;i++){
            for (int j=0;j<8;j++){
                if (visitados[i][j] == false){
                    verificadorFor1 = true;
                    col = j;
                    break;
                }
            }
            if(verificadorFor1){
                lin = i;
                break;
            }
        }


        proximos.push(std::make_pair(lin,col)); // onde comeca

        std::vector<std::pair<int,int>> andei;

        bfs_d(std::make_pair(lin,col), andei, visitadosCopia);

        //verifica a logica de pontuacao
        if(!andei.empty()) {
            if(andei.size() < 4){

                for (size_t i=0;i< andei.size();i++) m_player->incrementCount();
                for (size_t k=0;k< andei.size();k++){

                    //m_board[andei[k].first][andei[k].second]->reset();
                    m_board[andei[k].first][andei[k].second]->setPlayer(m_player);
                    visitados[andei[k].first][andei[k].second] = true;

                }

            }else{
                for (size_t k=0;k< andei.size();k++){

                    visitados[andei[k].first][andei[k].second] = true;

                }

            }
        }

        bool verificadorFor2 = false;
        verificadorMatriz = false;
        for (int i=0;i<8;i++){
            for (int j=0;j<8;j++){
                if (visitadosCopia[i][j] == false){
                    verificadorMatriz = true;
                    verificadorFor2 = true;
                    break;
                }
            }
            if(verificadorFor2){
                break;
            }
        }
    }
    emit turnEnded();

}

void Catch::switchPlayer() {
    // Switch the player.
    m_player = m_player->other();

    // Finally, update the status bar.
    this->updateStatusBar();


    acabaJogo();
}

void Catch::reset() {
    // Reset board.
    for (int row = 0; row < 8; ++row) {
        for (int col = 0; col < 8; ++col) {
            Cell* cell = m_board[row][col];
            cell->reset();
        }
    }

    // Reset the players.
    Player* red = Player::player(Player::Red);
    red->reset();

    Player* blue = Player::player(Player::Blue);
    blue->reset();

    m_player = red;

    // Finally, update the status bar.
    this->updateStatusBar();
}

void Catch::showAbout() {
    QMessageBox::information(this, tr("Sobre"), tr("Catch\n\nArthur de Almeida Sales Secundino - artsecundino@gmail.com\n\nLucas Andrade Brandão - andradelucasbrandao@gmail.com"));
}

void Catch::updateSelectables(bool over) {
    Cell* cell = qobject_cast<Cell*>(QObject::sender());
    Q_ASSERT(cell != nullptr);
    Cell* adj_cell = nullptr;

    if(m_player->orientation() == Player::Horizontal && cell->col() != 7){
        adj_cell = m_board[cell->row()][cell->col()+1];
    }
    else if(m_player->orientation() == Player::Vertical && cell->row() != 7){
        adj_cell = m_board[cell->row()+1][cell->col()];
    }

    if (over) {
        if (cell->isEmpty() && adj_cell != nullptr && adj_cell->isEmpty()  ){
            cell->setState(Cell::Selectable);
            adj_cell->setState(Cell::Selectable);
        }
    }
    else {
        if(cell->isSelectable() && adj_cell != nullptr && adj_cell->isSelectable()){
            cell->setState(Cell::Empty);
            adj_cell->setState(Cell::Empty);
        }
    }
}

void Catch::updateStatusBar() {
    ui->statusbar->showMessage(tr("Vez do %1 (%2 a %3)")
                                   .arg(m_player->name()).arg(m_player->count()).arg(m_player->other()->count()));
}
