#ifndef GSCLASSES_H_
#define GSCLASSES_H_
#include "gsheaders.h"
    
using namespace std;
using namespace GS_Structs;

// must include global variables from .cpp

    // create a global variable and set it equal to the struct member 
extern "C"{    
    string initLogin = "\0";
    string userChoice = "\0";
    string* initLoginPoint = &initLogin;
    bool choiceFlag = 0;
    int counter = 0;
    bool newUser = 0;
    bool registeredUser = 0;
    bool entryFlag = 0;
    int y = 0;
    string verification = "\0";
    
    int totalCmds = 9;
    vector<string> cmdList(totalCmds);  // think log1 (z1)
    
    int registered = 2;    
    vector<string> userList(registered);// think log2 (z2)
    
    string compareVerify;
    
    wchar_t AlephBet[22] = { L'א', L'ב', L'ג', L'ד', L'ה', L'ו', L'ז', L'ח', L'ט', L'י', L'כ', L'ל', \
							L'מ', L'נ', L'ס', L'ע', L'פ', L'צ', L'ק', L'ר', L'ש', L'ת' };
    
    string RevLiterals[22] = {"ת", "ש", "ר", "ק" ,"צ", "פ", "ע", "ס", "נ", "מ", "ל", "כ", "י", "ט", "ח", "ז", "ו", "ה", "ד", "ג", "ב","א"};
   
    string Literals[22] = {"א", "ב", "ג", "ד", "ה", "ו", "ז", "ח", "ט", "י", "כ", "ל", "מ", "נ", "ס", "ע", "פ", "צ", "ק", "ר", "ש", "ת"};


	GSharpStructs::ToneTable GS;// make a list of every class instantiation, and their attributes
    const vector<int> letterArray{ GS.aleph, GS.bet, GS.gimmel, GS.dalet, GS.heh, GS.vav, GS.zayin, GS.chet, GS.tet, GS.yod,\
    GS.kaf, GS.lamed, GS.mem, GS.nun, GS.samech, GS.ayin, GS.pe, GS.tzade, GS.qoph, GS.resh, GS.shin, GS.tav };
	// make method for returning each letter after selecting key
	
    const vector<string> letterWords{ "Aleph", "Bet", "Gimmel", "Dalet", "Heh", "Vav", "Zayin", "Chet", "Tet", "Yod", "Kaf", "Lamed", "Mem", "Nun", \
		"Samech", "Ayin", "Pe", "Tzade", "Qoph", "Resh", "Shin", "Tav" };


namespace GS_Classes{
/*class Declarations{
public:      
    };*/
    
class FileObj{
public:
    
int InLogFunc(){
    FileObj::CommandLine ComLine;
    FileObj UsrList;
    FileObj::Administration Admin_Action;

	string* loginPoint = &initLogin;
	string openMeth = "usrfiles\\" + *loginPoint;
	string* openFile = &openMeth;
    
    if (initLogin == "new") {
		Admin_Action.MakeUser();
		ComLine.VerifyNew();
	}else if(initLogin == "exit"){
		exit(0);
	}else if (initLogin == "\0") {
		do {
			counter++;
			cin >> initLogin;
			if (initLogin != "\0") {
				InLogFunc();
				break;
			}
			else
				continue;
		} while (counter <= 2);
	}else {
		for (int r = 0; r < registered; ++r) {
			if (initLogin == userList[r]) {
				registeredUser = 1;
				ComLine.Verify();
				break;
			}
			else {
				cout << "Username not found" << endl;
				cout << "Enter username: " << endl;
				cin >> initLogin;
				InLogFunc();			// add limiter for number of repeats
			}
		}
	}

	return 0;
}

int Login() {
    cout << "G# Management Platform" << endl;
	cout << "Enter 'new' to create a new account," << endl;
	cout << "or enter your username." << endl;
	cin >> initLogin;

	this->InLogFunc();

	return 0;
}
    
class Administration{
public:
void MakeUser(/*string passString*/) { // need to make prototype to pass Admin.newUser to struct before saving
                    // to file, but otherwise need to pass value between function prototypes
                       // as inline variables.
    FileObj UsrList;
    FileObj::CommandLine ComLine;
    GSharpStructs::UserInfo Admin;
	
    cout << "Enter username: " << endl;
	cin >> Admin.newUser;
    
    if (Admin.newUser != "new") {
		cout << "Enter password: " << endl;
		cin >> Admin.newPassword;

		stringstream converterStream;
		converterStream << Admin.newUser; // Admin.newUser is a char*[10] type
		string convertedString;     		// convert back to char convertedString[10] before passing to other method for list population???
		converterStream >> convertedString;	// write method to create new user accounts from within active user session

		string* filePointer = &convertedString;
		string openMethod = "usrfiles\\" + *filePointer;
		string* methodPoint = &openMethod;

		ofstream FileOut;
		FileOut.open(*methodPoint, ios_base::out | ios_base::binary);
        
		if (FileOut.is_open()) {
  //          ++registered;
	//		userList.push_back(convertedString);
			FileOut.write(reinterpret_cast<const char*>(&Admin), sizeof(Admin));	// Everything contained in struct UserInfo obj. Admin is saved to file 
                                                                                        // AS CHAR POINTER!!! 
			cout << "---------UsrFile created-------" << endl;
            ComLine.SaveRegUsrLs();// have here for when unable to reach end of session prog (exit) and for when creating new users from
                                        // within program as Admin - create method
			FileOut.close();
		}
		else
			cout << "Fail" << endl;

		// UsrList.userList.push_back(Admin.newUser); /*How is the userList being collected and re-evaluated upon startup?*/
		registeredUser = 1;	// Should be able to create method to select Username element from each usrFile and create a stdList<list>???
						// for conversion to html : write string conversion method to file (fd?); use PHP to harvest elements
	}else {
		cout << "Please select different username" << endl;    // need to make check to prevent new user from writing over existing user: userList reloader
		MakeUser();
	}
// return convertedString;
}
};

class CommandLine{
public:
    // GSharpStructs::UserInfo Admin;
    
class LaunchApp{
public:
    
void Help() {
    FileObj::CommandLine::LaunchApp AddApp;
    FileObj::CommandLine ComLine;
	
    choiceFlag = 0;
	
    for (int s = 0; s < totalCmds; ++s) {
		cout << cmdList[s] << endl;
	}
	ComLine.EntryPrompt();
	ComLine.ChoiceList();
}

int Mail() {
    FileObj::CommandLine ComLine;
    
	cout << "mail" << endl;
	choiceFlag = 0;
	ComLine.EntryPrompt();

	return 0;
}

int HebrewConsole() {
    FileObj::CommandLine ComLine;
    
	string hebChoice;
	
    ComLine.HebPrompt();
	cin >> hebChoice;

	unsigned short int hebInd = 3;
	vector<string> HebCon(hebInd);
	HebCon[0] = "אזרה";
	HebCon[1] = "לב";	// instantiation of Core with Hebrew conversion -- move alephbet variables here and make a friend of ToneTable
	HebCon[2] = "מוצא";

	if (hebChoice == HebCon[0]) {
		cout << "----------- פקודות -----------" << endl;
		for (int b = 0; b < hebInd; ++b) {
			cout << HebCon[b] << endl;
		}
	}
	else if (hebChoice == HebCon[1]) {
		cout << "הציג הלב" << endl;
		cout << "here is where I will be able to manipulate the core in Hebrew" << endl;
	}
	else if (hebChoice == HebCon[2]) {
		ComLine.ChoiceList();
	}
	else {
		cout << "נא בזן פקודה חוקית" << endl;
		HebrewConsole();
	}

	// HebrewConsole();

	return 0;
}

int Core() {
system(/*cl C:\\Users\\brian\\masm\\gsharp\\core\\coreValues.cpp;*/"C:\\Users\\brian\\masm\\gsharp\\core\\coreValues.exe");
// I don't have to run core to access ToneTable members
// need to move

// Core constructs a memory location for each letter by its Enlish name. It can be made to return any value of any type (it's a 2-byte memory location: half
    //an eigth of a modulo remainder post computation)(It's a framed shared-object capable of being inserted, removed, altered, and transmitted anywhere!!!)
        //I will run initially, and record the memory locations hex value for access upon subsequent runs. This is dedicated RAM to give preference to the
            //operating software at the lowest levels and partition (security) the run-generated values being processed, 
                //and seperate those locations from use (preserve - carbon footprint)
                    //so they cannot be accessed by other services (red security detail in system drawing - Facebook)
	cout << "Core" << endl;
	cout << "System call is sending command back to gsharp??????" << endl;

//	GSharpStructs::ToneTable GS;
FileObj::CommandLine::LaunchApp AddApp;

	short int* pointer = &GS.aleph;    // Returning the value
		for (int w = 0; w < 22; ++w) {
		cout << letterWords[w] << " is at:\t" << &letterArray[w] << "\tand it contains:\t" << letterArray[w] << endl;
	}

	cout << "===============" << endl;
	cout << "GetValues function" << endl;
	cout << "Enter Key Value (-4 through 7): ";
	int keyValue = 0;
	cin >> keyValue;
	AddApp.GetValues(keyValue);
	cout << "==============" << endl;
	cout << "GS.EOt at:\t" << &GS.EOt << "\tcontains:\t" << GS.EOt << endl;
	cout << "GS.AOt at:\t" << &GS.AOt << "\tcontains:\t" << GS.AOt << endl;
	cout << "GS.Bf9 at:\t" << &GS.Bf9 << "\tcontains:\t" << GS.Bf9 << endl;
	cout << "==============" << endl;
	cout << sizeof(GS) << endl;

	cout << "Would you like to return a chord value? Enter 'y' for yes, or 'n' for no." << endl;
	char retVal = 'n';
	cin >> retVal;

	short int retValCount = 0;

// goes directly into RetChordVal() with 'y' or 'n'
	if(retVal == 'y'){
	AddApp.RetChordVal();
	}else if(retVal == 'n'){
	return 0;
	}else if(retVal != 'y' || 'n'){
	do{
	if(retValCount > 1)
	exit(0);
	else{
	cout << "Please, enter 'y', or 'n'." << endl;
	cin >> retVal;
	}
	if(retVal == 'y'){
	AddApp.RetChordVal();
	}else if(retVal == 'n'){
	return 0;
	}else{
	}
	++retValCount;
	}while(retVal != 'y' && retVal != 'n' && retValCount < 3);
	}else
	exit(0);


	return 0;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int RetChordVal(){
cout << "In RetChordVal" << endl;
/*cout << "Enter chord (Hebrew letter, or English name of Hebrew letter): " << "\t";
string retChord = "\0";
cin >> retChord;

// use do/while and set counter to indicate which element I am at and return the corresponding value from the Literals vector.
for(int chNum = 0; chNum < 22; ++chNum){
if(retChord == Literals[chNum]){
// make counter to number iterations to output corresponding letterArray value???
cout << letterArray[chNum] <<  endl;
}else{
cout << "Invalid entry. Please enter a Hebrew letter, or an English name of a Hebrew letter: " << "\t";
cin >> retChord;
}
}

cout << "Would you like to display another chord's value? (y\n): " << "\t";
char moreChords = 'n';
cin >> moreChords;
if(moreChords == 'y'){
for(int chNum2 = 0; chNum2 < 22; ++chNum2){
cout << 
// the chord values need to increment (fretBoard) and decrement according to value supplied to forKey of GetValues()
//cout << "Miss" << endl;
}
}
*/
return 0;
}

int GetValues(int forKey) { 
using namespace GS_Structs;

	GSharpStructs::ToneTable Core;
    FileObj::CommandLine::LaunchApp AddApp;

			int index = 1;
			int* point = &index;

			cout << "Values in Key:" << endl;

			string pathmaker = "valsheet\\values";
			string* opener = &pathmaker;

			if (forKey >= -4 && forKey <= 7) {
				ofstream ValueSheet(*opener, ios_base::out);

				if (ValueSheet.is_open()) {
					// six rows of 21 -- make 5 sets of variables that point to x,y; add 21; and substitute to each row
					unsigned short int cOne = 1;
					unsigned short int cTwo = 22;
					unsigned short int cThree = 43;
					unsigned short int cFour = 64;
					unsigned short int cFive = 85;
					unsigned short int cSix = 106;

					do {
						for (int x = 0; x < 1; ++x) {
							for (int y = 0; y < 21; ++y) {
								GSharpStructs::ToneTable gs;
								int a = x;
								int b = y + 21;
								int c = x;
								int d = y + 42;
								int e = x;
								int f = y + 63;
								int g = x;
								int h = y + 84;
								int i = x;
								int j = y + 105;
								ValueSheet << "tone[" << cOne << "]  " << &gs.fretBoard[x][y] << "  tone[" << cTwo << "]  " << &gs.fretBoard[a][b] << "  tone[" << cThree << "]  " << \
									& gs.fretBoard[c][d] << "  tone[" << cFour << "]  " << &gs.fretBoard[e][f] << "  tone[" << cFive << "]  " << &gs.fretBoard[g][h] << "  tone[" << cSix << "]  " \
									<< &gs.fretBoard[i][j] << endl;

								++cOne;
								++cTwo;
								++cThree;
								++cFour;
								++cFive;
								++cSix;
							}
						}
					} while (cOne < 21);

					do {
						for (int x = 0; x < 6; ++x) {
							for (int y = 0; y < 21; ++y) {
								int* toKey = &forKey;
								int values = { Core.fretBoard[x][y] + (*toKey) };
								int* valuePoint = &values;
								ValueSheet << "tone[" << *point << "]   \t" << *valuePoint <<                                                       endl;
								++index;
							}
						}
					} while (index < 126);
					ValueSheet.close();
				}
				else
					cout << "Failed" << endl;

				ifstream SameSheet(*opener, ios_base::in);

				if (SameSheet.is_open()) {
					string sheetContent;
					while (SameSheet.good()) {
						getline(SameSheet, sheetContent);
						cout << sheetContent << endl;
					}
					SameSheet.close();
				}
				else
					cout << "File open failed" << endl;
			}
			else {
				cout << "Invalid entry." << endl;
				cout << "GetValues function" << endl;
				cout << "Enter Key Value (-4 through 7): ";
				int repeat = 0;
				cin >> repeat;
    
				AddApp.GetValues(repeat);
			}

			return 0;
}
};


void UserPrompt() {
	cout << *initLoginPoint << ": ";
}
    
void EntryPrompt() {
    FileObj UsrList;
    GSharpStructs::UserInfo Admin;
        
	if (newUser == 0) {
		this->UserPrompt();
		cin >> userChoice;
	}
	else if (newUser == 1) {
		cout << compareVerify << ": ";
		cin >> userChoice;
	}
	else {
		cout << "Fatal Error: Please Login Again" << endl;
		UsrList.Login();
		}
    }
    
void HebPrompt() {
    GSharpStructs::UserInfo Admin;
    
	if (newUser == 0)
		this->UserPrompt();
	else
		cout << Admin.newUser << ": ";
}
    
void Verify() {

	cout << "Please enter your password: " << endl;
	cin >> verification;
   
    string* initPoint = &initLogin;
    string methodOpen = "usrfiles\\" + *initPoint;
	string* Opener = &methodOpen;

	ifstream UserFile(*Opener, ios_base::in | ios_base::binary);

	GSharpStructs::UserInfo GetUser;

	if (UserFile.is_open()) {
		cout << "File opened" << endl;

		UserFile.read((char*)&GetUser, sizeof(GetUser)); // Get values

		stringstream convertInfo;
		convertInfo << GetUser.newPassword;       // convert values for comparison
		
		convertInfo >> compareVerify;

		UserFile.close();

		if (verification == compareVerify) {
			cout << "Successful verification" << endl;       // perform comparison
			entryFlag = 1;
            newUser = 0;
		}
		else {
			cout << "Incorrect password." << endl;
			Verify();
		}
	}
	else {
		cout << "Verify function: Open failed" << endl;
		Verify();
	}

}
    
void VerifyNew(/*char passNewUser[10]*/) {// return Admin.newUser in MakeUser() to VerifyNew() prototype
    GSharpStructs::UserInfo Admin;
    
		stringstream convertNewUser;
		convertNewUser << Admin.newUser; // Admin.newUser is a char*[10] type
		string newUserString;     		// convert back to char convertedString[10] before passing to other method for list population???
		convertNewUser >> newUserString;
        
        //Admin.newUser = passNewUser;
        // need to make global variables to substitute values in prototypes 
        
	if (registeredUser == 1) {
		cout << "Please enter your password: " << endl;
		cout << newUserString << ": ";    // Admin.newUser not passing////////////////////
		cin >> verification;

		stringstream thisConverter;
		thisConverter << Admin.newUser;
		string stringConvert;
		thisConverter >> stringConvert;

		string* initPoint = &stringConvert;
		string methodOpen = "usrfiles\\" + *initPoint;
		string* Opener = &methodOpen;

		ifstream UserFile(*Opener, ios_base::in | ios_base::binary);

		if (UserFile.is_open()) {
			cout << "File opened" << endl;

            GSharpStructs::UserInfo GetUser;

			UserFile.read((char*)&GetUser, sizeof(GetUser));

			stringstream stringConvert;	// need to do the same for collecting Usernames from saved files 
			stringConvert << GetUser.newPassword;    // Don't forget to pass file values back
			string compareVerNew;                        // as strings for comparison!!!
			stringConvert >> compareVerNew;

			if (verification == compareVerNew) {
				cout << "File read in VerifyNew" << endl;
				UserFile.close();
				entryFlag = 1;
                newUser = 1;
			}else {
				cout << "Wrong password" << endl;
				VerifyNew();	// Set limiter with while loop to return to login, and create method to prevent
						// repeated creation of accounts after failed login attempt -- need method for controlling 
						// users ability to create multiple accounts that could be used to overwhelm server programatically and from the internet
			}
		}
		else {
			cout << "Open Failed!!!" << endl;
			VerifyNew();
		}
	}
	else
		exit(0);

}

int Entry() {
    if (entryFlag == 1) {	// from Verify and VerifyNew for second verification for entry
		cout << "Welcome to the Main Menu" << endl;
		cout << "Enter 'help' to display commands." << endl;
		this->EntryPrompt();
		this->ChoiceList();
	}else
		exit(0);
        
	return 0;
}

void ChoiceList() {
FileObj::CommandLine::LaunchApp AddApp;

	choiceFlag = 1; 	// to watch for if the cmdLine is in use. To be able to see anytime anyone is actively entering commands???

	cmdList[0] = "help";
	cmdList[1] = "mail";
	cmdList[2] = "print";
	cmdList[3] = "text";
	cmdList[4] = "בש";
	cmdList[5] = "מחש";
	cmdList[6] = "core";
	cmdList[7] = "server";
	cmdList[8] = "exit";

	do {
		if (userChoice == cmdList[0]) {
			choiceFlag = 0;
			AddApp.Help();
			break;
		}
		else if (userChoice == cmdList[1]) {
			choiceFlag = 0;
			AddApp.Mail();
			break;
		}
		else if (userChoice == cmdList[2]) {
			cout << "print" << endl;
			choiceFlag = 0;
			break;
		}
		else if (userChoice == cmdList[3]) {
			cout << "text" << endl;
			choiceFlag = 0;
			break;
		}
		else if (userChoice == cmdList[4]) {
			choiceFlag = 0;
			AddApp.HebrewConsole();
			break;
		}
		else if (userChoice == cmdList[5]) {
			cout << "calc" << endl;
			choiceFlag = 0;
			this->EntryPrompt();
			ChoiceList();       // temporary for testing !!!!!!!!!!!!!!!!
			break;
		}
		else if (userChoice == cmdList[6]) {
			choiceFlag = 0;
			AddApp.Core();
			break;
		}
		else if (userChoice == cmdList[7]) {
			cout << "Starting G# Server" << endl;		// write cmd to build and run C# obj.
			system("dotnet run --project C:\\Users\\brian\\Desktop\\httpserver\\gsserver5");
			break;
		}
		else if (userChoice == cmdList[8]) {
			choiceFlag = 0;
			this->SaveRegUsrLs();		///////Where I link to FileObj to write userList and total registered to file////////////////////////////
			exit(0);
		}
		else {
			choiceFlag = 0;
			cout << "Please enter valid command, or enter" << endl;
			cout << "'help' to display a list of commands." << endl;
			this->EntryPrompt();
			ChoiceList();
			continue;
		}
	} while (userChoice != "\0");

	this->EntryPrompt();
	ChoiceList();
}


    
void SaveRegUsrLs(){
    FileObj UsrList;
    
	cout << "Saving userList" << endl;

	string usrLsPath = "users\\userlist";
	string* pathUsrLs = &usrLsPath;

	ofstream ULIST(*pathUsrLs, ios_base::out/* | ios_base::binary*/);
	if (ULIST.is_open()) { // all of FileObj is being saved 
    // include registered
        ULIST.write(reinterpret_cast<const char*>(&registered), sizeof(registered));
		ULIST.write(reinterpret_cast<const char*>(&userList), sizeof(userList)); // Changed from UsrList and in LoadRegUsrLs()
		cout << "Saved UsrList to file" << endl;
		ULIST.close();
	}
	else {
		cout << "saving UserList vector to file failed" << endl;
	}
    }
    
void LoadRegUsrLs() {
    FileObj UsrList;
    
	cout << "Loading userList" << endl;
	string fileLoad = "users\\userlist";
	string* openLoader = &fileLoad;

	ifstream LoadFile(*openLoader, ios_base::in /*| ios_base::binary*/);
    
	if (LoadFile.is_open()) {

        LoadFile.read((char*)&registered, sizeof(registered));
		LoadFile.read((char*)&userList, sizeof(userList)); 
        
	LoadFile.close();
	}
	else
		cout << "LoadRegUsrLs() failed" << endl;
    }
};

};

}

}
#endif
    
    // could atoi be used to store the strings as integers?
