goto, Informer_end

class Informer{
	static monitorCount:=1

	__New(){
		SysGet, count, MonitorCount
		Informer.monitorCount:=count
	}

	StaticToolTip(text, time:=1000, x:=0, y:=0, n:=1){
		Informer.ToolTip(text,time, x, y, n, "Screen")
	}
	
	ColoredSplashImage(text, time:=1000, fontSize:=12, color:="Silver", x:=0, y:=0){
		Gosub, TurnOffSI
		SplashImage,,x%x% y%y% b fs%fontSize% cw%color%, %text%
		if (time!=-1)
			SetTimer, TurnOffSI, %time%
	}
	
	SplashImage(text, time:=1000, fontSize:=12, x:=0, y:=0){
		SplashImage, off
		SetTimer, TurnOffSI, Off
		SplashImage,,x%x% y%y% b fs%fontSize%, %text%
		if (time!=-1)
			SetTimer, TurnOffSI, %time%
	}
	
	CloseSplashImage(){
		Gosub, TurnOffSI		
	}

	MouseToolTip(text, time:=1000, n:=1){
		CoordMode, Mouse, Screen
		MouseGetPos, m_x, m_y
		Informer.ToolTip(text,time, m_x, m_y, n, "Screen")
	}

	CenterOnCurrentMonitorToolTip(text, time:=1000, n:=1){
		gosub, TurnOff%n%		
		Informer.ToolTip(text, time, A_ScreenWidth/2,0, n, "Screen")
	}

	ToolTip(text, time:=1000, x:=0, y:=0, n:=1, mode:="Relative"){
		CoordMode, ToolTip, %mode%
		SetTimer, TurnOff%n%, Off
		ToolTip, %text%, %x%, %y%, %n%
		if (time!=-1)
			SetTimer, TurnOff%n%, %time%
		Return
	}

	TurnOffTooltip(n:=1){		
		ToolTip,,,,%n%
	}
}

TurnOff1:
	ToolTip
	SetTimer, TurnOff1, Off
return

TurnOff2:
	ToolTip,,,,2
	SetTimer, TurnOff2, Off
return

TurnOff3:
	ToolTip,,,,3
	SetTimer, TurnOff3, Off
return

TurnOffSI:
	SplashImage, off
	SetTimer, TurnOffSI, Off
Return

Informer_end: