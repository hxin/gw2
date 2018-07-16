   #include <AutoItConstants.au3>

if winexists("BLACK DESERT - 253268") Then
    winactivate("BLACK DESERT - 253268")
 EndIf

Sleep (1000)

HotKeySet("^{F1}", "_terminate")

Func _terminate()
	Exit (0)
EndFunc   ;==>_terminate

   $secondsToHoldKey = 99999 ;change this if you want
   $KeyToPress = "LSHIFT" ;also change this if you want

   Send ("{"&$KeyToPress&" DOWN}")
   MouseDown($MOUSE_CLICK_RIGHT ) ; Set the left mouse button state as down.
   Sleep ($secondsToHoldKey*1000)
   MouseUp($MOUSE_CLICK_RIGHT ) ; Set the left mouse button state as up.
   Send ("{"&$KeyToPress&" UP}")