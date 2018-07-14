#include <AutoItConstants.au3>
HotKeySet("^{F1}", "Terminate")
HotKeySet("{`}", "TogglePause")
HotKeySet("^{1}", "DoRoll")

Global $Paused=True;
Global $Status=1;

ToolTip('Paused...',0,0)
$driftDelay = 20;
$driftLength = 600;

Func Terminate()
Exit 0
EndFunc


if winexists("BLACK DESERT - 253268") Then
    winactivate("BLACK DESERT - 253268")
EndIf

Sleep (1500)

While 1
    Sleep(2000)
WEnd


Func TogglePause()
    $Paused = NOT $Paused
	releaseKey()
    While $Paused
        sleep(100)
        ToolTip('Paused...',0,0)
    WEnd
	DoRun()
 EndFunc




Func DoRun()
   ToolTip('Runing......',0,0)
   Sleep (500)
   Send("{Q DOWN}")
   While 1
	  Send("{W}")
	  Sleep(50)
	  Send("{W}")
	  Sleep(100)
   WEnd
EndFunc


Func releaseKey()
	  Send("{Q UP}")
	  Send("{W UP}")
EndFunc

