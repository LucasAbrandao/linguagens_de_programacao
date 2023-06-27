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


reverter :: [Int] -> [Int]
reverter [] = []
reverter (a:v) = reverter v ++ [a]

posicaoAux :: Int -> Int -> [Int] -> Int
posicaoAux _ _ [] = 0
posicaoAux a p (x:v)
    | a == x    = p
    | otherwise = posicaoAux a (p+1) v

posicao :: Int -> [Int] -> Int
posicao n l = posicaoAux n 1 l


