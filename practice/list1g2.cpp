#include <iostream>
#include <stdio.h>

using namespace std;

extern "C"{
    void asmFunc(void);
};

int main(void){
    printf("Calling asmMain:\n");
    asmFunc();
    printf("Returned from asmMain\n");
 
}