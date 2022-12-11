#include <iostream>
#include <string>
#include <stdio.h>
using namespace std;
int main(int argc, char *argv[]){
string passArg = argv[1];
printf("randomizer: %d\n", passArg);

cout << &passArg << endl;

return 0;
}
