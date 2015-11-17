@echo off

::change version for new releases
set version=0.21
::specify path to compiler
set CompilerFolderPath=%ProgramFiles%\AutoHotkey\Compiler

:: Don't edit anything below as long as it works
set Ahk2ExePath="%CompilerFolderPath%\Ahk2Exe.exe"
set AutoHotkeySCPath="%CompilerFolderPath%\AutoHotkeySC.bin"
set AutoHotkeyU64Path="%CompilerFolderPath%\Unicode 64-bit.bin"
set AutoHotkeyU32Path="%CompilerFolderPath%\Unicode 32-bit.bin"
set AutoHotkeyANSI32Path="%CompilerFolderPath%\ANSI 32-bit.bin"

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
if not exist bin/presser_SC_v%version%.exe goto :Error

echo Build Unicode 64 version...
%Ahk2ExePath% /in presser.ahk /out bin/presser_U64_v%version%.exe /icon icon.ico /bin %AutoHotkeyU64Path%
if not exist bin/presser_U64_v%version%.exe goto :Error

echo Build Unicode 32 version...
%Ahk2ExePath% /in presser.ahk /out bin/presser_U32_v%version%.exe /icon icon.ico /bin %AutoHotkeyU32Path%
if not exist bin/presser_U32_v%version%.exe goto :Error

echo Build ANSI 32 version...
%Ahk2ExePath% /in presser.ahk /out bin/presser_ANSI32_v%version%.exe /icon icon.ico /bin %AutoHotkeyANSI32Path%
if not exist bin/presser_ANSI32_v%version%.exe goto :Error

echo Done.
exit
:Error
echo compiling error!
exit	
