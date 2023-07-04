fiboAux :: [Int] -> Bool
fiboAux []      = False
fiboAux [_]     = False
fiboAux [x,y]   = x == 1 && y == 1
fiboAux (a:b:c:l)
    | a == b +c     = fiboAux (b:c:l)
    |otherwise False

fibo :: [Int] -> Bool
fibo l = fiboAux (reverse l)