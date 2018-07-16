   HotKeySet("{F9}", "Main")
HotKeySet("{F10}", "End")


$hwnd = WinGetHandle("Tree Of Savior")
If @Error Then
    MsgBox(0, "	gw2", "Sorry the handle could not be found.")
Else
EndIf

WinActivate($hwnd)

Global $movecounter_total=8,$movecounter,$random_min_UD=8,$random_max_UD=8,$random_min_LR=17,$random_max_LR=17


Func Main()
   $movecounter=$movecounter_total
    While 1
	  WinActivate($hwnd)

	  Send("{J down}")
	  Sleep(500)
	  Send("{J up}")
	  Sleep(1000)
	  Send("{H down}")
	  Sleep(500)
	  Send("{H up}")

      $movecounter=Random($random_min_LR, $random_max_LR, 1)
	  ConsoleWrite("reset movement count to " & $movecounter & ", moveing LEFT" & @LF)
	  Send("{Z down}")
	  Send("{LEFT down}")
	  While $movecounter>0
		 pressTabWhileMoving()
		 $movecounter = $movecounter - 1
		 Sleep(1000)
	  WEnd

	  Send("{LEFT up}")
	  Send("{Z up}")
	  Sleep(1000)

	  Send("{J down}")
	  Sleep(500)
	  Send("{J up}")
	  Sleep(1000)
	  Send("{H down}")
	  Sleep(500)
	  Send("{H up}")

      $movecounter=Random($random_min_UD, $random_max_UD, 1)
	  ConsoleWrite("reset movement count to " & $movecounter & ", moveing UP" & @LF)
	  Send("{Z down}")
	  Send("{UP down}")
	  While $movecounter>0
		 pressTabWhileMoving()
		 $movecounter = $movecounter - 1
		 Sleep(1000)
	  WEnd

	  Send("{UP up}")
	  Send("{Z up}")
	  Sleep(1000)
	  Send("{J down}")
	  Sleep(500)
	  Send("{J up}")
	  Sleep(1000)
	  Send("{H down}")
	  Sleep(500)
	  Send("{H up}")

	  $movecounter=Random($random_min_LR, $random_max_LR, 1)
	  ConsoleWrite("reset movement count to " & $movecounter & ", moveing RIGHT" & @LF)
	  Send("{Z down}")
	  Send("{RIGHT down}")
	  While $movecounter>0
		 pressTabWhileMoving()
		 $movecounter = $movecounter - 1
		 Sleep(1000)
	  WEnd

	  Send("{RIGHT up}")
	  Send("{Z up}")
	  Sleep(1000)
	  Send("{J down}")
	  Sleep(500)
	  Send("{J up}")
	  Sleep(1000)
	  Send("{H down}")
	  Sleep(500)
	  Send("{H up}")

      $movecounter=Random($random_min_UD, $random_max_UD, 1)
      ConsoleWrite("reset movement count to " & $movecounter & ", moveing DOWN" & @LF)
	  Send("{Z down}")
	  Send("{DOWN down}")
	  While $movecounter>0
		 pressTabWhileMoving()
		 $movecounter = $movecounter - 1
		 Sleep(1000)
	  WEnd

	  Send("{DOWN up}")
	  Send("{Z up}")
	  Sleep(1000)

	  Sleep(5000)
    Wend
EndFunc

Func End()
	Exit 1
EndFunc


func pressTabWhileMoving()
   Send("{TAB}")
EndFunc


func keepAttk()
   ;end("{UP down}")
   Send("{Z down}")

EndFunc

func keepAttk_bg()
   ;end("{UP down}")
   ;Send("{END down}")
   Opt("SendKeyDownDelay",2)
   ControlSend($hwnd, "", "", "{END}",1)
EndFunc

;Main()
keepAttk()
;keepAttk_bg()


;while 1
	;Sleep(250)
;WEnd
