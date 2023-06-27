existe :: Int -> [Int] -> Bool
existe _ [] = False
existe  x (a:v)
    | x == a    = True
    | otherwise = existe x v

disjuntas :: [Int] -> [Int] -> Bool
disjuntas [] _ = True 
disjuntas (a:v1) v2
    |   existe a v2 = False
    |   otherwise   = disjuntas v1 v2 

