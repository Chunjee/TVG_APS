#NoEnv
#NoTrayIcon
#SingleInstance Force
SetBatchLines -1 ;Go as fast as CPU will allow
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode InputThenPlay

;~~~~~~~~~~~~~~~~~~~~~
;dependecies
;~~~~~~~~~~~~~~~~~~~~~
;None

The_ProjectName := "TVG APS"
The_VersionName := "v0.1.0"


;~~~~~~~~~~~~~~~~~~~~~
;Startup
;~~~~~~~~~~~~~~~~~~~~~

BuildGUI()


;~~~~~~~~~~~~~~~~~~~~~
;Main
;~~~~~~~~~~~~~~~~~~~~~
;set main screen search area vars
Area_TopX := 1
Area_TopY := 1
Area_LowX := 1670
Area_LowY := 1040

;enter main loop forever
Loop,
{
	If (Active_Bool = True) {
		Fn_WholeScreenClickAll(A_ScriptDir . "\Data\Images\DDScheckmark.png")
		Fn_WholeScreenClickAll(A_ScriptDir . "\Data\Images\stillcheckmarked.png")
		Fn_WholeScreenClickAll(A_ScriptDir . "\Data\Images\Yes.png")
		Sleep, 30
	}
}


;~~~~~~~~~~~~~~~~~~~~~
;Controls
;~~~~~~~~~~~~~~~~~~~~~

F11::
#!r::
;Turn On
Sb_TurnOn()
Return

F12::
#!s::
;Turn Off
Sb_TurnOff()
Return


BuildGUI()
{
Global

Gui, Main: Add, Button, x480 y4 w60 h30 gButton-Start, Start (F11)
Gui, Main: Add, Button, x540 y4 w60 h30 gButton-Stop, Stop (F12)
;Gui, Main: Add, Button, x550 y4 w50 h30 gButton-Main, Go

Gui, Main: Add, Picture, x12 y4 , %A_ScriptDir%\Data\Images\Title.png
;Gui, Main: Add, Text, x206 y24, % The_VersionName

;Status display
Gui, Main: Add, Text, x360 y16, Status:
Gui, Main: Font, s14 w70, Arial
Gui, Main: Add, Text, vGui_CurrentStatus x400 y10, Stopped 
;Gui, Main: Add, ListView, x10 y40 w590 h200 Grid vListView, Track|Code|West|East|Difference




;Menu
Menu, FileMenu, Add, R&estart`tCtrl+R, Menu_File-Restart
Menu, FileMenu, Add, E&xit`tCtrl+Q, Menu_File-Quit
Menu, MenuBar, Add, &File, :FileMenu  ; Attach the sub-menu that was created above
Menu, HelpMenu, Add, &About, Menu_About
Menu, HelpMenu, Add, &Confluence`tCtrl+H, Menu_Confluence
Menu, HelpMenu, Add, Show Area`tCtrl+S, Menu_ShowArea
Menu, MenuBar, Add, &Help, :HelpMenu
Gui, Main: Menu, MenuBar


Gui, Main: Show,, % The_ProjectName
Return


MainGuiClose:
ExitApp


Button-Start:
Sb_TurnOn()
Return

Button-Stop:
Sb_TurnOff()
Return


DoubleClick:
;Double clicking items in the Listview will do nothing, ever?
Return


;Menu Shortcuts
Menu_Confluence:
Msgbox, There is no confluence page yet
;Run http://confluence.tvg.com/pages/viewpage.action?pageId=NONE
Return

Menu_About:
Msgbox, %The_ProjectName% %The_VersionName% `nUnchecks the On TV button when visible on screen
Return

Menu_ShowArea:
ShowArea("Area")
Return

Menu_File-Restart:
Reload

Menu_File-Quit:
ExitApp
}


;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
;Functions
;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\



Fn_AreaClickAll(para_Image)
{
global

SearchClickandReport(Area_TopX,Area_TopY,Area_LowX,Area_LowY,para_Image,"40")
Return
}


Fn_WholeScreenClickAll(para_Image)
{
global

SearchClickandReport(Area_TopX,Area_TopY,Area_LowX,Area_LowY,para_Image,"40")
Return
}


Fn_AreaClickAllBACKUP(para_Image)
{
global

UnfoundCounter := 0

  While (UnfoundCounter < 3) {
    Sleep 20
    CurrentTry := SearchClickandReport(Area_TopX,Area_TopY,Area_LowX,Area_LowY,para_Image,"40")
    if (CurrentTry = 0) {
      UnfoundCounter++
    }
  }
Return
}

ShowArea(Name)
{
Mousemove , %Name%_TopX, %Name%_TopY
Sleep 700
MouseMove , %Name%_LowX, %Name%_LowY,80
Return
}

ShowXY(para_topx,para_topy,para_lowx,para_lowy)
{
Mousemove , %para_topx%, %para_topy%
Sleep 700
MouseMove , %para_lowx%, %para_lowy%,10
Return
}

SearchClickandReport(1X,1Y,2X,2Y,ImagePath,Variation)
{
global
ImageSearch , Mouse_X, Mouse_Y, %1X%, %1Y%, %2X%, %2Y%, *%Variation% %ImagePath%
	if (!Errorlevel) { ;if found
		;grab users current mouse location for later
		MouseGetPos, xpos, ypos 
		;Adjust Mouse vars slightly
		Mouse_Y += 2
		
		;Click the target
		Click %Mouse_X%, %Mouse_Y%
		;Mouse_X := Mouse_X - 5
		;Mouse_Y := Mouse_Y - 5
		;ControlClick, X%Mouse_X% Y%Mouse_Y%,
		;MouseMove, %Mouse_X%, %Mouse_Y%
		;msgbox, here
		Sleep 60
		
		;Return Mouse to orginal location
		MouseMove, %xpos%, %ypos%, 0
		Return 1
	} else {
		Return 0
	}
}
Return


Sb_TurnOn() {
	global

	GuiControl, Main:Text, Gui_CurrentStatus, Running
	Active_Bool := True
}

Sb_TurnOff() {
	global

	GuiControl, Main:Text, Gui_CurrentStatus, Stopped
	Active_Bool := False
}

;~~~~~~~~~~~~~~~~~~~~~
;Resize Windows
;~~~~~~~~~~~~~~~~~~~~~

#SingleInstance
DetectHiddenWindows, On
SetTitleMatchMode, 2

ResizeWin(Width = 0,Height = 0)
{
  WinGetPos,X,Y,W,H,A
  If %Width% = 0
    Width := W

  If %Height% = 0
    Height := H

  WinMove,A,,%X%,%Y%,%Width%,%Height%
}

;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
;Timers
;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\