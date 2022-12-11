#include "headers/gsheaders.h"

//use extern to declare functions to use
extern "C"{
	void asmFunc(void);
	void myProc(void);
};

int main(void){ 	// need other console application to pass in arguments to commandline
	cout << "In main - before asmFunc()" << endl;
	asmFunc();	// link to assembly for porting functionality
	cout << "In main - after asmFunc()" << endl;
	myProc();
	cout << "In main - after myProc()" << endl;

	system("gsharp core");
	// enter gsharp.cpp here
	
	cout << "Exiting main" << endl;
	return 0;
}