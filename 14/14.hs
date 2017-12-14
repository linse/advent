import Data.List (unfoldr)
import Numeric (showHex, showIntAtBase)
import Data.Char (intToDigit)
import Data.Char (ord)
import Data.Char (isSpace)
import Data.Bits
import Text.Printf
 
main = do
  let seq = [0 .. 255]
  let string = zipWith (\a b-> a++"-"++show b) (repeat "jzgqcdpd") [0..127]
  putStrLn $ solve seq string 

solve seq string = show $length $filter (\a -> a=='1') $ concatMap (knotHash seq) $ string

knotHash seq string = concatMap hex $ map dense $ blocks perm where
  perm = hash seq (concat $ replicate 64 ascii)
  ascii = (map ord $ concat $ lines $ string) ++ [17, 31, 73, 47, 23]

  dense :: [Int] -> Int
  dense = foldr xor 0
  
  blocks = splitEvery 16 where
    splitEvery n = takeWhile (not . null) . unfoldr ( Just . splitAt n)
  
  hex = printf "%04b"

hash seq lengths = hash' seq 0 0 lengths where
  hash' perm pos ss []     = perm
  hash' perm pos ss (x:xs) = hash' perm' pos' (ss + 1) xs where 
      l = length perm
      (rev, keep) = splitAt x $ take l $ drop pos $ cycle perm
      perm' = take l $ drop (l - pos) $ cycle (reverse rev ++ keep)
      pos' = (pos + x + ss) `mod` l
