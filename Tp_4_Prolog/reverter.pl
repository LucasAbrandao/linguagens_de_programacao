concatenar([], L, L).
concatenar([X|L1], L2, [X|L3]) :- concatenar(L1, L2, L3).

reverter([], []).
reverter([X|R], L) :- reverter(R, L1), concatenar(L1, [X], L).