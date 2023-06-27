substituir :: Int -> Int-> [Int] -> [Int] 
substituir _ _ [] = []
substituir a b (x:v) 
    | x == a        =  [b] ++ substituir a b v
    | otherwise     =  [x] ++ substituir a b v