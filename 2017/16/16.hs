import Data.List (unfoldr, elemIndex)
import Numeric (showHex, showIntAtBase)
import Data.Char (intToDigit)
import Data.Char (ord)
import Data.Char (isSpace)
import Data.Bits
import Text.Printf
import Data.List.Split
import Data.Binary
 
main = do
  file <- readFile "input.txt"
  seq  <- getLine
  --putStrLn $ show $ run $ reverse ["s1", "x3/4", "pe/b"]
  --putStrLn $ show $ run $ reverse $ splitOn "," file
  putStrLn $ run seq $ reverse $ splitOn "," file
  
run :: String -> [String] -> String
run seq ((move:args):ls) = case move of
    's' -> spin s rec
    'x' -> exchange i j rec
    'p' -> partner x y rec
   where
    rec = run seq ls
    s = read $ args
    (i:j:[]) = map read $ splitOn "/" $ args
    (x:'/':y:[]) = args
--run [] = "abcde"
run seq [] = seq--['a'..'p']


spin x s = drop (length s-x) s ++ take (length s-x) s

partner i j ls = exchange x y ls
  where Just x = elemIndex i ls
        Just y = elemIndex j ls
 
exchange i j s = left ++ [s !! r] ++ middle ++ [s !! l] ++ right
  where (l, r) = if i < j then (i, j) else (j, i)
        left   = take l s
        middle = take (r - l - 1) (drop (l + 1) s)
        right  = drop (r + 1) s
