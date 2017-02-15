#include <iostream>
#include <string>

int main (int argc, char* argv[]) {
  //init
  unsigned int n = std::stoi(argv[1]);
  unsigned int acum = 0;
  while (n > 0) {
    acum = acum + n; //load acum
    n--; //dec n (acum's stable at this point)
  }
  std::cout << "Sum of " << std::stoi(argv[1]) << " equals " 
            << acum << std::endl;
  return 0;
}