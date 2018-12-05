alist = [line.rstrip() for line in open('input.txt')]
#alist = ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]
#alist = [ "#123 @ 3,2: 5x4"]

def parse(lines):
  res = []
  for l in lines:
    (claim, _, pos, size) = l.split()
    claim = claim[1:] 
    x, y = pos[:len(pos)-1].split(",")
    w, h = size.split("x")
    claim = int(claim)
    x, y = int(x), int(y) 
    w, h = int(w), int(h) 
    res.append((claim, x, y, w, h))
  return res

claims = parse(alist)

lower_rights = [ (x+w, y+h) for (c, x, y, w, h) in claims ]
max_x = (max([x for (x, y) in lower_rights]))
max_y = (max([y for (x, y) in lower_rights]))

print("max x ", max_x, " max y ", max_y)

from array import *

T = []
for j in range(max_y + 1):
  line = []
  for i in range(max_x + 1):
    line.append('.')
  T.append(line)

overlapping = set()
res = 0
for c in claims:
  (claim, x, y, w, h) = c
  #print ("claim ", claim, x, y, w, h)
  for i in range(y, y+h):
    for j in range(x, x+w):
      if T[i][j] != '.':
        if (T[i][j] != 'X'):
          overlapping.add(int(T[i][j]))
        overlapping.add(claim)
        T[i][j] = 'X'
        res += 1
      # do nothing if already doubly claimed
      elif T[i][j] != 'X': 
        T[i][j] = str(claim)

print ("double claims", res)

#for l in T:
#  print ("".join(l))

#print ("overlapping", overlapping)
claim_ids = [ c for (c, x, y, w, h) in claims ]

print ("non-overlapping", set(claim_ids) - set(overlapping))

# slow solution
#for i in range(max_x + 1):
#  line = []
#  for j in range(max_y + 1):
#    line += char_for_point((i,j))
#  lines += line
#print (res)
#
#def in_claim(point, c):
#  (i, j) = point
#  (claim, x, y, w, h) = c
#  return (x <= i and i < x+w 
#      and y <= j and j < y+h) 
#
#res = 0
#
#def char_for_point(point):
#  global res
#  (i, j) = point
#  claimed = False
#  for c in claims:
#    if in_claim((i, j), c):
#      if not claimed:
#        claimed = True
#      else:
#        res += 1
#        return "X"
#  if claimed:
#    return "x"
#  else:
#    return "."
#
#lines = []
#for i in range(max_x + 1):
#  line = []
#  for j in range(max_y + 1):
#    line += char_for_point((i,j))
#  lines += line
#print (res)
#
#from collections import Counter
#print (Counter([ c for c in [l for l in lines] if c == 'X']))
