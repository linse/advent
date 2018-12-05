import Data.List (unfoldr, nub, sort, elemIndex)
import Numeric (showHex, showIntAtBase)
import Data.Char (intToDigit, isAlpha)
import Data.Char (ord)
import Data.Char (isSpace)
import Data.Bits
import Text.Printf
import Data.List.Split
import Data.Binary
import Data.Tuple (swap)
import Data.Array
 
data Direction = Up | Dwn | Lft | Rgt deriving Show

main = do
  file <- readFile "test.txt"
  --file <- readFile "input.txt"
  let arr = parse file
  let start = getStart arr
  putStrLn $ show $ step ("", Dwn, start, arr)

step (accu, dir, (x, y), arr) = (accu, dir, (x', y'), arr) where
  dir' = case (dir, arr ! (x, y)) of
    (Dwn, '|') -> Dwn
    (Up,  '|') -> Up
    (Lft, '-') -> Lft
    (Rgt, '-') -> Rgt
    (Dwn, '+') -> if (arr ! (x-1, y)=='-') then Lft else Rgt
    (Up,  '+') -> if (arr ! (x-1, y)=='-') then Lft else Rgt
    (Lft, '+') -> if (arr ! (x, y-1)=='|') then Up else Dwn
    (Rgt, '+') -> if (arr ! (x, y-1)=='|') then Up else Dwn
  (x', y') = case dir of
    (Up)  -> (x, y-1)
    (Dwn) -> (x, y+1)
    (Lft) -> (x-1, y)
    (Rgt) -> (x+1, y)
  

parse :: String -> Array (Int, Int) Char
parse x = listArray ((1,1),(m-1,n-1)) $ concat $ lines x
  where n = length $ head $ lines x
        m = length $ lines x

getStart arr = head [ i | (i,e) <- assocs arr, e=='|' ]
