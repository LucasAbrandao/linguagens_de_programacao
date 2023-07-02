concatenar([], L, L).
concatenar([X|L1], L2, [X|L3]) :- concatenar(L1, L2, L3).

linearizar([], []).
linearizar([X|Y], L) :- linearizar(Y, L1), concatenar(X, L1, L).