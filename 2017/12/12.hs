import Data.List.Split
import Data.List (nub)

main = do
  --let file = "0 <-> 2\n1 <-> 1\n2 <-> 0, 3, 4\n3 <-> 2, 4\n4 <-> 2, 3, 6\n5 <-> 6\n6 <-> 4, 5"
  file <- readFile "input.txt"
  let edges = nub $ map toInt $ concatMap parseLine $ lines $ file
  let group0 = members 0 edges
  print $ length group0
  print $ groups edges
 where
    parseLine x = pipes $ tuple $ splitOn " <-> " x
    pipes (a, bs) = zip (repeat a) bs
    tuple (a:b:_) = (a, splitOn ", " b)
    toInt (s, t) = (read s::Int, read t::Int)

groups []    = 0
groups edges = 1 + groups edges'
   where
    edges' = remove grp edges
    grp = members (fst $ head edges) edges
    remove grp = filter (\(x,y) -> x `notElem` grp || y `notElem` grp)

members n edges = members' (-1) (expand n) where
    members' l group = if (l==l') then group
                                  else members' l' group'
      where group' = nub . concatMap expand $ group
            l'     = length group'
    neigh a = [ y | (x, y) <- edges, x==a ] ++ [ x | (x, y) <- edges, y==a ]
    expand a = [a] ++ neigh a

