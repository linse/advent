// JAVA_OPTS="-Xmx4G -Xss4G" scala 9.scala

val filename = "input.txt"

val s = io.Source.fromFile(filename).mkString
//val t = "{}\n{{{}}}\n{{},{}}\n{{{},{},{{}}}}\n{{<ab>},{<ab>},{<ab>},{<ab>}}\n{{<!!>},{<!!>},{<!!>},{<!!>}}\n{{<a!>},{<a!>},{<a!>},{<ab>}}" 

case class State(score: Int = 0,
                 gc: Int = 0,
                 d: Int = 0,
                 garbage: Boolean = false,
                 skip: Boolean = false) {
  def read(c: Char): State = c match {
    case  _  if     skip => copy(skip = false)
    case '!' if  garbage => copy(skip = true)
    case '<' if !garbage => copy(garbage = true)
    case '>' if  garbage => copy(garbage = false)
    case  _  if  garbage => copy(gc = gc + 1)
    case '{' => copy(d = d+1)
    case '}' => copy(d = d-1, score = score + d)
    case  _  => this
  }
}

val result = s.foldLeft(State())(_ read _)
println(result.score)
println(result.gc)
