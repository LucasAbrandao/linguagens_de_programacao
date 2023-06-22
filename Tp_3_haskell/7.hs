existe :: Int -> [Int] -> Bool
existe _ [] = False

existe  x (a:v)
    | x == a    = True
    | otherwise = existe x v

distintos :: [Int] -> Bool

distintos [] = True
distintos (a:k)
    | existe a k == True    = False
    | otherwise = distintos k