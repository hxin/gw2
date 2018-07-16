#include <AutoItConstants.au3>
HotKeySet("^{F4}", "Terminate")
HotKeySet("{F5}", "TogglePause")

Global $Paused=True;

ToolTip('Paused...',0,0)
$driftDelay = 20;
$driftLength = 600;

Func Terminate()
Exit 0
EndFunc


if winexists("Guild Wars 2") Then
    winactivate("Guild Wars 2")
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
   Sleep (1500)
   While 1
	  Send("{S DOWN}")
	  Send("{A DOWN}")
	  Sleep (50)
	  Send("{S UP}")
	  Send("{A UP}")
	  Sleep ($driftDelay)
	  Send("{W DOWN}")
	  Send("{F DOWN}")
	  Sleep (500)
	  Send("{W UP}")
	  Send("{F UP}")
	  Sleep ($driftLength)
	  Send("{S DOWN}")
	  Send("{D DOWN}")
	  Sleep (50)
	  Send("{S UP}")
	  Send("{D UP}")
	  Sleep ($driftDelay)
	  Send("{W DOWN}")
	  Send("{F DOWN}")
	  Sleep (500)
	  Send("{W UP}")
	  Send("{F UP}")
	  Sleep ($driftLength)
   WEnd
EndFunc


Func releaseKey()
	  Send("{S UP}")
	  Send("{A UP}")
	  Send("{F UP}")
	  Send("{W UP}")
	  Send("{D UP}")
	  Sleep(50)
	   Send("{S UP}")
	  Send("{A UP}")
	  Send("{F UP}")
	  Send("{W UP}")
	  Send("{D UP}")
EndFunc

