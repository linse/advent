var input = "0: 3\n1: 2\n4: 4\n6: 4"

var data = input.split("\n").map(_.split(": "))
data.map{ case a :: b :: Nil => (a, b) }



println(data(0)(0))
