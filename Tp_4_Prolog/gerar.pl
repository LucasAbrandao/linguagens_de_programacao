gerar(Y, Y, [Y]).
gerar(X, Y, [X|L]) :- Z is X+1, gerar(Z, Y, L).