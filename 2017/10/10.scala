//val seq = (0 to 4).toList
//val filestring = "3, 4, 1, 5"

val seq = (0 to 255).toList
val filestring = io.Source.fromFile("input.txt").mkString.trim

val filearr = filestring.split(",").map(_.toInt).toList

println("Solve", solve(seq, filearr))
println("KnotHash", knotHash(seq, filestring))

def hash(seq: List[Int], lengths: List[Int]): List[Int] = {
  def hash2(perm: List[Int], pos: Int, ss: Int, lst: List[Int]): List[Int] = {
    lst match {
      case Nil       => perm
      case x :: tail => {
        val l = perm.length
        def cycle(l: List[Int]) = Iterator.continually(l).flatten
        val (rev, keep) = cycle(perm).drop(pos).take(l).toList.splitAt(x)
        val perm2 = cycle(rev.reverse ++ keep).drop(l - pos).take(l).toList
        val pos2 = (pos + x + ss) % l
        hash2(perm2, pos2, ss + 1, tail)
      }
    }
  }
  hash2(seq, 0, 0, lengths)
}

def solve(seq: List[Int], lengths: List[Int]): Int = {
  val perm = hash(seq, lengths)
  perm.take(2).foldLeft(1)(_*_)
}

def knotHash(seq: List[Int], string: String): String = {
  def dense(blk: List[Int]) = blk.foldLeft(0)(_^_)
  def hex(v: Int) = "%02x".format(v)

  val ascii = string.map(_.toInt).toList ++ List(17, 31, 73, 47, 23)
  val rounds = List.fill(64)(ascii).flatten
  val perm = hash(seq, rounds)
  val blocks = perm.grouped(16).toList
  blocks.map(dense).flatMap(hex).mkString
}
