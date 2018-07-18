Func isGW2Running()
   Local $pid = ProcessExists("Gw2.exe")
   Return $pid
EndFunc


Func isDead()
   ;ConsoleWriteWithTime("Checking isDead...",False)
   Local $search = _ImageSearchInGame('img/die.bmp',0,$x,$y,30)
   If $search = 1 Then
	  ;ConsoleWriteWithTime("Yes")
	  Return True
   Else
	  ;ConsoleWriteWithTime("No")
	  Return False
   EndIf
EndFunc

Func isIngame()
   Return True
   Sleep(100)
   Local $search = _ImageSearchInGame('img/ingameflag.bmp', 0, $x, $y, 30)
   If $search = 1 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func isInSquad()


EndFunc

Func isGathering()
   Local $pc = PixelGetColor ( 611,726,$hWnd_gw2)
   If $pc = 11889930 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func isInCharacterSelect()
   ;ConsoleWriteWithTime("Checking isInCharacterSelect...",False)
   Local $search = _ImageSearchInGame('img/CharacterSelectDCFlag.bmp', 1, $x, $y, 50)
    If $search = 1 Then
	  ConsoleWriteWithTime("You are DC!!")
	  WinActivate($hWnd_gw2)
	  MouseClick("left", $x,$y, 1)
   EndIf

   Local $search = _ImageSearchInGame('img/CharacterSelectFlag.bmp', 0, $x, $y, 30)
   If $search = 1 Then
	  ;ConsoleWriteWithTime("Yes")
	  Return True
   Else
	  ;ConsoleWriteWithTime("No")
	  Return False
   EndIf
EndFunc

Func canGather()
   Local $images[4] = [3,"img/wood.bmp", "img/mine.bmp", "img/herb.bmp"]
   ;ConsoleWriteWithTime("Checking canGather...",False)
   Local $search = _WaitForImagesSearch($images,1,0,$x, $y,75)
   If $search = 0 Then
	  ;ConsoleWriteWithTime("No")
	  Return False
   Else
	  Switch $search
		 Case 1
			  $statstic_count_w = $statstic_count_w +1
			  $current_gather='w'
		 Case 2
			  $statstic_count_m = $statstic_count_m +1
			  $current_gather='m'
		 Case 3
			  $statstic_count_h = $statstic_count_h +1
			  $current_gather='h'
	  EndSwitch
	  ConsoleWriteWithTime("Found " & $images[$search]  & "  w:" & $statstic_count_w & " m:" & $statstic_count_m & " h:" & $statstic_count_h & " total:" & $statstic_count_m+$statstic_count_h+$statstic_count_w & " counter:" & $counter &  " Totalcounter:" & $statstic_count_total)
	  Return $search
   EndIf
EndFunc

Func hasTool()
   ;ConsoleWriteWithTime("Checking hasTool...",False)
   Local $search = _ImageSearchInGame('img/notool.bmp', 0, $x, $y, 100)
   If $search = 0 Then
	  ;ConsoleWriteWithTime("Yes")
	  Return True
   EndIf
   ;ConsoleWriteWithTime("No")
   $missing_tool = $current_gather
   Return False
EndFunc

Func chooseCharacter()
   ConsoleWriteWithTime("Selecting Character...",False)
   Local $x=848,$y=862
   ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",1,$x,$y)
   Sleep(500)
   ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",2,$x,$y)
   Sleep(10000)
   ConsoleWriteWithTime("Done")
EndFunc

Func toSavePlace()
    ;;to save place
   ConsoleWriteWithTime("Travelling to save place...",False)
   Send("{F12}")
   Sleep(10)
   Send("{F12}")
   Sleep(10)
   Send("{F12}")
   Sleep(10)
   Send("{F12}")
   Sleep(10)
   Send("{F12}")
   Sleep(10)
   Send("{F12}")
   Sleep(10)
   ControlHoldKey($hWnd_gw2,"SPACE",50)
   ConsoleWriteWithTime("Done")
   Sleep(8000)
EndFunc

Func sayInGame($str)
   ;ConsoleWriteWithTime("Saying in game chat...",False)
   ControlSend($hWnd_gw2, "", $hWnd_gw2, "{ENTER}")
   Sleep(500)
   ControlSend($hWnd_gw2, "", $hWnd_gw2, $str,1)
   Sleep(500)
   ControlSend($hWnd_gw2, "", $hWnd_gw2, "{ENTER}")
   Sleep(500)
   ;ConsoleWriteWithTime("Done")
EndFunc

Func equTool()
;~    toSavePlace()
   ConsoleWriteWithTime("Use tool [" & $missing_tool & ']...',False)
   ControlSend($hWnd_gw2, "", $hWnd_gw2, "{i}")
   Sleep(1000)

   Switch $missing_tool
		 Case 'm'
			   Local $search = _ImageSearchInGame('img/tool_mine.bmp', 1, $x, $y, 80)
			   If $search = 1 Then
				  ;ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",2,$x,$y)
				  ConsoleWriteWithTime("mine...",False)
				  MouseClick("left", $x,$y, 2)
				  Sleep(1000)
			   EndIf
			Case 'h'
			   Local $search = _ImageSearchInGame('img/tool_herb.bmp', 1, $x, $y, 80)
			   If $search = 1 Then
				  ;ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",2,$x,$y)
				  ConsoleWriteWithTime("herb...",False)
				  MouseClick("left", $x,$y, 2)
				  Sleep(1000)
			   EndIf
		 Case 'w'
			Local $search = _ImageSearchInGame('img/tool_wood.bmp', 1, $x, $y, 80)
			If $search = 1 Then
			   ;ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",2,$x,$y)
			   ConsoleWriteWithTime("wood...Done")
			   MouseClick("left", $x,$y, 2)
			   Sleep(1000)
			EndIf
   EndSwitch


;~    Local $search = _ImageSearchInGame('img/tool_mine.bmp', 1, $x, $y, 80)
;~    If $search = 1 Then
;~ 	  ;ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",2,$x,$y)
;~ 	  ConsoleWriteWithTime("mine...",False)
;~ 	  MouseClick("left", $x,$y, 2)
;~ 	  Sleep(1000)
;~    EndIf

;~    Local $search = _ImageSearchInGame('img/tool_herb.bmp', 1, $x, $y, 80)
;~    If $search = 1 Then
;~ 	  ;ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",2,$x,$y)
;~ 	  ConsoleWriteWithTime("herb...",False)
;~ 	  MouseClick("left", $x,$y, 2)
;~ 	  Sleep(1000)
;~    EndIf

;~    Local $search = _ImageSearchInGame('img/tool_wood.bmp', 1, $x, $y, 80)
;~    If $search = 1 Then
;~ 	  ;ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",2,$x,$y)
;~ 	  ConsoleWriteWithTime("wood...Done")
;~ 	  MouseClick("left", $x,$y, 2)
;~ 	  Sleep(1000)
;~    EndIf

   Sleep(1000)
   ControlSend($hWnd_gw2, "", "", "{i}")
   Sleep(500)

   sayInGame("/age")
   sayInGame("/age")
   sayInGame("/age")

EndFunc

Func sortBag()
   ConsoleWriteWithTime("Sorting bag...",False)
   ControlSend($hWnd_gw2, "", $hWnd_gw2, "{i}")
   Sleep(500)
   MouseClick("left",1100,201,1)
   Sleep(500)
   MouseClick("left",1167,225,1)
   Sleep(500)
   MouseClick("left",1168,249,3)
   Sleep(500)
   ControlSend($hWnd_gw2, "", $hWnd_gw2, "{i}")
   ConsoleWriteWithTime("Done")
EndFunc

Func exitToCharacterSelect()
   ConsoleWriteWithTime("Exit game...",False)
   ;ConsoleWrite("Changing character  "& @LF)
   MouseClick("left",20,44,1)
   sleep(1000)
   MouseClick("left",728,544,1)
   sleep(1000)
   MouseClick("left",669,553,1)
   sleep(1000)
   ConsoleWriteWithTime("Done")
EndFunc

func back2WP($wp_text_image,$wp_text,$try=1,$max_try=20)
   ;https://wiki.guildwars2.com/wiki/Chat_link_format/0x04_codes/Kryta
   ;https://wiki.guildwars2.com/wiki/User:TEF/Guides/Map_Codes_(completion)
   toSavePlace()
   ConsoleWriteWithTime("Back to wp...")
   Sleep(1000)
   sayInGame($wp_text)
   Sleep(1000)
   Local $search = _ImageSearchInGame($wp_text_image,1, $x, $y, 50)
   If $search = 1 Then
	  ;ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",1,$x,$y)
	  ConsoleWriteWithTime("Found wp",False)
	  MouseClick("left",$x,$y,1)
	  Sleep(1000)
	  ;ControlClick($hWnd_gw2,"",$hWnd_gw2,"left",2,703,497)
	  MouseClick("left",703,497,2)
	  Sleep(5000)
	  return True
   Else
	  ConsoleWriteWithTime("Cannot find wp, retry...",False)
	  $try = $try + 1
	  if $try < $max_try Then
		 back2WP($wp_text_image,$wp_text,$try)
	  EndIf
	  return False
   EndIf
   return False
EndFunc