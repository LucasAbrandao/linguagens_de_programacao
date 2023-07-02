maior([M], M).
maior([X,Y|L], M) :- X >= Y, maior([X|L], M).
maior([X,Y|L], M) :- X < Y, maior([Y|L], M).