concatenar([], L, L).
concatenar([X|L1], L2, [X|L3]) :- concatenar(L1, L2, L3).

rotacionarn(0, R, R).
rotacionarn(Q, [X|R], L) :- Q1 is Q-1, concatenar(R, [X], L1), rotacionarn(Q1, L1, L).