is_digit(X) :- atom_length(X, 1), X @>= '0', X @=< '9'.

concatenar([], L, L).
concatenar([X|L1], L2, [X|L3]) :- concatenar(L1, L2, L3).

linearizar([], []).
linearizar([X|L], LR) :- linearizar(L, LT), concatenar(X, LT, LR).

compactar([], []).
compactar([X], [[1, X]]). 
compactar([X, X|T], [[Qnt, X] | Resto]) :- compactar([X|T], [[N, X] | Resto]), Qnt is N + 1. 
compactar([X, Y|T], [[1, X] | Resto]) :- X \= Y,  compactar([Y|T], Resto).

numAux([], []).
numAux([X,Y|L], R) :- numAux(L, LT), number_chars(X, XT), concatenar([Y], LT, CT), concatenar(XT, CT, R).

codificar(S, C) :- string_chars(S, T1), compactar(T1, T2), linearizar(T2, T3), numAux(T3, T4), string_chars(C, T4).



decodificar([],[],[]) :- 


descompactar(0, []).
descompactar(Num, P, R) :- Num1 is Num-1, descompactar(Num1, P, R1), concatenar([P], R1, R).

quant((C:_), Q) :- not(is_digit(C)), Q = [].
quant((C:S), Q) :- is_digit(C), quant(S, Q1), concatenar([C], Q1, Q). 

encntra_char((C:_), P) :- not(is_digit(C)), P = C.
enconta_char((C:S), P) :- is_digit(C), enconta_char(S, P).

remover((C:S), S1) :- not(is_digit(C)), S1 = S.
remover((C:S), S1) :- is_digit(C), remover(S, S1).

decoAux([],[]).
decoAux(S, D) :- quant(S, Q), number_chars(N, Q), enconta_char(S, P), descompactar(N, P, R), remover(S, S1), decoAux(S1, D1), concatenar(R, D1, D).

decodificar(S, D) :- string_chars(S, T1), decoAux(T1, T2), string_chars(D, T2).
