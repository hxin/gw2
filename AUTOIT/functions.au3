
;resize the target window
Func reSizeWindow($hWnd,$x=0,$y=0,$width=1401,$height=963,$useOrigin=False)
   Local $aPos = WinGetPos($hWnd)
   If $useOrigin Then
	  $width=$aPos[3]
	  $height=$aPos[4]
   EndIf
   WinMove($hWnd, "", $x, $y, $width, $height)
   Sleep(2000)
EndFunc

Func holdKey( $key="F11",$delay=50)
   Send("{"&$key&" down}")
   Sleep($delay)
   Send("{"&$key&" up}")
EndFunc

Func ControlHoldKey($handl, $key="F11",$delay=50)
   ControlSend($handl, "", $handl, "{"&$key&" down}")
   Sleep($delay)
   ControlSend($handl, "", $handl, "{"&$key&" up}")
EndFunc


;~  Send('{' & 122 & "down}")
;~  sleep(100)
;~ Send('{' & 122 & "up}")
;~ sleep(100)

Func ConsoleWriteWithTime($text,$newline=True)
   If $newline Then
	  ConsoleWrite('[' & _NowTime() & '] ' & $text & @LF)
   Else
	  ConsoleWrite('[' & _NowTime() & '] ' & $text)
   EndIf
EndFunc

Func RunGW2()
   ConsoleWriteWithTime("Checking gw2 running...")
   Local $pid = isGW2Running()
   If $pid Then
	  ProcessClose($pid)
	  killDeadProcess()
   EndIf


   Run("C:\Program Files\Guild Wars 2\Gw2.exe -32")
   Sleep(5000)
   Local $search = _ImageSearch('img/Login.bmp', 0, $x, $y, 30)
   If $search = 1 Then
	  MouseClick("left", $x,$y, 1)
	  Sleep(20000)
	  If isGW2Running() Then
		 $hWnd_gw2 = WinGetHandle("Guild Wars 2")
		 WinActivate($hWnd_gw2)
		 reSizeWindow($hWnd_gw2)
	  EndIf
   Else
	  RunGW2()
   EndIf
EndFunc


Func killDeadProcess()
   ;Run("C:\Windows\System32\taskkill.exe /F /FI 'STATUS eq NOT RESPONDING'")
   RunWait(@ComSpec & " /c " & "taskkill /F /FI 'STATUS eq NOT RESPONDING'")
EndFunc