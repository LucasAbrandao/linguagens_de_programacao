intercalar :: [Int] -> [Int] -> [Int]
intercalar v1 [] = v1
intercalar [] v2 = v2
intercalar (x:v1) (y:v2)
    | x <= y    = [x] ++ intercalar v1 (y:v2)
    | otherwise = [y] ++ intercalar (x:v1) v2
