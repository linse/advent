import Data.List (unfoldr, nub, sort)
import Numeric (showHex, showIntAtBase)
import Data.Char (intToDigit, isAlpha)
import Data.Char (ord)
import Data.Char (isSpace)
import Data.Bits
import Text.Printf
import Data.List.Split
import Data.Binary
import Data.Tuple (swap)
 
main = do
  --file <- readFile "input.txt"
  --let file = "set a 1\nadd a 2\nmul a a\nmod a 5\nsnd a\nset a 0\nrcv a\njgz a -1\nset a 1\njgz a -2"
  let file = "snd 1\nsnd 2\nsnd p\nrcv a\nrcv b\nrcv c\nrcv d"
  --putStrLn $ show $ parse $ file
  --putStrLn $ show $ initMem $ file
  let allCmds = cmds file
  putStrLn $ show $ (runProgs allCmds) $ initStates $ file
  --putStrLn $ show $ parse2 $ file

data Arg = Num Int | Reg String deriving Show
data Cmd = Set String Arg | Add String Arg | Mul String Arg | Mod String Arg deriving Show
type Cell = (String, Int)
data Prog = Prog { rcvd :: [Int], snt :: [Int], mem :: [Cell], cmdz :: [Cmd] }
  deriving Show


initStates :: String -> (Prog, Prog)
initStates f = (progState 0, progState 1)
 where progState p = Prog { rcvd=[], snt=[], mem=initMemP p f, cmdz=cmds f }

       initMem f = zip registers (repeat 0) where
         registers = chunksOf 1 . nub . filter isAlpha . concatMap (head . tail) $ cmds f
       
       initMemP p f = ("p", p) : (filter ((/="p") . fst) $ initMem f)

cmds :: String -> [Cmd]       
cmds f = map words $ lines f

--runProgs :: [Cmd] -> (Prog, Prog) -> (Prog, Prog)
--runProgs allCmds (a, b) = case (cmdz a



-- runProgs allCmds (p1@(_, _, []), p2@(_,_,[])) = (p1, p2)
-- runProgs allCmds (p1, p2) = runProgs allCmds (p1'', p2'') where
--   (p1'', p2'') = case (fstCmd p1', fstCmd p2') of
--     ("snd",  rcv ) -> send p1' p2' 
--     ( rcv , "snd") -> swap $ send p2' p1' 
--     _              -> (p1', p2')
--    where fstCmd (snds, mem, (c:_):cs) = c
--          fstCmd (snds, mem, []) = ""
--          p1' = runProg allCmds p1
--          p2' = runProg allCmds p2
--          send (snds1, mem1, ("snd":x1:ys1):cs1) ((r, s), mem2, cs2) = ((snds1, mem1, cs1), ((r, x1':s), mem2, cs2))
--            where x1' = val mem1 x1
--          val :: Mem -> String -> Int
--          val mem w = if isAlpha (head w) then head [ y | (x, y) <- mem, x==w ] else read w
--  
-- ------            snd' ((r,s),    mem) x = ((r, x':s), mem) -- play sound
-- runProg :: Cmds -> ProgState -> ProgState
-- 
-- runProg allCmds (snds, mem, []) = (snds, mem, []) -- TODO what to return?
-- runProg allCmds (snds, mem, (("snd":x:ys):cs)) = (snds, mem, [])
-- runProg allCmds (snds@(_, []), mem, (("rcv":x:ys):cs)) = (snds, mem, [])
-- 
-- runProg allCmds (snds, mem, (("rcv":x:ys):cs)) = ((fst snds, reverse ss), alter (\x -> s) x mem, [])
--   where (s:ss) = reverse $ snd snds
--         alter :: (Int -> Int) -> String -> Mem -> Mem
--         alter f a = map (\(x, y) -> if x == a then (x, f y) else (x, y)) 
--   
-- runProg allCmds (snds, mem, (("jgz":x:ys):cs)) = if x' > 0 then runProg allCmds (snds, mem, cs') else runProg allCmds (snds, mem, cs)
--   where x' = val mem x
--         y' = val mem y
--         [y] = ys
--         cs' = drop (length allCmds - (length cs - y'+1)) allCmds
-- 
--         val :: Mem -> String -> Int
--         val mem w = if isAlpha (head w) then head [ y | (x, y) <- mem, x==w ] else read w
--   
-- runProg allCmds (snds, mem, ((cmd:x:ys):cs)) = runProg allCmds (snds', mem', cs) where
--   (snds', mem') = case cmd of
--     "set"     -> op (\x -> y')
--     "add"     -> op (\x -> x + y')
--     "mul"     -> op (\x -> x * y')
--     "mod"     -> op (\x -> x `mod` y')
--     c -> error $ "command " ++ show c ++ " unknown"
--     where x' = val mem x
--           y' = val mem y
--           [y] = ys
--           op f = (snds, alter f x mem)
-- 
--   val :: Mem -> String -> Int
--   val mem w = if isAlpha (head w) then head [ y | (x, y) <- mem, x==w ] else read w
--   
--   alter :: (Int -> Int) -> String -> Mem -> Mem
--   alter f a = map (\(x, y) -> if x == a then (x, f y) else (x, y)) 
  
    
  

--initStates :: String -> (ProgState, ProgState)
--initStates f = alter2 (\x -> 1) "p" ((([],[]), memory $ f++"\nset p 0"), (([],[]), memory $ f++"\nset p 0"))
--alter  f a = map (\(x, y) -> if x == a then (x, f y) else (x, y)) 
--alter2 f a ((snds1, mem1), (snds2, mem2)) = ((snds1, mem1), (snds2, alter f a mem2))
--
--allCmds f = map words $ lines f
--
--parse3 f = communicate (state1, state2) where
--  state1 = run (allCmds f) (fst $ initStates f) (allCmds f)
--  state2 = run (allCmds f) (snd $ initStates f) (allCmds f)
--
--communicate = error "hi" -- ((snds1, mem1), (snds2, mem2)) = "hi" where
----          snd' ((r,s),    mem) x = ((r, x':s), mem) -- play sound
----          --rcv' ((r,s:ss), mem) x = if x' /= 0 then error ("first "++(show $ fst $ fst ((s:r,ss), mem))) else ((r,s:ss), mem)
----          rcv' ((r,s:ss), mem) x = if x' /= 0 then error (show ((s:r,ss), mem)) else ((r,s:ss), mem)
----          rcv' ((r,[]),   mem) x = if x' /= 0 then error ("No earlier freq to recv "++show r) else ((r, []), mem)
--
--run :: [[String]] -> ProgState -> [[String]] -> (ProgState, [[String]])
--run allCmds st [] = (st, [])
--run allCmds st ((cmd:x:ys):cs) = run allCmds st' cs where
--  st' = case cmd of
--    "set"     -> op (\x -> y')
--    "add"     -> op (\x -> x + y')
--    "mul"     -> op (\x -> x * y')
--    "mod"     -> op (\x -> x `mod` y')
--    "jgz"     -> if x' > 0 then run allCmds st cs' else (st, ((cmd:x:ys):cs))
--    "snd"     -> (st, ((cmd:x:ys):cs)) --snd' st x
--    "rcv"     -> (st, ((cmd:x:ys):cs)) --rcv' st x
--    c -> error $ "command " ++ show c ++ " unknown"
--    where x' = val mem x
--          y' = val mem y
--          (snds, mem) = st
--          [y] = ys -- lazy match
--          -- jump for y' (e.g. -2) and add +1 do do our own again
--          cs' = drop (length allCmds - (length cs - y'+1)) allCmds
--          op f = (snds, alter f x mem)
--
--  alter :: (Int -> Int) -> String -> Mem -> Mem
--  alter f a = map (\(x, y) -> if x == a then (x, f y) else (x, y)) 
--  
--  val :: Mem -> String -> Int
--  val mem w = if isAlpha (head w) then head [ y | (x, y) <- mem, x==w ] else read w
--  
--  memory :: String -> Mem
--  memory f = zip registers (repeat 0) where
--    registers = tail $ splitOn "" $ (filter isAlpha) . sort . nub . concatMap (head . tail . words) $ lines f

-------------------

--parse2 :: String -> (ProgState, ProgState)
--parse2 f = parse2' initStates allCmds allCmds where
--  initStates :: (ProgState, ProgState)
--  initStates = alter2 (\x -> 1) "p" ((([],[]), memory $ f++"\nset p 0"), (([],[]), memory $ f++"\nset p 0"))
--  allCmds = map words $ lines f
--  parse2' sts [] cs2 = sts
--  parse2' sts ((cmd:x:ys):cs) cs2 = parse2' sts' cs cs2 where
--    sts' = case cmd of
--      "set"     -> op (\x -> y')
--      "add"     -> op (\x -> x + y')
--      "mul"     -> op (\x -> x * y')
--      "mod"     -> op (\x -> x `mod` y')
--      --"jgz"     -> if x' > 0 then parse' sts cs' else sts
--      c -> error $ "command " ++ show c ++ " unknown"
--      where y' = val mem1 y
--            x' = val mem1 x
--            ((snds1, mem1), (snds2, mem2)) = sts
--            [y] = ys -- lazy matching
--            op f = ((snds1, alter f x mem1), (snds2, alter f x mem2))
--            
--            -- jump for y' (e.g. -2) and add +1 do do our own again
--            cs' = drop (length allCmds - (length cs - y'+1)) allCmds
-- 
------            snd' ((r,s),    mem) x = ((r, x':s), mem) -- play sound
------            rcv' ((r,s:ss), mem) x = error""--if x' /= 0 then error ("first "++(show $ fst $ fst ((s:r,ss), mem))) else ((r,s:ss), mem)
------            rcv' ((r,[]), mem)   x = error""--if x' /= 0 then error ("No earlier freq to recv "++show r) else ((r, []), mem)
--  alter :: Eq p2 => (Int -> Int) -> p2 -> [(p2, Int)] -> [(p2, Int)]
--  alter  f a = map (\(x, y) -> if x == a then (x, f y) else (x, y)) 
--  alter2 f a ((snds1, mem1), (snds2, mem2)) = ((snds1, mem1), (snds2, alter f a mem2))
--
--
--val mem w = if isAlpha (head w) then head [ y | (x, y) <- mem, x==w ] else read w

---------------------------


--parse :: String -> (([Int], [Int]), Mem)
--parse f = parse' allCmds initState allCmds where
--  initState = (([],[]), memory f)
--  allCmds = map words $ lines f
--  parse' allCmds st [] = st
--  parse' allCmds st ((cmd:x:ys):cs) = parse' allCmds st' cs where
--    st' = case cmd of
--      "set"     -> op (\x -> y')
--      "add"     -> op (\x -> x + y')
--      "mul"     -> op (\x -> x * y')
--      "mod"     -> op (\x -> x `mod` y')
--      "jgz"     -> if x' > 0 then parse' allCmds st cs' else st
--      "snd"     -> snd' st x
--      "rcv"     -> rcv' st x
--      c -> error $ "command " ++ show c ++ " unknown"
--      where x' = val mem x
--            y' = val mem y
--            (snds, mem) = st
--            [y] = ys -- lazy match
--            -- jump for y' (e.g. -2) and add +1 do do our own again
--            cs' = drop (length allCmds - (length cs - y'+1)) allCmds
--  
--            op f = (snds, alter f x mem)
--            snd' ((r,s),    mem) x = ((r, x':s), mem) -- play sound
--            --rcv' ((r,s:ss), mem) x = if x' /= 0 then error ("first "++(show $ fst $ fst ((s:r,ss), mem))) else ((r,s:ss), mem)
--            rcv' ((r,s:ss), mem) x = if x' /= 0 then error (show ((s:r,ss), mem)) else ((r,s:ss), mem)
--            rcv' ((r,[]),   mem) x = if x' /= 0 then error ("No earlier freq to recv "++show r) else ((r, []), mem)
--  
--  alter :: (Int -> Int) -> String -> Mem -> Mem
--  alter f a = map (\(x, y) -> if x == a then (x, f y) else (x, y)) 
--  
--  val :: Mem -> String -> Int
--  val mem w = if isAlpha (head w) then head [ y | (x, y) <- mem, x==w ] else read w
--  
--  memory :: String -> Mem
--  memory f = zip registers (repeat 0) where
--    registers = tail $ splitOn "" $ (filter isAlpha) . sort . nub . concatMap (head . tail . words) $ lines f
