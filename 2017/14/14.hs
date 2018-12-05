import Data.Array (Array, (!), (//), listArray, elems, indices, bounds)
import Data.List (nub, unfoldr)
import Data.Ix (inRange)
import Numeric (showHex, showIntAtBase)
import Data.Char (intToDigit)
import Data.Char (ord, isSpace)
import Data.Bits
import Text.Printf
import Data.List.Split
 
main = do
  let test   = "flqrgnkx"
  let string = "jzgqcdpd"
  print $ solve string
  print $ solve2 string

solve2 string = fst $ until done step (0, startArr) where 
  target = '1'
  startArr = listArray ((0, 0), (127, 127)) cells where
    cells = hashes string
  done (_, arr) = target `notElem` (elems arr)
  step (n, arr) = (n + 1, floodFill arr pos) where
    pos = firstTarget target arr
    firstTarget trgt a = head $ filter ((== trgt) . (a!)) $ indices a

showArray = unlines . chunksOf 128 . elems 

floodFill grid pos = floodNeighbors grid [pos]
 where 
  trgt = grid ! pos
  rep = '^'
  floodNeighbors a [] = a
  floodNeighbors a is = floodNeighbors (a//[(i, rep) | i <- good]) new
       where good = filter ((== trgt) . (a !)) is
             new  = filter (inRange $ bounds a) $ nub $ concatMap neighbors good
             neighbors (x, y) = [(x, y + 1), (x, y - 1), (x + 1, y), (x - 1, y)]

-----------

solve s = length $ filter (=='1') $ hashes s

-- input
hashes s = concatMap knotHash $ prepare s where
  prepare s = zipWith (\a b -> a ++ "-" ++ show b) (repeat s) [0..127]

knotHash string = concatMap hex $ map dense $ blocks perm where
  seq = [0..255]
  perm = hash seq (concat $ replicate 64 ascii)
  ascii = (map ord $ concat $ lines $ string) ++ [17, 31, 73, 47, 23]

  dense :: [Int] -> Int
  dense = foldr xor 0
  
  blocks = splitEvery 16 where
    splitEvery n = takeWhile (not . null) . unfoldr ( Just . splitAt n)
  
  hex = printf "%08b"

hash seq lengths = hash' seq 0 0 lengths where
  hash' perm pos ss []     = perm
  hash' perm pos ss (x:xs) = hash' perm' pos' (ss + 1) xs where 
      l = length perm
      (rev, keep) = splitAt x $ take l $ drop pos $ cycle perm
      perm' = take l $ drop (l - pos) $ cycle (reverse rev ++ keep)
      pos' = (pos + x + ss) `mod` l
