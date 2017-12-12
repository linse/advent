import Data.List (unfoldr)
import Numeric (showHex, showIntAtBase)
import Data.Char (intToDigit)
import Data.Char (ord)
import Data.Char (isSpace)
import Data.Bits
import Text.Printf
 
main = do
  filestring <- readFile "input.txt"
  let filearr = map (\d -> read d::Int) $ words $ map (\c -> if c==',' then ' ' else c) filestring
  --let file = [3, 4, 1, 5]
  --let l = [0 .. 4]
  let l = [0 .. 255]
  putStrLn $ show $ solve l 0 0 filearr

  let ascii = (map ord $ concat $ lines $ filestring) ++ [17, 31, 73, 47, 23]
  let (_, _, _, permut) = last $ solve2 64 l ascii
  let hash = concatMap hex $ map dense $ blocks permut
  putStrLn hash

dense :: [Int] -> Int
dense = foldr xor 0

blocks = splitEvery 16 where
  splitEvery n = takeWhile (not . null) . unfoldr ( Just . splitAt n)

hex = printf "%02x"

solve2 rounds seq lengths = hash rounds seq 0 0 lengths where 
  hash round permut pos ss [] 
    | round <= 1 = [(pos, ss, round, permut)]
    | otherwise = (pos, ss, round, []) : hash (round-1) permut pos ss lengths
  hash round permut pos ss (x:xs) = hash round permut' pos' ss' xs where 
      l = length permut
      (rev, keep) = splitAt x $ take l $ drop pos $ cycle permut
      permut' = take l $ drop (l - pos) $ cycle (reverse rev ++ keep)
      pos' = (pos + x + ss) `mod` l
      ss' = ss + 1

--------

solve list pos ss [] = foldl (*) 1 (take 2 list)
solve list pos ss (x:xs) = solve list' pos' ss' xs where 
    l = length list
    (rev, keep) = splitAt x $ take l $ drop pos $ cycle list
    list' = take l $ drop (l - pos) $ cycle (reverse rev ++ keep)
    pos' = (pos + x + ss) `mod` l
    ss' = ss + 1
