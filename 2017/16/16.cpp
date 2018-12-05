#include <iostream>
#include <string>
#include <map>
#include <sstream>

std::string solve(std::string moves, std::string seq) {
  std::stringstream str(moves);
  char mv;
  while (str >> mv) {
    if (mv == 's') {
      int s;
      str >> s;
      std::rotate(seq.begin(), seq.begin() + (seq.size() - s), seq.end());
    } else if (mv == 'x') {
      int i, j; 
      str >> i >> mv >> j;
      std::swap(seq[i], seq[j]);
    } else if (mv == 'p') {
      char a, b; 
      str >> a >> mv >> b;
      int ai, bi;
      for(int i = 0; i < seq.size(); i++) {
        if(seq[i] == a) {
          ai = i;
        }
        if (seq[i] == b) {
          bi = i;
        }
      }
      std::swap(seq[ai], seq[bi]);
    }
    str >> mv;
  }
  return seq;
}

std::string solve2(std::string moves, std::string seq) {
  char cmd;
  std::map<std::string, int> seen;
  for (int d = 1; d <= 1000000000; d++) {
    seq = solve(moves, seq);
    if (seen.count(seq)) {
      if ((1000000000 - d) % (d - seen[seq]) == 0) {
        return seq;
      }
    }
    seen[seq] = d;
  }
  return seq;
}

// g++ 16.cpp && cat input.txt | ./a.out
int main(){
  std::string moves; 
  std::cin >> moves;
  std::string seq = "abcdefghijklmnop";
  std::cout << solve(moves, seq) << std::endl;
  std::cout << solve2(moves, seq) << std::endl;
}
