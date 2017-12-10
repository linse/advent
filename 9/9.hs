import System.Environment
import Data.List
import Data.Function
 
main = do
  file <- readFile "input.txt"
  --let file = "{}\n{{{}}}\n{{},{}}\n{{{},{},{{}}}}\n{{<ab>},{<ab>},{<ab>},{<ab>}}\n{{<!!>},{<!!>},{<!!>},{<!!>}}\n{{<a!>},{<a!>},{<a!>},{<ab>}}" 
  putStrLn $ show $ score 1 file
  putStrLn $ show $ score2 file

score d [] = 0
score d (x:xs) = case x of 
  '{' -> d + score (d+1) xs 
  '}' ->     score (d-1) xs
  '<' ->     garbage d xs
  _   ->       score d xs

  where garbage d [] = 0
        garbage d (x:y:zs) = case x of
          '>' ->   score d (y:zs) 
          '!' -> garbage d    zs
          _   -> garbage d (y:zs)

score2 [] =  0
score2 (x:xs) = case x of
  '<' -> garbage2 xs 
  _   ->   score2 xs

  where garbage2 [] = 0
        garbage2 (x:y:zs) = case x of
          '>' ->       score2 (y:zs) 
          '!' ->     garbage2    zs 
          _   -> 1 + garbage2 (y:zs) 
