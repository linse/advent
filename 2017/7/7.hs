import System.Environment
import Network.HTTP
import Data.List
import Data.Function
 
main = do
  file <- readFile "input.txt"
  putStrLn $ solve file
  putStrLn $ show $ solve2 file

t = "pbga (66)\nxhth (57)\nebii (61)\nhavc (66)\nktlj (57)\nfwft (72) -> ktlj, cntj, xhth\nqoyq (66)\npadx (45) -> pbga, havc, qoyq\ntknk (41) -> ugml, padx, fwft\njptl (61)\nugml (68) -> gyxo, ebii, jptl\ngyxo (61)\ncntj (57)"

solve t = head [ a | a <- heads , not $ elem a $ concat tails]
 where
  heads = map ((\a -> head a).words.filter (/= ',')) $ (filter (isInfixOf "->")) $ lines t
  tails = map ((\a -> drop 3 a).words.filter (/= ',')) $ (filter (isInfixOf "->")) $ lines t

-------------------

solve2 t = head [ w + diff | (n,w,ks) <- nodes t, n==name]
  where 
    name = fst $ head $ head odd
    diff = consensus - outlier
    consensus = snd $ head $ head others
    outlier = snd $ head $ head odd
    (odd,others) = partition ((<= 1) . length) groups
    groups = groupBy ((==) `on` snd) diffKids
    (_, _, diffKids) = head $ drop (length trail - 2) trail
    trail = path . sumWeight . build $ t

-- transform tree
path (Node (n,w) kids) = (n, w, map get kids):(rec kids)
  where rec k = if null odd then [] else path $ head $ head odd
        (odd,others) = partition ((<= 1) . length) groups
        groups = groupBy ((==) `on` snd.get) kids

sumWeight (Node (n,w) kids) = Node (n,w + sum ((map weight) kids)) (map sumWeight kids)
  where weight (Node (n,w) kids) = w + sum ((map weight) kids)

-- build tree
build t = build' root
  where root = solve t
        build' r = Node (n, w) (map build' ks)
          where (n, w, ks) = node r t

-- bind input
node r t = head $ filter (\(a, w, cs) -> a==r) (nodes t)

nodes inp = map mkNode $ trim $ map words $ lines inp
  where trim = map (map (delete ','))
        weight w = read (init (tail w)) :: Int
        mkNode (a:w:_:cs) = (a,weight w,cs)
        mkNode (a:w:[]) = (a,weight w, []) -- leaf

get (Node a ks) = a

data Tree a = Node a [Tree a]
  deriving Show
