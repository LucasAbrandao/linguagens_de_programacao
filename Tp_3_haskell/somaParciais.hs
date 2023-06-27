somaParciais :: [Int] -> [Int]
somaParciais [] = []
somaParciais [x] = [x] 
somaParciais (a:b:xs) = [a] ++ somaParciais ([a+b] ++ xs) 