// scala -cp  ~/.ivy2/cache/org.scalaz/scalaz-core_2.11/bundles/scalaz-core_2.11-7.1.0.jar 9mapAccum.scala
import scalaz.Traverse._

val filename = "input.txt"

//val s = io.Source.fromFile(filename).mkString
val s = "{}\n{{{}}}\n{{},{}}\n{{{},{},{{}}}}\n{{<ab>},{<ab>},{<ab>},{<ab>}}\n{{<!!>},{<!!>},{<!!>},{<!!>}}\n{{<a!>},{<a!>},{<a!>},{<ab>}}" 

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

// fold is better, we don't need to keep the list as we do here
s.toList.mapAccumL(State()) { (state, c) => (state.read(c), c) }
