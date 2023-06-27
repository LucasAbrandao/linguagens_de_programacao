linearizar :: [[Int]] -> [Int]
linearizar [] = []
linearizar (a:xs) = a ++ linearizar xs