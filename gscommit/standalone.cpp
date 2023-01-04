//template for use with cpp main entry applications
#include "headers/gsheaders.h"
#include <errno.h>

//use extern to declare functions to use
extern "C"{
	void asmFunc(void);
	void myProc(void);
	char *getTitle(void);					// to access parameter arguments for console applications
	void asmMain(void);
	int readLine(char *dest, int maxLen);			// same as int argc, char* argv[] - do I need to change, 
								// or is it the parameter string that is being pointed to?
		// int readLine reads a line of text from the user (FROM THE CONSOLE DEVICE DEVICE DEVICE - any stdout????)
	// char *dest is where the passed string is stored "server side" - PORT PORT PORT
};

int main(void){ 	// need other console application to pass in arguments to commandline

	try{		// Exception handling
		cout << "In main - before asmFunc()" << endl;
cout << "Before getTitle() call" << endl;
		char* title = getTitle();			// "global variable" CALL TO GET TITLE - 1st argument in param string
cout << "Before Printing getTitle() result" << endl;
		printf("Calling %s:\n", title);
cout << "After Printing getTitle() result" << endl;
		asmMain();
cout << "After asmMain()" << endl;
		printf("%s terminated\n", title);		// THINK STRING PARSING PARSING PARSING
	}
	catch(...){
		printf(
			"Exception occurred during program execution.\n"
			"Abnormal program termination.\n"
		);
	}
	cout << "In main - after asmFunc()" << endl;
	// USING STRING INTERPOLATION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	myProc();						// Calling an unset variable after it's been used - checks/sanitaizing??? 
	cout << "In main - after myProc()" << endl;
	

	system("C:\\Users\\brian\\masm\\solo\\gsharp\\gsharp.exe core");
	// enter gsharp.cpp here
	
	cout << "Exiting main" << endl;
	return 0;
}

int readLine(char *dest, int maxLen){				
	// fgets returns NULL NULL NULL if there was an ERROR
	// it returns a pointer TO THE STRING DATA read
	// which is the VALUE OF the dest POINTER

	char *result = fgets(dest, maxLen, stdin);		// NOTICE: stdin!!!
	if(result != NULL){		// if no ERROR
		// Wipe out the newline character at the end of the string
		int len = strlen(result);			// GET RETURN BUFFER length (think returning data to server)
		if(len > 0){
			dest[len - 1] = 0;
		}
		return len;
	}
	return -1;						// If there was an error - by default???
}