import Data.List (unfoldr, nub, sort)
import Numeric (showHex, showIntAtBase)
import Data.Char (intToDigit, isAlpha)
import Data.Char (ord)
import Data.Char (isSpace)
import Data.Bits
import Text.Printf
import Data.List.Split
import Data.Binary
 
main = do
  file <- readFile "input.txt"
  --let file = "set a 1\nadd a 2\nmul a a\nmod a 5\nsnd a\nset a 0\nrcv a\njgz a -1\nset a 1\njgz a -2"
  putStrLn $ show $ parse $ file

type Mem = [(String, Int)]

memory :: String -> Mem
memory f = zip registers (repeat 0) where
  registers = tail $ splitOn "" $ (filter isAlpha) . sort . nub . concatMap (head . tail . words) $ lines f

alter :: Eq a => (Int -> Int) -> a -> [(a, Int)] -> [(a, Int)]
alter f a = map (\(x, y) -> if x == a then (x, f y) else (x, y)) 

val :: Mem -> String -> Int
val mem w = if isAlpha (head w) then head [ y | (x, y) <- mem, x==w ] else read w

parse :: String -> (([Int], [Int]), Mem)
parse f = parse' (([],[]), (memory f)) $ allCmds where
  allCmds = map words $ lines f
  parse' st [] = st
  parse' st ((cmd:x:ys):cs) = parse' st' cs where
    st' = case cmd of
      "set"     -> set' st x y'
      "add"     -> add' st x y'
      "mul"     -> mul' st x y'
      "mod"     -> mod' st x y'
      "jgz"     -> if x' > 0 then parse' st cs' else st
      "snd"     -> snd' st x
      "rcv"     -> rcv' st x
      c -> error $ "command " ++ show c ++ " unknown"
      where x' = val mem x
            y' = val mem y
            (snds, mem) = st
            --(snds', mem') = st'
            [y] = ys -- lazy matching
            -- jump for y' (e.g. -2) and add +1 do do our own again
            cs' = drop (length allCmds - (length cs - y'+1)) allCmds
 
set' (snds, mem) x y = (snds, alter (\x -> y) x mem)
add' (snds, mem) x y = (snds, alter (\x -> x + y) x mem)
mul' (snds, mem) x y = (snds, alter (\x -> x * y) x mem)
mod' (snds, mem) x y = (snds, alter (\x -> x `mod` y) x mem)
snd' ((r,s),    mem) x = ((r, val mem x:s), mem) -- play sound
rcv' ((r,s:ss), mem) x = if val mem x /= 0 then error ("first "++show ((s:r,ss), mem)) else ((r,s:ss), mem)
rcv' ((r,[]), mem) x = if val mem x /= 0 then error ("No earlier freq to recv "++show r) else ((r, []), mem)
