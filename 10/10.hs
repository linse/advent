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

  let ascii = (map ord $ rstrip $ filestring) ++ [17, 31, 73, 47, 23]
  let (_, _, _, permut) = last $ solve2 0 l ascii
  let hash = concatMap hex $ map dense $ blocks permut
  putStrLn hash

testblock = [65, 27, 9, 1, 4, 3, 40, 50, 91, 7, 6, 0, 2, 5, 68, 22]

dense :: [Int] -> Int
dense = foldr xor 0

blocks = splitEvery 16
 where
  splitEvery n = takeWhile (not . null) . unfoldr (Just . splitAt n)

hex = printf "%02x"

rstrip = reverse . dropWhile isSpace . reverse


solve2 rd lis lens = solve2' rd lis 0 0 lens
 where 
  solve2' round list pos ss [] 
    | round >= 63 = [(pos, ss, round, list)]
    | otherwise = (pos, ss, round, []) : solve2' (round+1) list pos ss lens
  solve2' round list pos ss (x:xs) = solve2' round list' pos' ss' xs
    where 
      l = length list
      (rev, keep) = splitAt x $ take l $ drop pos $ cycle list
      list' = take l $ drop (l - pos) $ cycle (reverse rev ++ keep)
      pos' = (pos + x + ss) `mod` l
      ss' = ss + 1

--------

solve list pos ss [] = foldl (*) 1 (take 2 list)
solve list pos ss (x:xs) = solve list' pos' ss' xs
  where 
    l = length list
    (rev, keep) = splitAt x $ take l $ drop pos $ cycle list
    list' = take l $ drop (l - pos) $ cycle (reverse rev ++ keep)
    pos' = (pos + x + ss) `mod` l
    ss' = ss + 1
