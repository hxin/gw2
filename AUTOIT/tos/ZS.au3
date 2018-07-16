HotKeySet("{F9}", "Main")
HotKeySet("{F10}", "End")


$hwnd = WinGetHandle("Tree Of Savior")
If @Error Then
    MsgBox(0, "	gw2", "Sorry the handle could not be found.")
Else
EndIf

WinActivate($hwnd)

Global $movecounter_total=5,$movecounter


Func Main()
   $movecounter=$movecounter_total
    While 1
	  WinActivate($hwnd)
	  Send("{Z down}")
	  While $movecounter>0
		 pressTabWhileMoving()
		 $movecounter = $movecounter - 1
	  WEnd
	  $movecounter=$movecounter_total

	  Send("{Z up}")
	  Sleep(1000)
	  ;ConsoleWrite("change direction...  " & @LF)
	  ;Send("{H}")
	  ;Sleep(1000)
	  ConsoleWrite("Buff...  " )
	  Send("{S}")
	  Sleep(500)
	  Send("{D}")
	  Sleep(500)
	  ConsoleWrite("end  " & @LF)

	  Send("{Z down}")


	  While $movecounter>0
		 pressTabWhileMoving()
		 $movecounter = $movecounter - 1
	  WEnd
	  $movecounter=$movecounter_total


	  Send("{Z up}")
	  Sleep(1000)
	  ;Send("{H}")
	  ;Sleep(1000)
	  ConsoleWrite("Buff...  " )
	  Send("{S}")
	  Sleep(500)
	  Send("{D}")
	  Sleep(500)
	  ConsoleWrite("end  " & @LF)
    Wend
EndFunc

Func End()
	Exit 1
EndFunc


func pressTabWhileMoving()
   Send("{TAB}")
   Sleep(4000)
EndFunc


func keepAttk()
   ;Send("{UP down}")
   Send("{Z down}")
EndFunc

Main()
;keepAttk()



;while 1
	;Sleep(250)
;WEnd
