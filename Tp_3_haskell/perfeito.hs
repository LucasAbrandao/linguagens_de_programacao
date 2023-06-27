fatoresmod :: Int -> [Int]
fatoresmod 0 = []
fatoresmod n = [ i | i <- [1..n `div` 2], n `mod` i == 0 ]

soma :: [Int] -> Int 
soma [] = 0
soma (a:x)  = a + soma x

perfeito :: Int -> Bool 
perfeito 0 = True
perfeito x 
    |  soma (fatoresmod x) == x     = True 
    |  otherwise                    = False 

