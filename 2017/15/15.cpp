#include <iostream>

long step(long prev, long fact) {
  return (prev * fact) % 2147483647;
}

int solve1(int a, int b) {
  int matches = 0;
  for (long i=0; i<=40000000; i++) {
    a = step(a, 16807);
    b = step(b, 48271);
    //std::cout << a << " " << b << std::endl;

    std::bitset<16> bitsA(a);
    std::bitset<16> bitsB(b);
    if (bitsA == bitsB) { 
      matches++;
      //std::cout << "Match at step " << i + 1 << std::endl;
    }
  }
  std::cout << matches << std::endl;
}

int solve2(int a, int b) {
  int matches = 0;
  for (long i=0; i<=5000000; i++) {
    do {
      a = step(a, 16807);
    } while (a % 4 != 0);
    do {
      b = step(b, 48271);
    } while (b % 8 != 0);

    std::bitset<16> bitsA(a);
    std::bitset<16> bitsB(b);
    if (bitsA == bitsB) { 
      matches++;
    }
  }
  std::cout << matches << std::endl;
}

int main() {
  //long a = 65, b = 8921;
  long a = 699, b = 124;
  solve1(a, b);
  solve2(a, b);
}
