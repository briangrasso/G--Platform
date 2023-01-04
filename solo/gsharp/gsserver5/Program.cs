using System;
using System.IO;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Runtime.InteropServices;
using System.Diagnostics;

namespace gsserver{

class Program{
public static string filename = "";
public static string fullPath = "";
public static string directory = "";
public static string handleString = "";
public static int counter = 0;
public static ushort[] bsLoc = {0, 0, 0, 0};
public static ushort bsCount = 0;
public static ushort[] fsLoc = {0, 0, 0, 0};
public static ushort fsCount = 0;
public static ushort[] perLoc = {0, 0, 0, 0};
public static ushort perCount = 0;
public static ushort qmLoc = 0;
public static ushort[] eqLoc = {0, 0, 0, 0};
public static ushort eqCount = 0;
public static ushort[] ampLoc = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
public static ushort ampCount = 0;
public static string parsedCom = "";
public static string adminCommand = "";
public static string fileWOExt = "";
public static string fileExt = "";
public static string[] rVarName = {"", "", "", "", "", "", "", "", "", ""};
public static string[] rVarValue = {"", "", "", "", "", "", "", "", "", ""};
public static string actionPg = "";
public static string check = "";
public static string path = "";


class ServClasses{
    public ServClasses(){
        Program.bsLoc[0] = 0;
        Program.bsLoc[1] = 0;
        Program.bsLoc[2] = 0;
        Program.bsLoc[3] = 0;
        Program.bsCount = 0;
        Program.fsLoc[0] = 0;
        Program.fsLoc[1] = 0;
        Program.fsLoc[2] = 0;
        Program.fsLoc[3] = 0;
        Program.fsCount = 0;
        Program.perLoc[0] = 0;
        Program.perLoc[1] = 0;
        Program.perLoc[2] = 0;
        Program.perLoc[3] = 0;
        Program.perCount = 0;
        Program.qmLoc = 0;
        Program.eqLoc[0] = 0;
        Program.eqLoc[1] = 0;
        Program.eqLoc[2] = 0;
        Program.eqLoc[3] = 0;
        Program.eqCount = 0;
        Program.ampLoc[0] = 0;
        Program.ampLoc[1] = 0;
        Program.ampLoc[2] = 0;
        Program.ampLoc[3] = 0;
        Program.ampLoc[4] = 0;
        Program.ampLoc[5] = 0;
        Program.ampLoc[6] = 0;
        Program.ampLoc[7] = 0;
        Program.ampLoc[8] = 0;
        Program.ampLoc[9] = 0;
        Program.ampCount = 0;
        Program.parsedCom = "";
        Program.directory = "";
        Program.actionPg = "";
        /*need to add rVars to list to reset after each creation of a set and 
            make method for creating a new object for each new request that passes
             data */
        Program.rVarName[0] = "";
        Program.rVarName[1] = "";
        Program.rVarName[2] = "";
        Program.rVarName[3] = "";
        Program.rVarName[4] = "";
        Program.rVarName[5] = "";
        Program.rVarName[6] = "";
        Program.rVarName[7] = "";
        Program.rVarName[8] = "";
        Program.rVarName[9] = "";
        Program.rVarValue[0] = "";
        Program.rVarValue[1] = "";
        Program.rVarValue[2] = "";
        Program.rVarValue[3] = "";
        Program.rVarValue[4] = "";
        Program.rVarValue[5] = "";
        Program.rVarValue[6] = "";
        Program.rVarValue[7] = "";
        Program.rVarValue[8] = "";
        Program.rVarValue[9] = "";
        Program.check = "";
        Program.path = "";
        //[DllImport("C:\\Users\\brian\\masm\\solo\\gsharp\\gsserver5\\gscpp\\")]
    }
    ~ServClasses(){}

    public async void ParseFunc(string newQuery){
        // newQuery is fullPath
        for(ushort order = 2; order < newQuery.Length; ++order){
            if(newQuery[order] == '\\'){
                Program.bsLoc[Program.bsCount] = order;
                ++Program.bsCount;
                for(int bs = 0; bs < Program.bsCount; ++bs){
                Console.WriteLine("bsCount: " + (bs + 1) + "\t" + "bsLoc: " + (Program.bsLoc[bs] - 2));
                }
            }else if(newQuery[order] == '/'){
                Program.fsLoc[Program.fsCount] = order;
                ++Program.fsCount;
                for(int fs = 0; fs < Program.fsCount; ++fs){
                Console.WriteLine("fsCount: " + (fs + 1) + "\t" + "fsLoc: " + Program.fsLoc[fs - 2]);
                }
            }else if(newQuery[order] == '.'){
                Program.perLoc[Program.perCount] = order;
                ++Program.perCount;
                for(int per = 0; per < Program.perCount; ++per){
                Console.WriteLine("perCount: " + (per + 1) + "\t" + "perLoc: " + (Program.perLoc[per] - 2));
                }
            }else if(newQuery[order] == '?'){
                Program.qmLoc = order;
                Console.WriteLine("qmLoc: " + (Program.qmLoc - 2));
            }else if(newQuery[order] == '='){
                Program.eqLoc[Program.eqCount] = order;
                ++Program.eqCount;
                for(int eq = 0; eq < Program.eqCount; ++eq){
                Console.WriteLine("eqCount: " + (eq + 1) + "\t" + "eqLoc: " + (Program.eqLoc[eq] - 2));
                }
            }else if(newQuery[order] == '&'){
                Program.ampLoc[Program.ampCount] = order;
                ++Program.ampCount;
                for(int amp = 0; amp < Program.ampCount; ++amp){
                Console.WriteLine("ampCount: " + (amp + 1) + "\t" + "ampLoc: " + (Program.ampLoc[amp] - 2));
                }

    /*add method for recording % symbols and logging the following two char to read 
        Hebrew characters from the query string*/
            }else if((newQuery[order] == '*') && (newQuery[order - 1] == '*') && (newQuery[order - 2] == '*')){
                for(ushort parX = ++order; parX < Program.fullPath.Length; ++parX){
                    Program.parsedCom = Program.parsedCom + newQuery[parX];
                }
                Console.WriteLine("parsedCom: " + Program.parsedCom);
                if(Program.parsedCom == ""){
                    AdminFunc("exit");
                }else{
                    AdminFunc(Program.parsedCom);
                }
            }else
                continue;
        }
    }

    public async void AdminFunc(string usrCmd){
        if(usrCmd != ""){
                if(usrCmd != "exit"){
                        do{
                                if(usrCmd == "core"){
                                        Console.WriteLine("core\r" + 
                                        "write method dllimport to call functionality\r" +
                                        "in gsharp application and pass values to assembly" +
                                        " - create dll from .obj & .exe in core - provide" +
                                        "user input through key selection\rHere is where" +
                                        "I will make the DLL call to gsharp using the assembler"+
                                        "to pass values directly to a C++ process");
                                        Process.Start("C:\\Users\\brian\\masm\\solo\\gsharp\\core\\coreValues.exe", $"{Program.parsedCom} coredata arg2 arg3 arg4");
                                        break;
                                }else if(usrCmd == "exit"){
                                        Console.WriteLine("Exiting");
                                        break;
                                }else if(usrCmd == "admin"){
                                        Console.WriteLine("hit");
                                        usrCmd = "exit";
                                        break;
                                }else
                                continue;
                        }while(usrCmd != "exit" || usrCmd != "");
                }else{
                        Console.WriteLine("Exiting");

                }
        }else{
            // need to create limiter to prevent endless blank entries
            do{
                    usrCmd = Console.ReadLine();
                    if(usrCmd == ""){
                            Console.WriteLine("Exiting");
                            break;
                    }else if(usrCmd == "exit"){
                            Console.WriteLine("Exiting");
                            break;
                    }else if(usrCmd == "admin"){
                            Console.WriteLine("hit");
                    }else
                        continue;
            }while(usrCmd != "exit" || usrCmd != "");
	    }
    }

    public async void FixFilename(string fxFilename){
            string holdFullPath = Program.fullPath;
            Program.filename = "";
            if(Program.qmLoc > 0){
                for(int fixFilename = Program.bsLoc[Program.bsCount - 1] + 1; fixFilename < Program.qmLoc; ++fixFilename){
                Program.filename = Program.filename + holdFullPath[fixFilename];
                }
            }else{
                Program.filename = Program.fileWOExt + Program.fileExt;
                /*Console.WriteLine("FileWOExt + FileExt: " + check);
                for(int fixFilename = Program.bsLoc[0] + 1; fixFilename < check.Length + 3; ++fixFilename){
                Program.filename = Program.filename + holdFullPath[fixFilename];
                }*/
            }
            
            Console.WriteLine("filename after fix: " + Program.filename + "\t" + Program.check);
    }

    public async void FixDirectory(string fxDir){
        Program.directory = "";
        ushort incBSCount = 1;
        if(Program.bsCount > 1){
            do{
                for(int bsGreater = Program.bsLoc[incBSCount  - 1] + 1; bsGreater < Program.bsLoc[incBSCount]; ++bsGreater){
                Program.directory = Program.directory + fxDir[bsGreater];
                }
                //Console.WriteLine("in FixDirectory do/while loop");
                //Program.directory = Program.directory + "/";
                ++incBSCount;
                Program.directory = Program.directory + "/";
            }while(incBSCount < Program.bsCount);
        }else{
            for(int fixDir = 3; fixDir < fxDir.Length; ++fixDir){
                Program.directory = Program.directory + fxDir[fixDir];
            }
        }
        Console.WriteLine("Directory after fix: " + Program.directory);
    }

    public async void GetVarData(string passVars){     
            int countVars = 0;
            if(Program.eqCount == 1){
                for(int singleVar = (Program.qmLoc + 1); singleVar < Program.eqLoc[0]; ++singleVar){
                    Program.rVarName[0] = Program.rVarName[0] + passVars[singleVar];
                }
                if(Program.parsedCom == "")
                    for(int singleVal = Program.eqLoc[0]; singleVal < passVars.Length; ++singleVal){
                        Program.rVarValue[0] = Program.rVarValue[0] + passVars[singleVal];
                }else{
                    for(int singValue = Program.eqLoc[0]; singValue < (passVars.Length - (Program.parsedCom.Length + 3)); ++singValue){
                        Program.rVarValue[0] = Program.rVarValue[0] + passVars[singValue];
                    }
                }
            }else{
                if(countVars == 0){
                    for(int hVars = Program.qmLoc + 1; hVars < Program.eqLoc[countVars]; ++hVars){
                        Program.rVarName[countVars] = Program.rVarName[countVars] + passVars[hVars];
                    }
                    for(int oneVal = Program.eqLoc[countVars]; oneVal < Program.ampLoc[countVars]; ++oneVal){
                        Program.rVarValue[countVars] = Program.rVarValue[countVars] + passVars[oneVal];
                    }
                    ++countVars;
                    do{
                        for(int remVals = Program.ampLoc[countVars]; remVals < Program.eqLoc[countVars + 1]; ++remVals){
                            Program.rVarName[countVars] = Program.rVarName[countVars] + passVars[remVals];
                        }
                        if(countVars < Program.ampCount){
                            for(int remainV = Program.eqLoc[countVars + 1]; remainV < Program.fileExt.Length; ++remainV){
                                Program.rVarValue[countVars + 1] = Program.rVarValue[countVars] + passVars[remainV];
                            }
                        }else{
                            for(int remValues = Program.eqLoc[countVars]; remValues < (Program.fileExt.Length - (Program.adminCommand.Length + 3)); ++remValues){
                                Program.rVarValue[countVars] = Program.rVarValue[countVars] + passVars[remValues];
                            } 
                        }
                        ++countVars;
                    }while(countVars < Program.eqCount);
            }
            }
        // Console.WriteLine($"rVarName[{countVars}]: " + rVarName[countVars]);
           /* int holdCount = countVars;
            for(int hValue = eqLoc[countVars] + 1; hValue < ampLoc[countVars]; ++hValue){ // need to make array for multiple ampersand locations
                    rVarValue[countVars] = rVarValue[countVars] + fullPath[hValue];
            }
            ++countVars;
            do{
                    for(int hVarsCont = Program.ampLoc[countVars] + 1; hVarsCont < eqLoc[countVars]; ++hVarsCont){
                            rVarName[countVars] = rVarName[countVars] + fullPath[hVarsCont];        
                    }
                    holdCount = countVars;
                    countVars = 0;
                    //Console.WriteLine("ampersand location: " + Program.ampLoc[countVars] + "\t count: " + countVars);
                    for(int hValueCont = eqLoc[countVars + 1] + 1; hValueCont < ampLoc[countVars + 1]; ++hValueCont){
                            rVarValue[countVars] = rVarValue[countVars] + fullPath[hValueCont];
                    }
                    countVars = holdCount;
            ++countVars;
            }while(countVars < Program.eqCount);
            */
            
            for(int iterVars = 0; iterVars < 10; ++iterVars){
            Console.WriteLine($"rVarName[{(iterVars + 1)}]: " + rVarName[iterVars] + "\t" + $"rVarValue[{(iterVars + 1)}]: " + rVarValue[iterVars]);
            //must clear variables 
            }

            countVars = 0;
        }
}


class WebServer{
HttpListener _listener; // Declare class variables for use in constructor before constructor declaration
string _baseFolder; 

public WebServer(string uriPrefix, string baseFolder){
_listener = new HttpListener();
_listener.Prefixes.Add (uriPrefix);
_baseFolder = baseFolder;
}

//~WebServer(){}

public async void Start(){
_listener.Start();
	while(true)
	try{
		var context = await _listener.GetContextAsync();
        /* the example shows the creation of a auto var that is set to the returned value
        of the awaited process*/
		Task.Run (() => ProcessRequestAsync (context));
	}
	catch (HttpListenerException){break;} 
	catch (InvalidOperationException){break;}
}

public void Stop() => _listener.Stop();

async void ProcessRequestAsync(HttpListenerContext context){
    /* can I write class obj that has parameters with same named
        variables - functionality is passing the code contents as string? - 
        as obj defined... just encrypt in hebrew and pass as objects in
        get request string as in console.html*/
    var parser = new ServClasses();
            
    try{
        Program.filename = Path.GetFileName(context.Request.RawUrl);
        Program.fullPath = Path.GetFullPath(context.Request.RawUrl);
        Program.directory = Path.GetDirectoryName(context.Request.RawUrl);
        Program.fileExt = Path.GetExtension(context.Request.RawUrl);
        Program.fileWOExt = Path.GetFileNameWithoutExtension(context.Request.RawUrl);

        //if(Program.directory != "" && Program.filename != "" && Program.qmLoc != 0){
        Console.WriteLine("filename: " + Program.filename + "\n" +
                "fullPath: " + Program.fullPath + "\n" + "Directory: " + Program.directory +
                "\nFileExtension: " + Program.fileExt);

        ++Program.counter;

        Program.handleString = ($"({Program.counter}) [{DateTime.Now}]: {Program.filename}\n");
    
        if(Program.filename == ""){
            Program.filename = "logUnk.html";
            Program.directory = "defaults/defUnk/";
            //parser.ParseFunc(Program.filename);
        }else{
            parser.ParseFunc(Program.fullPath);
            
            parser.GetVarData(Program.fileExt);

        
// is allowing void processes to be run with return to var
// ParseFunc() had to be converted to a Task type with a return added.
// because it is the Task.Run method loading the var, not my functions
        
        parser.FixFilename(Program.fullPath);
        if(Program.bsLoc[1] > 0){
        parser.FixDirectory(Program.fullPath);
        }else{}

        //parser.GetVarData(Program.fullPath);
        }
        /*}else if(Program.directory == "" && Program.qmLoc == 0 && Program.filename == ""){
            Program.filename = "defaults/defUnk/logUnk.html";
        }else{
            Console.WriteLine("no directory no query string has filename");
        }*/
//        string path = _baseFolder + Program.directory + "/" + Program.filename;
        
        //Program.fullPath = Path.Combine(Program.directory, Program.filename);
        if(Program.directory != "" && Program.directory.Length > 1
        ){ 
            Program.path = _baseFolder + "/" + Program.directory + Program.filename;
        //string path = Path.Combine(_baseFolder, Program.fullPath);
        }else{
            Program.path = _baseFolder + "/" + Program.filename;
        }

        Console.WriteLine("TEST This is path variable: " + path);
//path = "webroot/passparseddata.html";
//path = Path.Combine(_baseFolder, "index.html");
        byte[] msg;
        if( !File.Exists (path)){ 
        Console.WriteLine("Resource not found: " + path);
        //get requests to here  - must load data into variable
        context.Response.StatusCode = (int) HttpStatusCode.NotFound;
        msg = Encoding.UTF8.GetBytes(/*"<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><link rel=\"icon\" type=\"image/x-icon\" href=\"brianhead.jpeg\"></link></head>" +
                        "<body>DEFAULT MESSAGE<script>localStorage.setItem(\"IAM\", \"Sintax\");</script></body></html>"*/"Default message");
        }else{context.Response.StatusCode = (int) HttpStatusCode.OK;
        msg = File.ReadAllBytes(path);}
                context.Response.ContentLength64 = msg.Length;  //transferring attribute values between objects
        using (Stream s = context.Response.OutputStream)
        await s.WriteAsync (msg, 0, msg.Length);
    }catch(Exception ex){Console.WriteLine("Request error: " + ex);}
}
}




static void Main(string[] argv){
    for(int i = 0; i < argv.Length; ++i){ 
        if(argv[i] != ""){
        Console.WriteLine(argv[i]);
        }else{
        break;
        }
    }

    var server = new WebServer("http://72.173.195.101:80/", @"gsharp/gsserver5/webroot");
    
    try{
        server.Start();
        Console.WriteLine("G# Server running... Enter command, or press Enter to stop");
        Program.adminCommand = Console.ReadLine();
        var servCom = new ServClasses();
        servCom.AdminFunc(Program.adminCommand);
    }finally{server.Stop();}
}
}
}