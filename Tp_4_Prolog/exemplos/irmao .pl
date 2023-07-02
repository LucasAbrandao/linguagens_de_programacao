homem(mario).
mae(joao, roberta).
mae(mario, roberta).
pai(joao, paulo).
pai(mario, paulo).

pais(X, M, P)   :-  mae(X, M),
                    pai(X, P).
irmao(X, Y)     :-  homem(Y),
                    pais(X, M, P),
                    pais(Y, M, P).