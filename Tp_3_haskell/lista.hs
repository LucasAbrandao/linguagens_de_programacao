existe :: Int -> [Int] -> Bool
existe _ [] = False

existe  x (a:v)
    | x == a    = True
    | otherwise = existe x v


maior :: [Int] -> Int
maior [] = 0
maior (a:as)
	| as == []  = a 
	| a > maior as = a 
	| otherwise = maior as

existe :: Int -> [Int] -> Int





reverter :: [Int] -> [Int]
reverter [] = []
reverter (a:v) = reverter v ++ [a]