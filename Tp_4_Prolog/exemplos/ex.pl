elemento(X, [ X | _ ]).
elemento(X, [ _ | L ]) :- elemento(X, L).


igual([],[]).
igual([X | L1], [X | L2]) :- igual(L1, L2).


concatenar([], L, L).
concatenar([X|L1], L2, [X|L3]) :- concatenar(L1, L2, L3).


remover(X, [X|T], T).
remover(X, [Y|T], [Y|NT]) :- X \== Y, remover(X, T, NT).


densidade(X,Y) :- populacao(X,P), area(X,A), Y is P/A.


mdc(X,X,X).
mdc(X,Y,Z) :- X > Y, W is X-Y, mdc(W,Y,Z).
mdc(X,Y,Z) :- Y > X, W is Y-X, mdc(X,W,Z).


fatorial(0, 1).
fatorial(X, Y) :- X1 is X-1, fatorial(X1, Y1), Y is X*Y1.


soma([], 0).
soma([X | L], S) :- soma(L, S1), S is X+S1.