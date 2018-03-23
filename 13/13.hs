import Data.List.Split
import Data.List (nub, elemIndex)

main = do
  --let file = "0: 3\n1: 2\n4: 4\n6: 4"
  file <- readFile "input.txt"
  let ls = map toTup $ map words $ lines $ filter (':'/=) file
  print $ solve1 ls
  print $ solve2 10 ls
  --print $ elemIndex 0 $ map (\a -> solve2 a ls) [0..4000000]

toTup (d:r:[]) = (read d::Int, read r::Int)
toTup a = error (show a)


solve2 delay ls = sum $ map damage [0..layers]  where
  damage d = if d `notElem` depths then 0
             else if isCaught then 1
                  else 0
    where 
      isCaught = ((d+delay) `mod` (2 * ((getRange d) -1)))==0 
  getRange d = head [ r | (d', r) <- ls, d' == d] 
  layers = maximum $ depths
  (depths, ranges) = unzip ls


------------
solve1 ls = sum $ map damage [0..layers]  where
  damage d = if d `notElem` depths then 0
             else if isCaught then (d*getRange d) 
                  else 0
    where 
      isCaught = ((d) `mod` (2 * ((getRange d) -1)))==0 
  getRange d = head [ r | (d', r) <- ls, d' == d] 
  layers = maximum $ depths
  (depths, ranges) = unzip ls
