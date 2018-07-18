#include-once
#include <ImageSearch.au3>
#include <functions.au3>
#include <gw2_functions.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <Array.au3>

HotKeySet("{F9}", "Main")
HotKeySet("{PAUSE}", "Wait")
HotKeySet("{F10}", "End")

$hWnd_gw2 = WinGetHandle("Guild Wars 2")
If @Error Then
    MsgBox(0, "gw2", "Sorry the handle could not be found.")
Else
EndIf

$hWnd_ce = WinGetHandle("Cheat Engine 6.8.1")
If @Error Then
    MsgBox(0, "GW2", "Sorry the handle could not be found.")
Else
EndIf


;MsgBox($MB_SYSTEMMODAL, "", $hWnd_ce)

Global $x=0,$y=0,$missing_tool,$current_gather
Global $counter=0,$max_count=800,$always_active=1
Global $gameWindowSize_x=WinGetPos($hWnd_gw2)[0],$gameWindowSize_y=WinGetPos($hWnd_gw2)[1],$gameWindowSize_right=WinGetPos($hWnd_gw2)[2],$gameWindowSize_bottom=WinGetPos($hWnd_gw2)[3]
;Global $wp_text_image = 'img/bc_deadend_wp.bmp',$wp_text="[&BAsEAAA=]"
;Global $wp_text_image = 'img/tf_talus_wp.bmp',$wp_text="[&BEQCAAA=]"
;~ Global $wp_text_image = 'img/dp_Sanctum_wp.bmp',$wp_text="[&BMUDAAA=]"
Global $wp_text_image = 'img/sd_SnowdriftHaven_wp.bmp',$wp_text="[&BLkAAAA=]"

Global $statstic_count_h=0,$statstic_count_w=0,$statstic_count_m=0
Global $statstic_count_total=0,$statstic_count_die[0],$statstic_count_changeCharacter=0
Global $is_ingame_try=10
;back2WP($wp_text_image,$wp_text)
;sayInGame($wp_text)
;_ArrayAdd($statstic_count_die, 10)
;_ArrayAdd($statstic_count_die, 20)
;_ArrayDisplay($statstic_count_die, "1D - Single")
;ConsoleWrite(_ArrayToString($statstic_count_die, ','))
;ConsoleWrite(UBound($statstic_count_die))

WinActivate($hWnd_gw2)
reSizeWindow($hWnd_gw2)

;~ while true
;~ 	consolewritewithtime(hastool())
;~ 	sleep(1000)
;~ wend
Wait()


Func Main()
    While 1
	  ;If $always_active == 1 Then
		 WinActivate($hWnd_gw2)
	  ;EndIf

	  ;;choose character when in CharacterSelect
;~ 	  While isInCharacterSelect()
;~ 		 chooseCharacter()
;~ 		 while NOT isIngame()
;~ 			sleep(1000)
;~ 		 WEnd
;~ 		 back2WP($wp_text_image,$wp_text)
;~ 		 sortBag()
;~ 		 ;;reset counter
;~ 		 $counter = 0
;~ 		 ;reset CE counter
;~ 		 holdKey("RSHIFT",100)
;~ 	  WEnd

;~ 	  While isDead()
;~ 		 _ArrayAdd($statstic_count_die, $counter)
;~ 		 ConsoleWriteWithTime("You are dead!!!")
;~ 		 back2WP($wp_text_image,$wp_text)
;~ 		 $counter = $max_count
;~ 	  WEnd

	  $counter = $counter + 1
	  $statstic_count_total = $statstic_count_total + 1
	  if $counter > $max_count Then
		 toSavePlace()
;~ 		 back2WP($wp_text_image,$wp_text)
		 ;sort bag
		 sortBag()
		 ;;exit and change chatacter
;~ 		 exitToCharacterSelect()
		 ;;reset counter
		 $counter = 0
		 ;reset CE counter
;~ 		 holdKey("RSHIFT",100)
		 $statstic_count_changeCharacter = $statstic_count_changeCharacter + 1
	  EndIf

	  ;;teleport
	  IF isIngame() Then
		 Send("{F7}")
		 Sleep(10)
		 ;;step back to refresh
		 ControlHoldKey($hWnd_gw2,"s",50)
		 Sleep(100)
	  EndIf
	  sleep(500)
	  ;ConsoleWriteWithTime(canGather())
	  While canGather()
		 ;;gather
		 ControlSend($hWnd_gw2, "", $hWnd_gw2, "{F}")
		 Sleep(4800)
		 If NOT hasTool() Then
			equTool()
		 EndIf
	  WEnd

	  ;;wait for possible mapload
	  IF NOT isIngame() Then
		 ConsoleWrite("waiting for ingame flag..."& @LF)
		 sleep(10000)
		 $is_ingame_try = $is_ingame_try - 1
		 If $is_ingame_try < 0 Then
			RunGW2()
		 EndIf
	  Else
		 $is_ingame_try=10
	  EndIf
    Wend
EndFunc

Func End()
	Exit 1
EndFunc

Func Wait()
 While 1
   Sleep(2000)
   ConsoleWriteWithTime("Total die: " & UBound($statstic_count_die))
   ConsoleWriteWithTime("Die at counters: " & _ArrayToString($statstic_count_die, ','))
 WEnd
EndFunc













