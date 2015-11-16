@echo off
set version=0.1
set CompilerFolderPath=%ProgramFiles%\AutoHotkey\Compiler

:: Don't edit this
set Ahk2ExePath="%CompilerFolderPath%\Ahk2Exe.exe"
set AutoHotkeySCPath="%CompilerFolderPath%\AutoHotkeySC.bin"
set AutoHotkeySCPath64="%CompilerFolderPath%\Unicode 64-bit.bin"

IF not exist bin (
	echo Creating bin folder.
	mkdir bin
) else (
	echo Clearing bin folder.
	cd bin
	del *.* /q
	cd ..
)

echo Build SC version...
%Ahk2ExePath% /in presser.ahk /out bin/presser_SC_v%version%.exe /icon icon.ico /bin %AutoHotkeySCPath%
echo Build Unicode 64 version...
%Ahk2ExePath% /in presser.ahk /out bin/presser_U64_v%version%.exe /icon icon.ico /bin %AutoHotkeySCPath64%
echo Done.