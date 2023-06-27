binario :: Int -> [Int] 
 
binario x
    | x >= 2  =   binario (x `div` 2) ++  [(x`mod`2)] 
    | x == 1 = [1]
    | x == 0 = [0]