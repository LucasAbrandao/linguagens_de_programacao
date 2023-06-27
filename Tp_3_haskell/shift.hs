shift :: Int -> [Int] -> [Int]
shift k xs
    | k <= 0 = xs
    | otherwise = shiftAux k xs []

shiftAux :: Int -> [Int] -> [Int] -> [Int]
shiftAux _ [] result = result
shiftAux 0 xs result = xs ++ result
shiftAux k (x:xs) result = shiftAux (k - 1) xs (result ++ [x])
