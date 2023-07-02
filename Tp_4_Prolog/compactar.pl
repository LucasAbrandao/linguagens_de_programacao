compactar([], []).
compactar([X], [[1, X]]). 
compactar([X, X|T], [[Qnt, X] | Resto]) :- compactar([X|T], [[N, X] | Resto]), Qnt is N + 1. 
compactar([X, Y|T], [[1, X] | Resto]) :- X \= Y,  compactar([Y|T], Resto). 