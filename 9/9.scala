// JAVA_OPTS="-Xmx4G -Xss4G" scala 9.scala

val filename = "input.txt"

val t = io.Source.fromFile(filename).mkString
//val t = "{}\n{{{}}}\n{{},{}}\n{{{},{},{{}}}}\n{{<ab>},{<ab>},{<ab>},{<ab>}}\n{{<!!>},{<!!>},{<!!>},{<!!>}}\n{{<a!>},{<a!>},{<a!>},{<ab>}}" 

def score(d: Int, s: String): Int = {
  if (s.isEmpty) return 0
  s.head match {
    case '{' => d + score(d+1, s.tail)  
    case '}' =>     score(d-1, s.tail) 
    case '<' =>     garbage(d, s.tail) 
    case  _  =>       score(d, s.tail) 
  }
}

def garbage(d: Int, s: String): Int = {
  if (s.isEmpty) return 0
  s.head match {
    case '>' =>   score(d, s.tail) 
    case '!' => garbage(d, s.tail.tail) 
    case  _  => garbage(d, s.tail) 
  }
}
 
println(score(1, t))

//////////////////////////////////////

def score2(s: String): Int = {
  if (s.isEmpty) return 0
  s.head match {
    case '<' => garbage2(s.tail) 
    case _ =>     score2(s.tail) 
  }
}

def garbage2(s: String): Int = {
  if (s.isEmpty) return 0
  s.head match {
    case '>' =>       score2(s.tail) 
    case '!' =>     garbage2(s.tail.tail) 
    case  _  => 1 + garbage2(s.tail) 
  }
}
 
println(score2(t))
