@echo off
SET THEFILE=ex2
echo Assembling %THEFILE%
M:\LazarusTrunk\fpc\bin\x86_64-win64\as.exe --64 -o M:\My_Projects\expanded_but\examples\ex2\lib\x86_64-win64\ex2.o   M:\My_Projects\expanded_but\examples\ex2\lib\x86_64-win64\ex2.s
if errorlevel 1 goto asmend
Del M:\My_Projects\expanded_but\examples\ex2\lib\x86_64-win64\ex2.s
SET THEFILE=M:\My_Projects\expanded_but\examples\ex2\ex2.exe
echo Linking %THEFILE%
M:\LazarusTrunk\fpc\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections  -s --subsystem windows --entry=_WinMainCRTStartup    -o M:\My_Projects\expanded_but\examples\ex2\ex2.exe M:\My_Projects\expanded_but\examples\ex2\link19204.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end
