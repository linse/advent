import Data.List

-- rotate clockwise
rotCW  = map reverse . transpose

-- append column to grid
appCol = zipWith (\g c -> g ++ [c])

grid n = until (any $ elem n) (rotCW . appColUp) [[1]] where 
    -- new column grows upwards
    appColUp g = appCol g (reverse [i..j])
       where i = (sum $ map length g) + 1  -- 2. start new col 
             j = i + (length g) - 1 -- 3. end new col

steps n = h + v
  where g = grid n
        h = dist n g
        v = dist n (rotCW g)
        dist k g = abs $ (pos k) - (pos 1)
         where pos n = head $ findIndices (==n) $ head $ filter (elem n) g

--------------------------

subseq n k as = drop n $ take k as
-- windows of neighbors
windows s = take 2 s : [subseq i j s | i<-[0..n], j<-[0..n], i<j, j-i==3 ] ++ [ reverse $ take 2 $ reverse s ]
  where n = length s

grid2 n = until (\a -> any (>n) $ concat a) (rotCW . appColUp2) [[1]] where 
  -- new column grows upwards
  appColUp2 t = appCol t (reverse $ newCol t)

  newCol t = [elm n | n <- [0..(length(t)-1)]] where
    elm 0 = sumNbrs!!0
    elm n = sumNbrs!!n + elm (n-1)
    sumNbrs = reverse $ map sum $ windows $ map last t

firstGreater n = head $ filter (> n) $ sort $ concat $ grid2 n
