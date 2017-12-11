import System.Environment
import Data.List
import Data.Function
import Data.Char
import Data.Bits
 
main = do
  file <- readFile "input.txt"
  let input = words $ map (\c -> if c==',' then ' ' else c) file
  print $ solve input
  print $ maximum $ solve2 input
  print $ minimum $ solve2 input

solve xs = res
  where 
   count e xs = length $ filter (==e) xs
   n  = count "n"  xs
   s  = count "s"  xs
   nw = count "nw" xs
   ne = count "ne" xs
   sw = count "sw" xs
   se = count "se" xs
   n' = n - s
   nw' = nw - se
   ne' = ne - sw
   n'' = nw' + n' -- count nort component  
   ne'' = ne' - nw'
   res = n'' + ne'' -- count north component

solve2 = f (0, 0, 0)
  where 
   f (n, ne, nw) [] = [(nw + n) + (ne - nw)]
   f (n, ne, nw) (x:xs)
    | x=="n"  = sum:f (n+1, ne, nw) xs
    | x=="s"  = sum:f (n-1, ne, nw) xs
    | x=="ne" = sum:f (n, ne+1, nw) xs
    | x=="sw" = sum:f (n, ne-1, nw) xs
    | x=="nw" = sum:f (n, ne, nw+1) xs
    | x=="se" = sum:f (n, ne, nw-1) xs
    | otherwise = error $ show (n, ne, nw)
    where sum = (nw + n) + (ne - nw)
