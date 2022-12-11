#include <iostream>
#include "headers/gsheaders.h"
#include "headers/gsstructs.h"
#include "headers/gsclasses.h"

using namespace std;
using namespace GS_Structs;
using namespace GS_Classes;

GSharpStructs::ToneTable TestTone;

int main(int argc, char *argv[]){
string argOne = argv[1];
cout << argOne << endl;

TestTone.ToneTable();
return 0;
}

/*
struct FirstArg{
FirstArg(){};
~FirstArg(){};
FirstArg(string passOne){*/
