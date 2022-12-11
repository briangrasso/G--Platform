#include <iostream>
#include <string>
#include <tuple>
#include <fstream>
#include "../headers/gsheaders.h"

fstream OpenHTML;

int main(){
OpenHTML.open("makeHTML.html", ios_base::in);
if(OpenHTML.is_open()){
cout << "file open" << endl;
string webpage;
while(OpenHTML.good()){
getline(OpenHTML, webpage);
// add code to open document with browser
cout << webpage << endl;
}
cout << "Complete" << endl;
OpenHTML.close();
}
else
cout << "open failed" << endl;

return 0;
}
