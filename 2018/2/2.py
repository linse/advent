alist = [line.rstrip() for line in open('input.txt')]
#alist = ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]

from collections import Counter

# select boxes according to part 1

def twices(s): 
  counter = Counter(s)
  return any(value == 2 for value in counter.values())

def thrices(s): 
  counter = Counter(s)
  return any(value == 3 for value in counter.values())

print (Counter([(twices(s)) for s in alist])[True]
     * Counter([(thrices(s)) for s in alist])[True])

alist = [l for l in alist if twices(l) or thrices(l)]

# part 2

def remove_pos(s, i):
  return s[0:i] + s[i+1:]

for i in range(len(alist[0])):
  common = [remove_pos(s,i) for s in alist]
  if twices(common):
    for k, v in Counter(common).items():
      if 2 == v:
        print(k)
    break
