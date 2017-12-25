#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <AutoItConstants.au3>
#include <WinAPI.au3>

$WarThunderAutoclicker = GUICreate("WarThunderAutoclicker", 121, 152, -1, -1)
$fighterCheckbox = GUICtrlCreateCheckbox("Fighter Plane", 16, 16, 97, 17)
$attackCheckbox = GUICtrlCreateCheckbox("Attack Plane", 16, 40, 97, 17)
$bomberCheckox = GUICtrlCreateCheckbox("Bomber Plane", 16, 64, 97, 17)
$statusLabel = GUICtrlCreateLabel("Disabled", 16, 88, 83, 17)
$toggleButton = GUICtrlCreateButton("START", 16, 112, 83, 25)

GUISetState(@SW_SHOW)
GUICtrlSetColor($statusLabel, $COLOR_RED)

Local $isFighterSelected, $isAttackSelected, $isBomberSelected

Local $isClickerActive = False
Local $statusLabelCaption
Local $togglButtonCaption

Const $CLICKER_INTERVAL = 250
Local $timer = TimerInit()

Local $module, $hook, $stubKeyProc

$stubKeyProc = DllCallbackRegister("KeyProc", "long", "int;wparam;lparam")
$module = _WinAPI_GetModuleHandle(0)
$hook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($stubKeyProc), $module)

While 1
  $nMsg = GUIGetMsg()
  Switch $nMsg
    Case $GUI_EVENT_CLOSE
      Exit
    Case $toggleButton
	  ToggleClicker()
	  CheckCheckboxes()

	  GUICtrlSetData($statusLabel, $isClickerActive ? "Active" : "Disabled")
	  GUICtrlSetData($toggleButton, $isClickerActive ? "STOP" : "START")
	  GUICtrlSetColor($statusLabel,  $isClickerActive ? $COLOR_GREEN : $COLOR_RED)
   Case $fighterCheckbox
	  ContinueCase
   Case $attackCheckbox
	  ContinueCase
   Case $bomberCheckox
	  CheckCheckboxes()
  EndSwitch

   If $isClickerActive And TimerDiff($timer) > $CLICKER_INTERVAL Then
	  If $isBomberSelected Then
		 Send("9", $SEND_RAW)
	  EndIf

	  If $isAttackSelected Then
		 Send("8", $SEND_RAW)
	  EndIf

	  If $isFighterSelected Then
		 Send("7", $SEND_RAW)
	  EndIf

	  $timer = TimerInit()
   EndIf

WEnd

Func ToggleClicker()
   $isClickerActive = Not $isClickerActive
   Beep(500, 250)
EndFunc

Func CheckCheckboxes()
   $isFighterSelected = GUICtrlRead($fighterCheckbox) == 1
   $isAttackSelected = GUICtrlRead($attackCheckbox) == 1
   $isBomberSelected = GUICtrlRead($bomberCheckox) == 1
EndFunc

Func KeyProc($code, $wParam, $lParam)
   If $code < 0 Then
	  Return _WinAPI_CallNextHookEx($hook, $code, $wParam, $lParam)
   EndIf

   $keyHooks = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)

   If $wParam = $WM_KEYDOWN And DllStructGetData($keyHooks, "vkCode") == 123 Then
		ToggleClicker()
   EndIf
EndFunc
