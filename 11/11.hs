main = do
  file <- readFile "input.txt"
  let input = words $ map (\c -> if c==',' then ' ' else c) file
  print $ last $ solve input
  print $ maximum $ solve input
  print $ minimum $ solve input

solve = f (0, 0, 0)
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
