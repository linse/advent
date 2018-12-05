alist = [int(line.rstrip()) for line in open('input.txt')]
#alist = [+1, -2, +3, +1]
print (sum(alist))

from itertools import accumulate

alist = alist * 150
current = list(accumulate(alist))
freqs = [ (cur+chng) for (cur, chng) in zip([0] + current, alist) ]
#print (freqs)

seen = []
for freq in freqs:
  if not freq in seen: 
    seen.append(freq)
  else:
    print(freq)
    break
