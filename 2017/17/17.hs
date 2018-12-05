steps = 337
test = 217

main = do
    print $ solve 1 1 [0]
    print $ solve2  1 1 1

solve 2018 p xs = xs !! (p + 1)
solve n    p xs = solve (n + 1) p' xs'
  where p'  = (p + steps `mod` n + 1) `mod` n
        xs' = f ++ [n] ++ b
        (f, b) = splitAt p' xs

solve2 50000001 p res = res
solve2 n        p res = solve2 (n + 1) p' res'
  where !p'   = (p + steps `mod` n + 1) `mod` n
        !res' = if p' == 0 then n else res
