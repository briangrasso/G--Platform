#include <stdio.h>

extern "C"{
    void asmFunc(void);
};

int main(void){
    printf("Calling asmFunc:\n");
    asmFunc();
    printf("Returned from asmFunc:\n");
}