input = "14	0	15	12	11	11	3	5	1	6	8	4	9	1	8	4"

test = "0	2	7	0"

function solve(inp) {
  blocks = inp.split('\t').map(function(a) {return parseInt(a,10)});
  seen = []
  cyc = 1
  goal = ""
  while(true) {
    max = blocks.reduce(function(a,b) { return Math.max(a,b) })
    index = blocks.indexOf(max)
    //console.log(blocks, max, index, cyc)
    blocks = redist(max+1,index,blocks)
    if (seen.indexOf(blocks.toString()) !== -1) {
     console.log(cyc)
     goal = blocks.toString()
     break
    }
    else {
     seen.push(blocks.toString())
     cyc++
    }
  }
  seen = []
  cyc = 1
  while(true) {
    max = blocks.reduce(function(a,b) { return Math.max(a,b) })
    index = blocks.indexOf(max)
    //console.log(blocks, max, index, cyc)
    blocks = redist(max+1,index,blocks)
    if (blocks.toString() === goal) {
     console.log(cyc)
     break
    }
    else {
     seen.push(blocks.toString())
     cyc++
    }
  }

}

function redist(val, index, blocks) { 
  blocks[index] = 0
  for (i=index+1; val > 0; i++) {
    if (i>=blocks.length){
      i=0
    }
    if (val > 1) {
      blocks[i]++
      val--
    } else {
      return blocks
    }
  }
}

//console.log(solve(test))
console.log(solve(input))

