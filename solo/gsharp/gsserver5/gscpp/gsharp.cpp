//stringstream the contents of argv[] to a variable convert to integer and compare numerically against acceptable argument strings
#include "../gscpp/gsharp/headers/gsheaders.h"
#include "pch.h"

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

string RevLiterals[22] = { "ת", "ש", "ר", "ק" ,"צ", "פ", "ע", "ס", "נ", "מ", "ל", "כ", "י", "ט", "ח", "ז", "ו", "ה", "ד", "ג", "ב","א" };

string Literals[22] = { "א", "ב", "ג", "ד", "ה", "ו", "ז", "ח", "ט", "י", "כ", "ל", "מ", "נ", "ס", "ע", "פ", "צ", "ק", "ר", "ש", "ת" };


GSharpStructs::ToneTable GS;// make a list of every class instantiation, and their attributes
const vector<int> letterArray{ GS.aleph, GS.bet, GS.gimmel, GS.dalet, GS.heh, GS.vav, GS.zayin, GS.chet, GS.tet, GS.yod,\
GS.kaf, GS.lamed, GS.mem, GS.nun, GS.samech, GS.ayin, GS.pe, GS.tzade, GS.qoph, GS.resh, GS.shin, GS.tav };
// make method for returning each letter after selecting key

const vector<string> letterWords{ "Aleph", "Bet", "Gimmel", "Dalet", "Heh", "Vav", "Zayin", "Chet", "Tet", "Yod", "Kaf", "Lamed", "Mem", "Nun", \
	"Samech", "Ayin", "Pe", "Tzade", "Qoph", "Resh", "Shin", "Tav" };
}

using namespace std;
/// <summary>
/// //////////////////////////////////////////////
/// WHAT IS THIS - CAME UP ON ITS OWN
/// </summary>
/// <param name="argc"></param>
/// <param name="argv"></param>
/// <returns></returns>
/// 
/// NEED TO ADD DECLARATIONS FROM GSCLASSES TO GSHARP.CPP TO MAKE THEM ACCESSIBLE

int main(int argc, const char* argv[]) {

	// Why is 'S' displayed at startup when no additional arguments have been entered?
	// cout << *argv[2] << endl;
	if (argc > 1) {
		for (int Ivec = 0; Ivec < argc; ++Ivec) {
			cout << argv[Ivec] << endl;
		}
		////////////////////////////////////////////////
		//why won't atoi conversion work?
		// do atoi conversion for each argument
		// use enum to store values for each argument
		string argString = argv[1];

		//printf("argString as integer = %d\n argString as hex = 0x%08x\n", argString);/*values for arguments do not change in c-string HEX form*///!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

		// think username and password
		// try using hebrew by doing bitwise comparison!!!?

		// write switch/case for config parameters for shortcuts to desired apps before login
		// require argv[1] to be username, and argv[2] to be password - compare against files for verification to skip main page and "create user" step...

		// need to add coredata to gstemplates, and instantiate from there
		if (argString == "core") {
			AddApp.Core();
		}
		else if (argString == "coredata") {
			cout << "Running coredata" << endl;
			//system("cd ~/develop/GSProj/gsharp/core; g++ coreValues.cpp -o core; ./core");
		}
		else {
			cout << "failure in coreValues" << endl;
		}

		GSharpStructs::ToneTable myTones;

		for (int tones = 0; tones < 126; ++tones) {
			cout << myTones.ToneArray[tones] << "\t";
		}
		cout << endl << "Enter Main" << endl;

		//registered = 3;

		userList[0] = "asdf";
		//userList[1] = "fff";

		//ComLine.LoadRegUsrLs();

		// what I need is to wrap the variables and functions I save to files programmatically in extern "C"
		UsrList.Login();

		if (registeredUser == 1) {
			ComLine.Entry();
		}
		else {
			exit(0);
		}

		return 0;
	}
}
