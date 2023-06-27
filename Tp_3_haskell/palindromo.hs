reverter :: [Int] -> [Int]
reverter [] = []
reverter (a:v) = reverter v ++ [a]

palindromo :: [Int] -> Bool
palindromo [] = True
palindromo [_] = True
palindromo a
    | a == reverter a  = True
    | otherwise        = False 