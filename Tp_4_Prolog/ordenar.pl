ordenar([], []).
ordenar([X|Resto], Ordenada) :- ordenar(Resto, Ordenada1),  inserir(X, Ordenada1, Ordenada).

inserir(X, [], [X]).
inserir(X, [Y|Resto], [X,Y|Resto]) :- X =< Y.
inserir(X, [Y|Resto], [Y|NovaLista]) :- X > Y,   inserir(X, Resto, NovaLista).
