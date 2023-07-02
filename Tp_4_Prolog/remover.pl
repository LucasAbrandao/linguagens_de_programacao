concatenar([], L, L).
concatenar([X|L1], L2, [X|L3]) :- concatenar(L1, L2, L3).

remover(_, [], []).
remover(X, [X|L1], L) :- remover(X, L1, L).
remover(X, [Y|L1], L) :- remover(X, L1, L2), concatenar([Y], L2, L).