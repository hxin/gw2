#include <AutoItConstants.au3>
HotKeySet("^{F1}", "Terminate")

Func Terminate()
Exit 0
EndFunc

if winexists("BLACK DESERT - 253268") Then
    winactivate("BLACK DESERT - 253268")
 EndIf

Sleep (500)

$i = 0
Send("{LSHIFT DOWN}")
Send("{A DOWN}")
Send("{S DOWN}")

Do
MouseClick($MOUSE_CLICK_MIDDLE)
;Send("{W DOWN}")
Sleep (30)
;Send("{W UP}")
$i = $i + 1
Until $i = 99999