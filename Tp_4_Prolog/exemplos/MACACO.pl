muito_inteligente(X):- inteligente(X),
                       simpatico(X).

inteligente(X)      :- vivo(X), humano(X).
inteligente(X)      :- golfinho(X).

humano(X)           :- homem(X).
humano(X)           :- mulher(X).

vivo(chico).
golfinho(flipper).
mulher(maria).
homem(chico).
simpatico(flipper).