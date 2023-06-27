pai(carlos,madalena).
pai(manoel,felipe).

mae(madalena,manoel).

pais(X,Y) :- pai(X,Y).
pais(X,Y) :- mae(X,Y).

descendente(X,Y) :- pais(Y,X).
descendente(X,Y) :- pais(Z,X), descendente(Z,Y).