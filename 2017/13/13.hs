--import Data.List.Split
import Data.List (nub)

main = do
  --let file = "0: 3\n1: 2\n4: 4\n6: 4"
  file <- readFile "input.txt"
  print $ file
 where
    --parseLine x = pipes $ tuple $ splitOn " <-> " x
    pipes (a, bs) = zip (repeat a) bs
    --tuple (a:b:_) = (a, splitOn ", " b)
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

