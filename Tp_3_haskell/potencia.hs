potencia :: Int -> Int -> Int
potencia m n
    | n == 0 = 1
    | n > 0  =  m * potencia m (n-1)