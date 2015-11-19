#Persistent
#InstallKeybdHook

if (A_IsCompiled != 1)
	Menu, Tray, Icon, Icon.ico 

#include SetTimerEx.ahk
#Include Informer.ahk

global timersArray := Object()
global configFileName := "config.ini"
global config := Object()
global currentBeepInfo := Object()

ReadOrDefaultConfig()

Menu, tray, add, Reload config, ReloadConfigLabel
Menu, tray, add, Get KeyCode, GetKeyCodeLabel
Menu, tray, add, Open config.ini, OpenConfigLabel

IfNotExist, %configFileName%
{
	MsgBox, %configFileName% is missing. `nScript will create it now.
	WriteConfigFile()
}
ReadAllKeys()
return

ClearTimers(){
	For keyInfo in timersArray
	{
		SetTimerState(keyInfo, false)
	}

	timersArray := Object()
}

ReadAllKeys(){
	Loop
	{		
		keyInfo:=ReadInfo("Key" . A_Index)
		if (keyInfo==-1)
			break

		timersArray.Insert(keyInfo)
		
		RegisterHotkey(keyInfo)
		if (keyInfo.runOnStart=="True"){
			SetTimerState(keyInfo, true)
		}
	}
}

ValidateKeyValues(keyInfo){
	if (keyInfo.interval<100)
	{
		Log("Warning", "Interval for " . keyInfo.name . " was <100 (" . keyInfo.interval . "). Set to deafult 1000.")
		keyInfo.interval:=1000
	}
	if (keyInfo.beepLength=0)
	{
		Log("Warning", "BeepLength for " . keyInfo.name . " was <=0 (" . keyInfo.beepLength . "). Set to deafult 150.")
		keyInfo.interval:=150		
	}	
	if (keyInfo.sendType<=0 || keyInfo.sendType>3)
	{
		Log("Warning", "SendType for " . keyInfo.name . " was out of range (" . keyInfo.sendType . "). Set to deafult 3.")
		keyInfo.sendType:=3	

	}

	if (keyInfo.name!="Config")
	{
		if (keyInfo.beepLength>=keyInfo.interval)
		{
			newBeep:=keyInfo.interval-50
			Log("Warning", "BeepLength for " . keyInfo.name . " was >= Interval (" . keyInfo.beepLength . ">=" . keyInfo.interval . "). This can cause input latency & other problems. Set to " . newBeep)
			keyInfo.beepLength:=newBeep
		}
	}
}

ReadOrDefaultConfig(){

	IniRead, interval, %configFileName%, Config, Interval, 1000
	IniRead, runOnStart, %configFileName%, Config, RunOnStart, False
	IniRead, enableSound, %configFileName%, Config, EnableFrequency, 900
	IniRead, disableSound, %configFileName%, Config, DisableFrequency, 600
	IniRead, tickSound, %configFileName%, Config, TickFrequency, 300
	IniRead, notifyType, %configFileName%, Config, NotifyType, 3
	IniRead, notificationTime, %configFileName%, Config, NotificationTime, 2000
	IniRead, sendType, %configFileName%, Config, SendType, 3
	IniRead, beepLength, %configFileName%, Config, BeepLength, 150
	
	config:=Object()
	config.name:="Config"
	config.interval:=interval
	config.runOnStart:=runOnStart
	config.disableSound:=disableSound
	config.enableSound:=enableSound
	config.tickSound:=tickSound
	config.notifyType:=notifyType
	config.sendType:=sendType
	config.notificationTime:=notificationTime
	config.beepLength:=beepLength

	ValidateKeyValues(config)
}

WriteConfigFile(){
	try{
		IniWrite, % config.interval, %configFileName%, Config, Interval
		IniWrite, % config.runOnStart, %configFileName%, Config, RunOnStart
		IniWrite, % config.enableSound, %configFileName%, Config, EnableFrequency
		IniWrite, % config.disableSound, %configFileName%, Config, DisableFrequency
		IniWrite, % config.tickSound, %configFileName%, Config, TickFrequency
		IniWrite, % config.notifyType, %configFileName%, Config, NotifyType
		IniWrite, % config.notificationTime, %configFileName%, Config, NotificationTime
		IniWrite, % config.sendType, %configFileName%, Config, SendType
		IniWrite, % config.beepLength, %configFileName%, Config, BeepLength
	}
	catch e
	{
		Log("Error", "Cannot create config file. Error description:" . e)
	}
}

ReadInfo(sectionName){
	
	IniRead, k, %configFileName%, %sectionName%, Key, -1
	IniRead, tk, %configFileName%, %sectionName%, ToggleKey, -1
	IniRead, i, %configFileName%, %sectionName%, Interval, % config.interval
	IniRead, name, %configFileName%, %sectionName%, Name, %tk% - %k%
	IniRead, enableSound, %configFileName%, %sectionName%, EnableFrequency, % config.enableSound
	IniRead, disableSound, %configFileName%, %sectionName%, DisableFrequency, % config.disableSound
	IniRead, tickSound, %configFileName%, %sectionName%, TickFrequency, % config.tickSound
	IniRead, runOnStart, %configFileName%, %sectionName%, RunOnStart, % config.runOnStart
	IniRead, beepLength, %configFileName%, %sectionName%, BeepLength, % config.beepLength
	IniRead, sendType, %configFileName%, Config, SendType, % config.sendType

	if (k==-1||tk==-1){
		return -1
	}

	keyInfo:=Object()
	keyInfo.key:=k
	keyInfo.toggleKey:=tk
	keyInfo.interval:=i
	keyInfo.name:=name
	keyInfo.enableSound:=enableSound
	keyInfo.disableSound:=disableSound
	keyInfo.tickSound:=tickSound
	keyInfo.runOnStart:=runOnStart
	keyInfo.running:=false
	keyInfo.beepLength:=beepLength
	keyInfo.sendType:=sendType

	ValidateKeyValues(keyInfo)

	return keyInfo
}

TimerSubscriber(keyInfo){
	key:=keyInfo.key
	if (keyInfo.sendType==1)
		Send, %key%
	else if (keyInfo.sendType==2)
		SendPlay, %key%
	else 
		SendInput, %key%

	if (keyInfo.tickSound!=-1){
		SoundBeep, % keyInfo.tickSound, keyInfo.beepLength
	}
}

RegisterHotkey(keyInfo){
	Hotkey, % keyInfo.toggleKey, hotkeyLabel
}

SetTimerState(keyInfo, state){
	if (!state){
		keyInfo.timer.stop()
		keyInfo.timer:=""
		keyInfo.running:=false
		if (keyInfo.disableSound!=-1){
			SoundBeep, % keyInfo.disableSound, keyInfo.beepLength
		}
	}
	else
	{
		if (!keyInfo.running){
			keyInfo.timer:=SetTimerEx(keyInfo.interval, "TimerSubscriber", keyInfo)
			keyInfo.running:=true
			if (keyInfo.enableSound!=-1){
				SoundBeep, % keyInfo.enableSound, keyInfo.beepLength
			}
		}
	}
}

Log(level, message){
	time:= A_MM . "." . A_DD . "::" . A_Hour . ":" . A_Min . ":" . A_Sec
	FileAppend, %time% (%level%) > %message%`n, log.txt
}

Notify(message){
	if (config.notifyType==0)
		return
	else if (config.notifyType==1)
	{
		Informer.StaticToolTip(message)		
	}
	else if (config.notifyType==2){
		Informer.MouseToolTip(message, config.notificationTime)
	}
	else if (config.notifyType==3){
		Informer.SplashImage(message, config.notificationTime)
	}
}

hotkeyLabel:
	founded:=false
	Loop, % timersArray.GetCapacity()
	{
		keyInfo:=timersArray[A_Index]
		if (keyInfo.toggleKey==A_ThisHotkey){
			founded:=True
			Break
		}
	}
	if (founded)
	{
		Notify((!keyInfo.running ? "Enabled " : "Disabled ") . keyInfo.name)
		SetTimerState(keyInfo, !keyInfo.running)
	}
	else
	{
		Log("Error", "Cannot found " . keyInfo.name)
	}
Return

ReloadConfigLabel:
	ClearTimers()
	ReadOrDefaultConfig()
	ReadAllKeys()
return

GetKeyCodeLabel:
	KeyHistory
return

OpenConfigLabel:
	Run, %configFileName%
return