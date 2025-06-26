## Snake game written in 64-bit assembly.
### Runing the code.
this code uses MASM assembler.
you can run the code with the following command. 
```bash
echo off
ml64 /nologo /c /Zi /Cp %1.asm
cl /nologo /O2 /Zi /utf-8 /EHa /Fe%1.exe c.cpp %1.obj /link /largeaddressaware:no
```
