HotKeySet("{F9}", "Main")
HotKeySet("{F10}", "End")


$hwnd = WinGetHandle("Guild Wars 2")
If @Error Then
    MsgBox(0, "gw2", "Sorry the handle could not be found.")
Else
EndIf

$hwnd_ce = WinGetHandle("UDF1")
If @Error Then
    MsgBox(0, "UDF1", "Sorry the handle could not be found.")
Else
EndIf

Global $x,$y,$counter=0,$max_count=1110,$checkDieFreq=4


;HotKeySet("p", "checkForImage")

func backtoCS()
   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)
   ControlSend($hwnd, "", "", "[&BAsEAAA=]")
   Sleep(300)
   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)
   Local $search = _ImageSearch('cswp.bmp', 0, $x, $y, 50)
   If $search = 1 Then
	  MouseClick("left",$x,$y,1)
	  Sleep(1000)
	  MouseClick("left",703,497,2)
	  Sleep(2000)
   EndIf
   While checkIngame() = False
	  ConsoleWrite("waiting for ingame flag..."& @LF)
	  sleep(4000)
   WEnd
EndFunc

func backtoBC()
   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)
   ControlSend($hwnd, "", "", "[&BCkAAAA=]")
   Sleep(300)
   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)
   Local $search = _ImageSearch('bc_deadend_wp.bmp', 0, $x, $y, 50)
   If $search = 1 Then
	  MouseClick("left",$x,$y,1)
	  Sleep(1000)
	  MouseClick("left",703,497,2)
	  Sleep(2000)
   Else
	  backtoBC()
   EndIf
   While checkIngame() = False
	  ConsoleWrite("waiting for ingame flag..."& @LF)
	  sleep(4000)
   WEnd
EndFunc

Func checkForImage()
   Sleep(150)
   Local $search = _ImageSearch('1.bmp', 0, $x, $y, 50)
   If $search = 1 Then
	  ;MouseMove($x, $y, 10)
	  Return True
   EndIf

   $search = _ImageSearch('2.bmp', 0, $x, $y, 50)
   If $search = 1 Then
	  ;MouseMove($x, $y, 10)
	  Return True
   EndIf

   $search = _ImageSearch('3.bmp', 0, $x, $y, 50)
   If $search = 1 Then
	  ;MouseMove($x, $y, 10)
	  Return True
   EndIf

   Return False
EndFunc

Func checkDie()
   Local $search = _ImageSearch('die.bmp', 0, $x, $y, 30)
   If $search = 1 Then
	  $counter = $max_count
	  Return True
   EndIf
;~    If $search = 1 Then
;~ 	  ConsoleWrite("You are dead!" & @LF)
;~ 	  ;MouseMove($x+20, $y+80, 10)
;~ 	  WinActivate($hwnd)
;~ 	  MouseClick("left", $x,$y, 1)
;~ 	  Sleep(3000)
;~ 	  $search = _ImageSearch('wponmap.bmp', 0, $x, $y, 50)
;~ 	  If $search = 1 Then
;~ 		 ConsoleWrite("Found wp for revive" & @LF)
;~ 		 WinActivate($hwnd)
;~ 		 MouseClick("left", $x,$y, 2)
;~ 		 Sleep(5000)
;~ 	  else
;~ 		 ConsoleWrite("cannot found wp for revive, setting ce counter to max and will go back to CS soon." & @LF)
;~ 		 ControlSend($hwnd, "", "", "{ESC}")
;~ 		 $counter = $max_count
;~ 	  EndIf
;~ 	  Return True
;~    EndIf
EndFunc

Func checkIngame()
   Local $search = _ImageSearch('ingameflag.bmp', 0, $x, $y, 30)
   If $search = 1 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func checkNotool()
   Local $search = _ImageSearch('notool.bmp', 0, $x, $y, 10)
   If $search = 1 Then
	  ;MouseMove($x, $y, 10)
	  Return True
   EndIf
   Return False
EndFunc

Func equtool()
   ConsoleWrite("Looking for tool!"& @LF)
   ControlSend($hwnd, "", "", "{i}")
   Sleep(2000)
   Local $search = _ImageSearch('m.bmp', 0, $x, $y, 80)
   If $search = 1 Then
	  WinActivate($hwnd)
	  Sleep(1000)
	  ;MouseMove($x+5, $y+5, 10)
	  MouseClick("left", $x+5,$y+5, 2)
   EndIf

   Local $search = _ImageSearch('h.bmp', 0, $x, $y, 80)
   If $search = 1 Then
	  WinActivate($hwnd)
	  Sleep(1000)
	  ;MouseMove($x, $y, 10)
	  MouseClick("left", $x+5,$y+5, 2)
   EndIf

   Local $search = _ImageSearch('w.bmp', 0, $x, $y, 80)
   If $search = 1 Then
	  WinActivate($hwnd)
	  Sleep(1000)
	  ;MouseMove($x, $y, 10)
	  MouseClick("left", $x+5,$y+5, 2)
   EndIf
   Sleep(1000)
   ControlSend($hwnd, "", "", "{i}")
   Sleep(500)

   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)
   ControlSend($hwnd, "", "", "/age")
   Sleep(300)
   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)

   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)
   ControlSend($hwnd, "", "", "/age")
   Sleep(300)
   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)


   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)
   ControlSend($hwnd, "", "", "/age")
   Sleep(300)
   ControlSend($hwnd, "", "", "{ENTER}")
   Sleep(300)


EndFunc


Func Main()
    While 1
	  if Mod($counter,$checkDieFreq)==0 Then
		 checkDie()
	  EndIf
	  Send("{F11}")
	  Sleep(100)
	  ControlSend($hwnd, "", "", "{S down}")
	  Sleep(100)
	  ControlSend($hwnd, "", "", "{S up}")
	  Sleep(400)

	  if $max_count > 1 then
		 $counter = $counter + 1
	  EndIf
	  if $counter > $max_count Then
		 ;change character
		 ConsoleWrite("Need change character  ")
		 Send("{F12 down}")
		 Sleep(100)
		 Send("{F12 up}")
		 Sleep(100)
		 ConsoleWrite("press f12 once  ")
		 Send("{F12 down}")
		 Sleep(100)
		 Send("{F12 up}")
		 Sleep(100)
		 ConsoleWrite("press f12 twice  ")
		 Send("{SPACE}")
		 Sleep(2000)
		 ConsoleWrite("Going back to CS"& @LF)
		 backtoBC()
		 ;sort bag
		 ConsoleWrite("Sorting bag  ")
		 ControlSend($hwnd, "", "", "{I}")
		 Sleep(500)
		 MouseClick("left",1100,201,1)
		 Sleep(500)
		 MouseClick("left",1167,225,1)
		 Sleep(500)
		 MouseClick("left",1168,249,3)
		 Sleep(500)
		 ;;exit and change chatacter
		 ConsoleWrite("Changing character  "& @LF)
		 MouseClick("left",20,44,1)
		 sleep(1000)
		 MouseClick("left",728,544,1)
		 sleep(1000)
		 MouseClick("left",669,553,1)
		 sleep(1000)
		 MouseClick("left",801,866,2)
		 sleep(3000)
		 $counter = 0
		 ;reset CE counter
		 ConsoleWrite("Reset ce counter  "& @LF)
		 Send("{RSHIFT down}")
		 Sleep(100)
		 Send("{RSHIFT up}")
		 Sleep(100)
	  EndIf

	  While checkIngame() = False
		 ConsoleWrite("waiting for ingame flag..."& @LF)
		 sleep(8000)
	  WEnd

	  While checkForImage() = True
		 ControlSend($hwnd, "", "", "{F}")
		 Sleep(3500)
		 Local $notool = checkNotool()
		 Sleep(100)
		 If $notool = true Then
			ConsoleWrite("No Tool,need equ!  " )
			Send("{F12 down}")
			Sleep(100)
			Send("{F12 up}")
			Sleep(100)
			ConsoleWrite("press f12 once  ")
			Send("{F12 down}")
			Sleep(100)
			Send("{F12 up}")
			Sleep(100)
			ConsoleWrite("press f12 twice  "& @LF)
			Send("{SPACE}")
			Sleep(2000)
			equtool()
		 EndIf
	  WEnd
    Wend
EndFunc

Func End()
	Exit 1
EndFunc


while 1
	Sleep(250)
WEnd




#include-once
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with Image Search
;                 Require that the ImageSearchDLL.dll be loadable
;
; ------------------------------------------------------------------------------

;===============================================================================
;
; Description:      Find the position of an image on the desktop
; Syntax:           _ImageSearchArea, _ImageSearch
; Parameter(s):
;                   $findImage - the image to locate on the desktop
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
;
; Note: Use _ImageSearch to search the entire desktop, _ImageSearchArea to specify
;       a desktop region to search
;
;===============================================================================
Func _ImageSearch($findImage,$resultPosition,ByRef $x, ByRef $y,$tolerance)
   ;return _ImageSearchArea($findImage,$resultPosition,0,0,@DesktopWidth,@DesktopHeight,$x,$y,$tolerance)
   return _ImageSearchArea($findImage,$resultPosition,0,0,1400,960,$x,$y,$tolerance)
EndFunc

Func _ImageSearchArea($findImage,$resultPosition,$x1,$y1,$right,$bottom,ByRef $x, ByRef $y, $tolerance)
    ;MsgBox(0,"asd","" & $x1 & " " & $y1 & " " & $right & " " & $bottom)
    if $tolerance>0 then $findImage = "*" & $tolerance & " " & $findImage
    $result = DllCall("ImageSearchDLL.dll","str","ImageSearch","int",$x1,"int",$y1,"int",$right,"int",$bottom,"str",$findImage)

    ; If error exit
    if $result[0]="0" then return 0

    ; Otherwise get the x,y location of the match and the size of the image to
    ; compute the centre of search
    $array = StringSplit($result[0],"|")

   $x=Int(Number($array[2]))
   $y=Int(Number($array[3]))
   if $resultPosition=1 then
      $x=$x + Int(Number($array[4])/2)
      $y=$y + Int(Number($array[5])/2)
   endif
   return 1
EndFunc

;===============================================================================
;
; Description:      Wait for a specified number of seconds for an image to appear
;
; Syntax:           _WaitForImageSearch, _WaitForImagesSearch
; Parameter(s):
;                   $waitSecs  - seconds to try and find the image
;                   $findImage - the image to locate on the desktop
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0
;
;
;===============================================================================
Func _WaitForImageSearch($findImage,$waitSecs,$resultPosition,ByRef $x, ByRef $y,$tolerance)
    $waitSecs = $waitSecs * 1000
    $startTime=TimerInit()
    While TimerDiff($startTime) < $waitSecs
        sleep(100)
        $result=_ImageSearch($findImage,$resultPosition,$x, $y,$tolerance)
        if $result > 0 Then
            return 1
        EndIf
    WEnd
    return 0
EndFunc

;===============================================================================
;
; Description:      Wait for a specified number of seconds for any of a set of
;                   images to appear
;
; Syntax:           _WaitForImagesSearch
; Parameter(s):
;                   $waitSecs  - seconds to try and find the image
;                   $findImage - the ARRAY of images to locate on the desktop
;                              - ARRAY[0] is set to the number of images to loop through
;                                ARRAY[1] is the first image
;                   $tolerance - 0 for no tolerance (0-255). Needed when colors of
;                                image differ from desktop. e.g GIF
;                   $resultPosition - Set where the returned x,y location of the image is.
;                                     1 for centre of image, 0 for top left of image
;                   $x $y - Return the x and y location of the image
;
; Return Value(s):  On Success - Returns the index of the successful find
;                   On Failure - Returns 0
;
;
;===============================================================================
Func _WaitForImagesSearch($findImage,$waitSecs,$resultPosition,ByRef $x, ByRef $y,$tolerance)
    $waitSecs = $waitSecs * 1000
    $startTime=TimerInit()
    While TimerDiff($startTime) < $waitSecs
        for $i = 1 to $findImage[0]
            sleep(100)
            $result=_ImageSearch($findImage[$i],$resultPosition,$x, $y,$tolerance)
            if $result > 0 Then
                return $i
            EndIf
        Next
    WEnd
    return 0
EndFunc