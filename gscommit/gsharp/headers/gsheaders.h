#ifndef GSHEADERS_H_
#define GSHEADERS_H_

#include <iostream>
#include <string>
#include <cstring>
#include <vector>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <algorithm>
#include "gsclasses.h"
#include "gsstructs.h"
#include <stdio.h>


using namespace std;
using namespace GS_Classes;
using namespace GS_Structs;

string initLogin = "\0";
int counter = 0;
int registered = 2;
bool choiceFlag = 0;
bool newUser = 0;
bool registeredUser = 0;
bool entryFlag = 0;
string userChoice = "\0";
int totalCmds = 9;
string verification = "\0";
string compareVerify;
string* initLoginPoint = &initLogin;

vector<string> cmdList(totalCmds);  // think log1 (z1)
vector<string> userList(registered);// think log2 (z2)

int y = 0;

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

FileObj::CommandLine::LaunchApp AddApp;
FileObj::CommandLine ComLine;
FileObj UsrList;
GSharpStructs::UserInfo Admin;

#endif
