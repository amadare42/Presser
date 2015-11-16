#Persistent

#include SetTimerEx.ahk
#Include Informer.ahk

global timersArray := Object()
global arrayLenght := 0
global fileName := "presser.ini"
global defaultInfo:=CreateDefaultInfo()

Loop
{		
	keyInfo:=ReadInfo("Key" . A_Index)
	if (keyInfo==-1)
		break

	timersArray.Insert(keyInfo)
	arrayLenght++
	
	RegisterHotkey(keyInfo)
	if (keyInfo.runOnStart=="True"){
		SetTimerState(keyInfo, true)
	}
}
return

CreateDefaultInfo(){

	IniRead, interval, %fileName%, Config, Interval, 1000
	IniRead, runOnStart, %fileName%, Config, RunOnStart, False
	IniRead, enableSound, %fileName%, Config, EnableFrequency, 900
	IniRead, disableSound, %fileName%, Config, DisableFrequency, 600
	IniRead, tickSound, %fileName%, Config, TickFrequency, 300
	IniRead, notifyType, %fileName%, Config, NotifyType, 2
	
	defaultInfo:=Object()
	defaultInfo.interval:=interval
	defaultInfo.runOnStart:=runOnStart
	defaultInfo.disableSound:=disableSound
	defaultInfo.enableSound:=enableSound
	defaultInfo.tickSound:=tickSound
	defaultInfo.notifyType:=notifyType

	return defaultInfo
}

ReadInfo(sectionName){
	
	IniRead, k, %fileName%, %sectionName%, Key, -1
	IniRead, tk, %fileName%, %sectionName%, ToggleKey, -1
	IniRead, i, %fileName%, %sectionName%, Interval, % defaultInfo.interval
	IniRead, name, %fileName%, %sectionName%, Name, %tk% - %k%
	IniRead, enableSound, %fileName%, %sectionName%, EnableFrequency, % defaultInfo.enableSound
	IniRead, disableSound, %fileName%, %sectionName%, DisableFrequency, % defaultInfo.disableSound
	IniRead, tickSound, %fileName%, %sectionName%, TickFrequency, % defaultInfo.tickSound
	IniRead, runOnStart, %fileName%, %sectionName%, RunOnStart, % defaultInfo.runOnStart

	if (k==-1||tk==-1){
		;Log("Error", "Key or ToggleKey is missing for " . name . " key.")
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

	return keyInfo
}

TimerSubscriber(keyInfo){
	key:=keyInfo.key
	Send, %key%
	if (keyInfo.tickSound!=-1){
		SoundBeep, % keyInfo.tickSound, 300
	}
}
;
RegisterHotkey(keyInfo){
	Hotkey, % keyInfo.toggleKey, hotkeyLabel
}

SetTimerState(keyInfo, state){
	if (!state){
		keyInfo.timer.stop()
		keyInfo.timer:=""
		keyInfo.running:=false
		if (keyInfo.disableSound!=-1){
			SoundBeep, % keyInfo.disableSound, 300
		}
	}
	else
	{
		if (!keyInfo.running){
			keyInfo.timer:=SetTimerEx(keyInfo.interval, "TimerSubscriber", keyInfo)
			keyInfo.running:=true
			if (keyInfo.enableSound!=-1){
				SoundBeep, % keyInfo.enableSound, 300
			}
		}
	}
}

Log(level, message){
	time:= A_DDD . "::" . A_Hour . ":" . A_Min . ":" . A_Sec
	FileAppend, %time% (%level%) > %message%`n, log.txt
}

Notify(message){
	if (defaultInfo.notifyType==0)
		return
	else if (defaultInfo.notifyType==1)
	{
		Informer.StaticToolTip(message)		
	}
	else if (defaultInfo.notifyType==2){
		ToolTip, % message
	}
	else if (defaultInfo.notifyType==3){
		Informer.SplashImage(message)
	}
}

hotkeyLabel:
	founded:=false
	Loop, %arrayLenght%
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