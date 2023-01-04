
var fooVariable = "another string";
var fooVar2 = "fooVar2";
var recorder = 0;

function myFoo(someData){   /*made a constructor by naming the function after the object: see c++ base class = */

++recorder;

console.assert(document.querySelector('h5'), 'h5 not found!'); //<!-- IF the first parameter is true -->
const artists = [                                             // <!-- the second will execute, ELSE -->
  {                                                           // <!-- it will not -->
    first: 'René',
    last: 'Magritte'
  },
  {
    first: 'Chaim',
    last: 'Soutine'
  },
  {
    first: 'Henri',
    last: 'Matisse'
  }
];
console.table(artists);
setTimeout(() => {
  //firstHeading.textContent = 'Hello, Console!'; //<!-- What is setTimeout() = delay processing -- 'textContent' is a field/label -->
  console.log("set first time out");
}, 3000);
setTimeout(() => {
    let hebrewString = "בש"
//firstHeading.textContent = 'אזרא';
  console.log("אזרא");
  console.log(hebrewString);
  }, 5000);
  
/*use this method for instantiating myFoo to the document with 
the value -VARIABLE- associated with the instantiation as the content*/
document.write("<myFoo id=\"outlineScript\">" + someData + "</myFoo>");// !!! this method creates the object and passes the contained variable !!!!

/*method writes to document and console simultaneously*/
console.log(someData + " to console");

    var retData = "retData = " + someData + " ";
// write another function overloaded with retData to link functionality - algorithm
for(var count = 0; count < 2; ++count){
  document.write(retData);
}
return retData;
}

let fooBar = new myFoo(fooVariable);    /*use => operator c++*/
fooBar.name = "fooBar";
fooBar.value = "foosvalue";
fooBar.textContent = "fooscontent";

let Foo2 = new myFoo(fooVar2);
// will take whatever variable it is passed (type auto)???
//create second instance, make communicate with fooBar, save to file
// to "set" attributes create method for client that establishes them 
  //as "form fields" (manually create w/textarea)??? and "submit"
  // by INCLUDING THE SERVER ADDRESS WITH QUALIFIED PATH IN CLIENT APPLICATION <script src="">
  



  let unFoo2 = document.getElementsByTagName("myFoo");
// write and test attributes for this version of the object

/*function myFoo2(passData){
    document.write(passData);
    return passData;
}*/

//let unFooey = document.getElementById("idUFO");
//unFooey.name = "UnFoOey";

//let unFoo3 = document.getElementsByTagName("myFoo");*/
let unFoo4 = document.querySelector('myFoo#idUFO.FooClass');
//unFoo4.someVar = "isthefirstvariablealwaysthename";



//let difFoo = new myFoo(fooBar);
/*chaining constructors actually takes a variable: fooVariable*/
//let anotherFoo = new myFoo(myFoo(fooVariable));

//const defineFoo = document.querySelector('myFoo');

// adding console application features
/*console.log('Loading!');
//const firstHeading = document.querySelector('h1'); // <!-- declares pointer -->
//firstHeading.textContent = "text content: h1";
//console.log(firstHeading.textContent);            // <!-- think operator() selector/tuples -- !!! 'h1' was already defined in html !!! = h1 is object --> 
console.assert(document.querySelector('h5'), 'h5 not found!'); //<!-- IF the first parameter is true -->
const artists = [                                             // <!-- the second will execute, ELSE -->
  {                                                           // <!-- it will not -->
    first: 'René',
    last: 'Magritte'
  },
  {
    first: 'Chaim',
    last: 'Soutine'
  },
  {
    first: 'Henri',
    last: 'Matisse'
  }
];
console.table(artists);
setTimeout(() => {
  //firstHeading.textContent = 'Hello, Console!'; //<!-- What is setTimeout() = delay processing -- 'textContent' is a field/label -->
  console.log("set first time out");
}, 3000);
setTimeout(() => {
    let hebrewString = "בש"
//firstHeading.textContent = 'אזרא';
  console.log("אזרא");
  console.log(hebrewString);
  }, 5000);*/
