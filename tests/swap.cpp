#include <iostream>
#include <utility>

using namespace std;

string e = "";

string swapFunc(string a, string b){
    swap(a, b);

    e = a + " " + b;

    return e;  
}

// USE FOR EXCHANGING CURRENCY!!!!!!!!!!!!!
// use utility header with Hebrew tuples to match hebrew words to c++ keywords with std:pair?????

int main(){
    cout << "Enter two strings: " << endl;
    string z = "";
    cin >> z;
    string y = "";
    cin >> y;

    swapFunc(z, y);

    cout << "Result of swap: " << e << endl;

    return 0; 
}