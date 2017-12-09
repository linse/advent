val filename = "input.txt"
var registers = collection.mutable.Map[String,Int]()
var max = 0

val t = io.Source.fromFile(filename).mkString
//val t = "b inc 5 if a > 1\na inc 1 if b < 5\nc dec -10 if a >= 1\nc inc -20 if c == 10" 

t.mkString.split("\n").map { l =>
  val reg = l.split(" ")(0)
  registers(reg) = 0
}

t.mkString.split("\n").map { line =>
    def check(cond: String): Boolean = {
      val reg :: rel :: num :: Nil = cond.split(" ").toList
      rel match {
        case "<" => registers(reg) < num.toInt
        case ">" => registers(reg) > num.toInt
        case "==" => registers(reg) == num.toInt
        case "!=" => registers(reg) != num.toInt
        case "<=" => registers(reg) <= num.toInt
        case ">=" => registers(reg) >= num.toInt
      }
    }
    
    def exec(comm: String) = {
      val reg :: op :: num :: Nil = comm.split(" ").toList
      op match {
        case "inc" => registers(reg) += num.toInt
        case "dec" => registers(reg) -= num.toInt
      } 
      if (registers(reg) > max) max = registers(reg)
    }
  
    val comm :: cond :: Nil = line.split(" if ").toList
    if (check(cond)) exec(comm)
}

//for ((k,v) <- registers) printf("key: %s, value: %s\n", k, v)
println(registers.maxBy(_._2))
println(max)
