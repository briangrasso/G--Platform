using System;
using System.IO;

namespace datdot
{
    class Program
    {
	public static byte[] dotspermill = new byte[4000];

        static void Main(string[] args)
        {
		using (Stream NewerS = new FileStream("..\\solo\\gsharp\\usrfiles\\asdf", FileMode.Open)){
			//	NewerS.Read(dotspermill, 0, dotspermill.Length));
			NewerS.Write(dotspermill, 0, dotspermill.Length);
			Console.WriteLine(NewerS.Read(dotspermill, 0, dotspermill.Length));
		}
		using (Stream objToFile = new FileStream("F:\\bitcoin\\bitcoin-22.0\\datadir\\chainstate\\test.ldb", FileMode.Create)){
			objToFile.Write(dotspermill, 0, dotspermill.Length);

		}
/*
            using (Stream newStream = new FileStream("F:\\bitcoin\\bitcoin-22.0\\datadir\\blocks\\blk00009b.dat", FileMode.Create)){
					newStream.Write(dotspermill, 0, dotspermill.Length);*/
Console.ReadLine();
//Write the file into the byte[] !!!!!!!!!!! Use A VAR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					//Console.WriteLine(newStream.Read (dotspermill, 0, dotspermill.Length));
					// the .dat file may be a string and need to be read from c++!!!!!!!!!!
/*
Console.ReadLine();
		FileStream fs1 = File.OpenRead("F:\\bitcoin\\bitcoin-22.0\\datadir\\blocks\\blk00003.dat");
Console.ReadLine();
		Console.WriteLine(fs1.Read (dotspermill, 0, dotspermill.Length));
*/
        }
    }
}
