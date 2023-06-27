existe :: Int -> [Int] -> Bool
existe _ [] = False
existe  x (a:v)
    | x == a    = True
    | otherwise = existe x v



distintos :: [Int] -> Bool
distintos [] = True
distintos (a:k)
    | existe a k    = False
    | otherwise = distintos k