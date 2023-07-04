isDigit :: Char -> Bool
isDigit c = c >= '0' && c <= '9'

int2str :: Int -> String
int2str i = show i

str2int :: String -> Int
str2int s = read s

--início da parte de codificação
contar :: Char -> String -> Int
contar c (c1:s)
  | c /= c1 = 0
  | s == "" = 1
  | otherwise = 1 + contar c s

comprimir :: Char -> String -> String
comprimir c s = (int2str (contar c s)) ++ [c]

retirar :: Char -> String -> String
retirar c (c1:s)
  | c /= c1 = (c1:s)
  | s == "" = ""
  | otherwise = retirar c s

codificar :: String -> String
codificar "" = ""
codificar (c:s) = (comprimir c (c:s)) ++ (codificar (retirar c (c:s)))
--fim da parte de codificação

--início da parte de decodificação
quantidade :: String -> String
quantidade (c:s)
  | (isDigit c) = [c] ++ quantidade s
  | otherwise = ""

caracter :: String -> Char
caracter (c:s)
  | (isDigit c) = caracter s
  | otherwise = c

expandir :: Int -> Char -> String
expandir 0 _ = ""
expandir n c = [c] ++ (expandir (n-1) c)

remover :: String -> String
remover (c:s)
  | (isDigit c) = remover s
  | otherwise = s

decodificar :: String -> String
decodificar "" = ""
decodificar s = (expandir (str2int(quantidade s)) (caracter s)) ++ (decodificar (remover s))
--fim da parte de decodificação