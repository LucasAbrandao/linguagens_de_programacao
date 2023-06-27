reverter :: [Int] -> [Int]
reverter [] = []
reverter (a:v) = reverter v ++ [a]

remove :: Int -> [Int] -> [Int]
remove 0 xs =  reverter xs
remove _ [] = []
remove n (x:xs) = remove (n-1) xs

removerFim :: Int -> [Int] -> [Int]
removerFim k xs
    | k <= 0 = xs
    | otherwise = remove k (reverter xs)
