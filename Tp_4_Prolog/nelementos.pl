nelementos([], 0).
nelementos([_|L], S) :- nelementos(L, S1), S is S1+1.