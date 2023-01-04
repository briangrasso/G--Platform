#include <iostream>
#include <tuple>
#include <string>
#include "../headers/gsheaders.h"
#include <fstream>

using namespace std;


fstream makeHTML;
int eleCount = 0;

template <typename Board>
void DisplayBoard(Board& fBoard){
const int numAttrib = tuple_size<Board>::value;
// add javaScript code to make each tuple an object
// ???write parser in javascript to collect each letter element and create objects of the data???
makeHTML << get<numAttrib - 4>(fBoard) << "\t" << get<numAttrib - 3>(fBoard) << "\t" << get<numAttrib - 2>(fBoard) << "\t" << get<numAttrib - 1>(fBoard) << "<br>" <<  endl;

cout << get<numAttrib - 4>(fBoard) << "\t" << get<numAttrib - 3>(fBoard) << "\t" << get<numAttrib - 2>(fBoard) << "\t" << get<numAttrib - 1>(fBoard) << endl;
}

/* the incoming data from the html GET request can be passed as string variables in C# to child processes as arguments */

int main(){
GSharpStructs::ToneTable boardGS;
cout << "Glyph:\t" << "Name:\t" << "ABVal:\t" << "CVal:" << endl;

makeHTML.open("C:\\Users\\brian\\masm\\solo\\gsharp\\gsserver5\\webroot\\passdata\\passparseddata.html", ios_base::out);	// use httpserver in node.js to pass //makehtml.html to Gsharp1????
//makeHTML.open("/mnt/chromeos/MyFiles/dev/gsharp/core/makehtml.html", ios_base::out); // 
//save to file and format to html with element values as objects
//create file server in gsharp to handle requests from httpserver for updated object values
if(makeHTML.is_open()){
cout << "File open successful" << endl;

makeHTML << "<!DOCTYPE html>" << endl << "<html>" << endl << "<head>" << endl << \
		endl << "<title>C++ Shared Object/HTML file</title>" << endl << \
		endl << "<meta charset=\"UTF-8\">" << endl << "<link rel=\"icon\" type=\"image/x-icon\" href=\"../brianhead.jpeg\">" << endl << "<style></style>" << \
		endl << "</head>" << endl << "<body>" << endl << "<p>" << endl << \
		"<script>document.write(\"Success\")</script>" << endl << "</p>" << endl << \
		"<div>" << endl;
// build html objects for tuple elements to make accessible from browsers and ASSIGN DISPLAY CHARACTERistics VISUALLY for clients - can be used to CHAIN LETTERS TOGETHER for converting 
// strings of Hebrew letters into visual output. Use values in graphs/graphics/PROGRAMMING
for(int tupleInc = 0; tupleInc < 22; ++tupleInc){
tuple<string, string, wchar_t, int> fBoardGS(make_tuple(Literals[tupleInc], letterWords[tupleInc], AlephBet[tupleInc], letterArray[tupleInc]));	// place chords in vector -- place tones in vector
DisplayBoard(fBoardGS);
}
/*each iteration of the tuple set from DisplayBoard() is the cause for the new line 
being started (not the inline endl = insert linebreak method()) for all of the data 
written to the passparseddata.html file*/

makeHTML << "\r</div>\r</body>\r</html>\r\r" << endl;

cout << "File write complete" << endl;

makeHTML.close();
}

return 0;
}

// fretBoard is the container name of type Board
// constexpr int eleSub(){return eleCount + 0;}
// create method to output all of boardGS as 
// to output all Glyphs
//tuple<int, wchar_t, string, string> fBoardGS(make_tuple(boardGS.EO9, AlephBet[someInt], letterWords[4], Literals[5]));
/*
// the Tone Bank is ToneTable();
template <typename ToneBase>
class { 			// tones are common
// to scale, and shift scope
// what are the characteristics of a tone: location (per fret and string); numerical value; letter value; ??other tones it can be grouped into chords with
};

int main(){

return 0;
}

/*
template Chord

template Key
// for all major keys

template Fret

template SStrings


template Glyphs

template Languages


#include <iostream>
#include <tuple>
#include <string>

using namespace std;

template <typename tupleType>
void DisplayTupleInfo(tupleType& tup){
const int numMembers = tuple_size<tupleType>::value;	// counter like int argc
cout << "Num elements in tuple: " << numMembers << endl;

cout << "Last element value: " << get<numMembers - 1>(tup) << endl;
}

int main(){
tuple<int, char, string> tup1(make_tuple(101, 's', "Hello Tuple!"));

auto tup2(make_tuple(3.14, false));
DisplayTupleInfo(tup2);

auto concatTup(tuple_cat(tup2, tup1));	// contains tup2, tup1 members
DisplayTupleInfo(concatTup);

double pi;
string sentence;
tie(pi, ignore, ignore, ignore, sentence) = concatTup;
cout << "Unpacked! Pi: " << pi << " and \"" << sentence << "\"" << endl;

return 0;
}
*/
// I want to make a variadic of this as well to allow for different boards to be
						// constructed
// board should contain everything (think game boards: go, chess - what is the difference between an intersection and a block?)


//cout << "Number of Board attributes: " << numAttrib << endl;
//cout << "First element: " << get<numAttrib - 4>(fBoard) << endl;
//cout << "Glyph: " << get<numAttrib - 3>(fBoard) << "\t" << "Glyph Name: " << get<numAttrib - 2>(fBoard) << "\t\t" << "AlephBet Value: " << get<numAttrib - 1>(fBoard) << endl;
// !!!!!! This is the GET method!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Can I change type to AUTO and RETURN ALL THE VALUES ACCORDING TO FBOARD?


// can I use this to GET values from HTML documents that contain OBJECTS with corresponding KEYs/names????!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

/*
for (int  dispAll = 0; dispAll < numAttrib; ++dispAll){
cout << "Element [" << eleCount << "]" << "\t" << get<dispAll>(fBoard) << endl;
++eleCount;
}*/


// think argc argv[]
// save Tuple to file...

// create Tuple for_each Glyph/letter that returns all, individual, and desired groupings.
// return value printf() (operator pointers?)
