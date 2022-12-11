#include <iostream>
#include <tuple>
#include <string>

using namespace std;

template <typename tupleType>
void DisplayTupleInfo(tupleType& tup){
const int numMembers = tuple_size<tupleType>::value;
cout << "Num elements in tuple: " << numMembers << endl;
cout << "Last element value: " << get<numMembers - 1>(tup) << endl;
}

int main(){
tuple<int, char, string> tup1(make_tuple(101, 's', "Hello Tuple!"));
DisplayTupleInfo(tup1);

return 0;
}
