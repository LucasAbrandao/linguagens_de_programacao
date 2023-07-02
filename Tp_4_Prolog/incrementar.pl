incrementar([],[]).
incrementar([X|Y], [X1|Y1]) :- X1 is X+1 , incrementar(Y, Y1).