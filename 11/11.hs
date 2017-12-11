import System.Environment
import Data.List
import Data.Function
import Data.Char
import Data.Bits
 
main = do
  file <- readFile "input.txt"
  putStrLn $ show $ solve $ words $ map (\c -> if c==',' then ' ' else c) file
  putStrLn $ show $ maximum $ solve2 $ words $ map (\c -> if c==',' then ' ' else c) file
  putStrLn $ show $ minimum $ solve2 $ words $ map (\c -> if c==',' then ' ' else c) file

solve xs = res
  where 
   n = length $ filter (\a -> a=="n") xs 
   s = length $ filter (\a -> a=="s") xs 
   nw = length $ filter (\a -> a=="nw") xs 
   ne = length $ filter (\a -> a=="ne") xs 
   sw = length $ filter (\a -> a=="sw") xs 
   se = length $ filter (\a -> a=="se") xs 
   n' = n - s
   nw' = nw - se
   ne' = ne - sw
   n'' = nw' + n' -- count nort component  
   ne'' = ne' - nw'
   res = n'' + ne'' -- count north component

solve2 = solve' (0, 0, 0)
  where 
   solve' (n, ne, nw) [] = [(nw + n) + (ne - nw)]
   solve' (n, ne, nw) (x:xs)
    | x=="n" = sum:solve' (n+1, ne, nw) xs
    | x=="s" = sum:solve' (n-1, ne, nw) xs
    | x=="ne" = sum:solve' (n, ne+1, nw) xs
    | x=="sw" = sum:solve' (n, ne-1, nw) xs
    | x=="nw" = sum:solve' (n, ne, nw+1) xs
    | x=="se" = sum:solve' (n, ne, nw-1) xs
    | otherwise   = error $ show (n, ne, nw)
    where sum = (nw + n) + (ne - nw)
