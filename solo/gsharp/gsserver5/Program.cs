using System;
using System.IO;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

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
                                if(usrCmd == ""){
                                        Console.WriteLine("Exiting");
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
                        AdminFunc("exit");
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

    public async void FixDirectory(string fxDir){
        Program.directory = "";
        ushort incBSCount = 1;
        if(Program.bsCount > 1){
            do{
                for(int bsGreater = Program.bsLoc[incBSCount - 1] + 1; bsGreater < Program.bsLoc[incBSCount] - 1; ++bsGreater){
                Program.directory = Program.directory + fxDir[bsGreater];
                }
                Program.directory = Program.directory + "/";
                ++incBSCount;
            }while(incBSCount < Program.bsCount);
        }else{
            for(int fixDir = Program.bsLoc[incBSCount]; fixDir < fxDir.Length; ++fixDir){
                Program.directory = Program.directory + fxDir[fixDir];
            }
        }
        Console.WriteLine("Directory after fix: " + Program.directory);
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

~WebServer(){}

public async void Start(){
_listener.Start();
	while(true)
	try{
		var context = await _listener.GetContextAsync();
		Task.Run (() => ProcessRequestAsync (context));
	}
	catch (HttpListenerException){break;} 
	catch (InvalidOperationException){break;
}
}

public void Stop() => _listener.Stop();

async void ProcessRequestAsync(HttpListenerContext context){
    var parser = new ServClasses();
            
    try{
        Program.filename = Path.GetFileName(context.Request.RawUrl);
        Program.fullPath = Path.GetFullPath(context.Request.RawUrl);
        Program.directory = Path.GetDirectoryName(context.Request.RawUrl);

        Console.WriteLine("filename: " + Program.filename + "\n" +
                "fullPath: " + Program.fullPath + "\n" + "Directory: " + Program.directory);

        ++Program.counter;

        Program.handleString = ($"({Program.counter}) [{DateTime.Now}]: {Program.filename}\n");
    
        if(Program.filename == ""){
            Program.filename = "defaults\\defUnk\\logUnk.html";
        }else{
            parser.ParseFunc(Program.fullPath);
            Console.WriteLine("");
        }

        string holdFullPath = Program.fullPath;
        Program.filename = "";
        for(int fixFilename = Program.bsLoc[Program.bsCount - 1] + 1; fixFilename < Program.qmLoc; ++fixFilename){
            Program.filename = Program.filename + holdFullPath[fixFilename];
        }
        Console.WriteLine("filename after fix: " + Program.filename);

        if(Program.directory != ""){
            var parseDir = new ServClasses();
            parseDir.FixDirectory(Program.directory);
        }

        string path = _baseFolder + Program.directory + "/" + Program.filename;

        byte[] msg;
        if( !File.Exists (path)){ 
        Console.WriteLine("Resource not found: " + path);
        //get requests to here  - must load data into variable
        context.Response.StatusCode = (int) HttpStatusCode.NotFound;
        msg = Encoding.UTF8.GetBytes("<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><link rel=\"icon\" type=\"image/x-icon\" href=\"brianhead.jpeg\"></link></head>" +
                        "<body>print<script>localStorage.setItem(\"IAM\", \"Sintax\");</script></body></html>");
        }else{context.Response.StatusCode = (int) HttpStatusCode.OK;
        msg = File.ReadAllBytes(path);}
                context.Response.ContentLength64 = msg.Length;  //transferring attribute values between objects
        using (Stream s = context.Response.OutputStream)await s.WriteAsync (msg, 0, msg.Length);
    }catch(Exception ex){Console.WriteLine("Request error: " + ex);};
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

    var server = new WebServer("http://172.17.128.1:80/", @"webroot/");
    
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