echo off
ml64 /nologo /c /Zi /Cp %1.asm
cl /nologo /O2 /Zi /utf-8 /EHa /EHsc /Fe%2.exe %3.cpp %1.obj