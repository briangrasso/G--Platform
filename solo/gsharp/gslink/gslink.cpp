#include <iostream>
#include <string>

using namespace std;

int main(){

    int var1 = 5;
    int* varOne = &var1;
    cout << "var1 is located at:\t" << &var1 << endl <<
        "var1 contains the value:\t" << *varOne << endl;
    string pause = "";
    cin >> pause;

    // USE ASSEMBLY TO READ AND WRITE DATA TO MEMORY LOCATION (is shared
    // object) --- use ASSEMBLY to read data from the tonetable struct
    // after it has been set by the encryption variables -- USE ASSEMBLY 
    // TO START AND STOP PROCESSES/ PASS DATA BETWEEN PROCESSES. 
    // Everything should be coming from the assembly MAIN entry? Or
    // can I JUST INCLUDE THE GSHARP header files with the standalone.cpp
    // file!!!!!!!!!!!!! The "asmMain process" should establish the methods
    // for storing and passing values between all the process running 
    // from the ROOT CPP FILE (standalone.cpp) - can still use file I.O.
    // functions, but should be easier to create a buffer and MOV the
    // value into it, or a free register in assembly... see how printf()
    // is overloaded - multiple lea operations before call operation??? 

    return 0;
}