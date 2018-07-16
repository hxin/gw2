#include <AutoItConstants.au3>
HotKeySet("^{F1}", "Terminate")
HotKeySet("{`}", "StopAction")
HotKeySet("!{1}", "DoRoll")
HotKeySet("!{2}", "Clicking")
HotKeySet("!{3}", "DoRun")
HotKeySet("!{4}", "DoStack")
HotKeySet("!{5}", "RunMarketplace")

Global $Paused=False;
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


Func StopAction()
	releaseKey()
	$Paused=True
    ToolTip('......',0,0)
 EndFunc

Func DoStack()
   ToolTip('Stacking......',0,0)
   $Paused=False
   Sleep (500)
   While NOT $Paused
	  MouseMove(903, 305)
	  Sleep(1000)
	  MouseClick($MOUSE_CLICK_RIGHT)
	  Sleep(1000)
	  MouseMove(971, 370)
	  Sleep(1000)
	  MouseClick($MOUSE_CLICK_LEFT)
	  Sleep(1000)
	  Send("{2}")
	  Sleep(300)
	  Send("{0}")
	  Sleep(300)
	  Send("{0}")
	  Sleep(300)
	  Send("{0}")
	  Sleep(1000)
   WEnd
EndFunc



Func DoRoll()
   ToolTip('Rolling......',0,0)
   $Paused=False
   Sleep (500)
   Send("{Q DOWN}")
   While NOT $Paused
	  Send("{W}")
	  Sleep(50)
	  Send("{W}")
	  Sleep(100)
   WEnd
EndFunc
Sleep (300)

Func Clicking()
   ToolTip('Clicking...',0,0)
   $Paused=False
   Sleep (500)
   While NOT $Paused
	  MouseClick($MOUSE_CLICK_RIGHT) ; Set the left mouse button state as down.
	  Sleep (50)
   WEnd
EndFunc

Func DoRun()
   ToolTip('Runing......',0,0)
   $Paused=False
   Sleep (1500)
   While NOT $Paused
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
	  Send("{Q UP}")
	  Send("{W UP}")
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


