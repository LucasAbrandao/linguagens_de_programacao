reverter :: [Int] -> [Int]
reverter [] = []
reverter (a:v) = reverter v ++ [a]

trocar :: Int -> [Int]
trocar valor = reverter (trocarAux valor)

trocarAux :: Int -> [Int]
trocarAux 0 = []
trocarAux valor
    | valor >= 100  =  [100]   ++ trocarAux (valor - 100)
    | valor >= 50   =  [50]    ++ trocarAux (valor - 50)
    | valor >= 10   =  [10]    ++ trocarAux (valor - 10)
    | valor >= 5    =  [5]     ++ trocarAux (valor - 5)
    | otherwise     =  [1]     ++ trocarAux (valor - 1)
