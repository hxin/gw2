HotKeySet("{F9}", "Main")
HotKeySet("{F10}", "End")


$hwnd = WinGetHandle("Tree Of Savior")
If @Error Then
    MsgBox(0, "	gw2", "Sorry the handle could not be found.")
Else
EndIf

WinActivate($hwnd)

Global $movecounter_total=8,$movecounter,$random_min_UD=4,$random_max_UD=4,$random_min_LR=1,$random_max_LR=1


Func Main()
   $movecounter=$movecounter_total
    While 1
	  WinActivate($hwnd)

	  Send("{H down}")
	  Sleep(500)
	  Send("{H up}")
	  Sleep(1500)
      Send("{J down}")
	  Sleep(500)
	  Send("{J up}")

      $movecounter=Random($random_min_LR, $random_max_LR, 1)
	  ConsoleWrite("reset movement count to " & $movecounter & ", moveing LEFT" & @LF)
	  Send("{LEFT down}")
	  While $movecounter>0
		 $movecounter = $movecounter - 1
		 Sleep(1000)
	  WEnd

	  Send("{LEFT up}")
	  Sleep(100)
	  Send("{Z down}")
	  Sleep(15000)
	  Send("{Z up}")



      $movecounter=Random($random_min_UD, $random_max_UD, 1)
	  ConsoleWrite("reset movement count to " & $movecounter & ", moveing UP" & @LF)
	  Send("{UP down}")
	  While $movecounter>0
		 $movecounter = $movecounter - 1
		 Sleep(1000)
	  WEnd

	  Send("{UP up}")
	  Sleep(100)
	  Send("{Z down}")
Sleep(15000)
	  Send("{Z up}")



	  $movecounter=Random($random_min_LR, $random_max_LR, 1)
	  ConsoleWrite("reset movement count to " & $movecounter & ", moveing RIGHT" & @LF)
	  Send("{RIGHT down}")
	  While $movecounter>0
		 $movecounter = $movecounter - 1
		 Sleep(1000)
	  WEnd

	  Send("{RIGHT up}")
	  Sleep(100)
	  Send("{Z down}")
Sleep(15000)
	  Send("{Z up}")


      $movecounter=Random($random_min_UD, $random_max_UD, 1)
      ConsoleWrite("reset movement count to " & $movecounter & ", moveing DOWN" & @LF)
	  Send("{DOWN down}")
	  While $movecounter>0
		 $movecounter = $movecounter - 1
		 Sleep(1000)
	  WEnd

	  Send("{DOWN up}")
	  Sleep(100)
	  Send("{Z down}")
   Sleep(15000)
	  Send("{Z up}")
	  Sleep(1000)
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
   $conter=0
   $couter_buff=90
   While 1
	  Send("{Z down}")
	  While $conter<$couter_buff
		$conter = $conter + 1
		Sleep(1000)
	  WEnd
	  $conter=0
	  Send("{Z up}")
	  Sleep(1000)
	  ;Send("{H down}")
	  ;Sleep(500)
	  ;Send("{H up}")
	  Sleep(1500)
      Send("{J down}")
	  Sleep(500)
	  Send("{J up}")
	  Sleep(1000)

	  Send("{UP down}")
	  Sleep(4000)
	  Send("{UP up}")
	  Sleep(500)


	  Send("{Z down}")
	  While $conter<$couter_buff
		$conter = $conter + 1
		Sleep(1000)
	  WEnd
	  $conter=0
	  Send("{Z up}")
	  Sleep(1000)
	  ;Send("{H down}")
	  ;Sleep(500)
	  ;Send("{H up}")
	  Sleep(1500)
      Send("{J down}")
	  Sleep(500)
	  Send("{J up}")
	  Sleep(1000)

	  Send("{DOWN down}")
	  Sleep(4000)
	  Send("{DOWN up}")
	  Sleep(500)

   WEnd

EndFunc

func keepAttk_not_move()
   $conter=0
   $couter_buff1=70
   $couter_buff2=300
   While 1
	  Send("{Z down}")
	  While $conter<$couter_buff2
		$conter = $conter + 1
		Sleep(1000)
	  WEnd
	  $conter=0
	  Send("{Z up}")
	  Sleep(1000)
	  Send("{H down}")
	  Sleep(500)
	  Send("{H up}")
	  Sleep(1500)
      Send("{J down}")
	  Sleep(500)
	  Send("{J up}")
	  Sleep(1000)
   WEnd

EndFunc


func keepAttk_not_move2()
   $conter=0
   $couter_buff=400
   While 1
	  WinActivate($hwnd)
	  Send("{Z down}")
	  While $conter<$couter_buff
		$conter = $conter + 1
		Sleep(1000)
		If Mod($conter,60) = 0 Then
			Send("{Z up}")
			Sleep(1000)
			Send("{H down}")
			Sleep(500)
			Send("{H up}")
			Sleep(1500)
			Send("{Z down}")
		EndIf
	  WEnd
	  $conter=0
	  Send("{Z up}")
	  Sleep(1500)
      Send("{J down}")
	  Sleep(500)
	  Send("{J up}")
	  Sleep(1000)
   WEnd

EndFunc

;Main()
;keepAttk()
;keepAttk_bg()
;keepAttk_not_move()
keepAttk_not_move2()
;ConsoleWrite("reset movement count to " & Mod(70,70) & ", moveing DOWN" & @LF)
;while 1
	;Sleep(250)
;WEnd
