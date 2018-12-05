import Data.List (unfoldr)
import Numeric (showHex, showIntAtBase)
import Data.Char (intToDigit)
import Data.Char (ord)
import Data.Char (isSpace)
import Data.Bits
import Text.Printf
import Data.List.Split
import Data.Binary
 
main = do
  --file <- readFile "input.txt"
  let string = ""
  putStrLn $ ""--solve 
  --putStrLn $ unlines $ map show $ solve2 stringst 

t = (65, 8921)
r = (699, 124)

f = (16807, 48271)

generate mult prev = mod
  where (div, mod) = (prev * mult) `divMod` 2147483647

--solve :: [String]
--solve = map bin $ 

--solve = length $ filter (True==) $ zipWith (==) generated1 generated2
-- where
--  generated1 :: [String]
--  --generated1 = map bin $ take 40000000 $ drop 1 $ iterate (generate (fst f)) (fst t)
--  generated1 = map bin $ take 40 $ drop 1 $ iterate (generate (fst f)) (fst t)
--  generated2 :: [String]
--  --generated2 = map bin $ take 40000000 $ drop 1 $ iterate (generate (snd f)) (snd t)
--  generated2 = map bin $ take 40 $ drop 1 $ iterate (generate (snd f)) (snd t)

bin :: Integer -> String
bin a = reverse $ take 16 $ reverse $ printf "%016b" a

enc a = a --pack a

generated2 = map enc $ take 40 $ drop 1 $ iterate (generate (snd f)) (snd t)












--knotHash string = concatMap hex $ map dense $ blocks perm where
--  seq = [0..255]
--  perm = hash seq (concat $ replicate 64 ascii)
--  ascii = (map ord $ concat $ lines $ string) ++ [17, 31, 73, 47, 23]
--
--  dense :: [Int] -> Int
--  dense = foldr xor 0
--  
--  blocks = splitEvery 16 where
--    splitEvery n = takeWhile (not . null) . unfoldr ( Just . splitAt n)
--  
--  hex = printf "%08b"
--
--hash seq lengths = hash' seq 0 0 lengths where
--  hash' perm pos ss []     = perm
--  hash' perm pos ss (x:xs) = hash' perm' pos' (ss + 1) xs where 
--      l = length perm
--      (rev, keep) = splitAt x $ take l $ drop pos $ cycle perm
--      perm' = take l $ drop (l - pos) $ cycle (reverse rev ++ keep)
--      pos' = (pos + x + ss) `mod` l
