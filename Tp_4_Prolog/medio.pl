soma([], 0).
soma([X | L], S) :- soma(L, S1), S is X+S1.

nelementos([], 0).
nelementos([_|L], S) :- nelementos(L, S1), S is S1+1.

medio(L, M) :- soma(L, S), nelementos(L, N), M is S/N.