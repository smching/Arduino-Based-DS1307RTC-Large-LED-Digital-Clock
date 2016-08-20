#comments-start
	By SM.Ching (http://ediy.com.my)
	Release Date: 03rd AuG 2016
#comments-end

#include <Form.au3>
#include <GuiComboBox.au3>
#include <Serial.au3>
#include <Date.au3>

Local $Command = ""
Local $Previous_focused_control = ""
;ControlFocus("", "", $Cb_mode) ;set focus
HotKeySet("{F2}", "Serial_send")
HotKeySet("{F3}", "Serial_read")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Cb_mode
			Set_displayMode()
		Case $Cb_brightness
			Set_brightness()
		Case $Ed_systemDate
			Set_systemDate()
		Case $Ed_systemTime
			Set_systemTime()
		Case $Ed_alarmTime
			Set_alarmTime()
		Case $Cb_alarmEnable
			Set_alarmEnable()
		Case $Bt_send
			Serial_send()
		Case $Bt_read
			Serial_read()
	EndSwitch

	if Focus_change() Then
		Switch ControlGetFocus("") ;switch current control name
			Case "Edit3"
				Set_displayMode()
			Case "Edit4"
				Set_brightness()
			Case "SysDateTimePick321"
				Set_systemDate()
			Case "SysDateTimePick322"
				Set_systemTime()
			Case "SysDateTimePick323"
				Set_alarmTime()
			Case "Edit5"
				Set_alarmEnable()
		EndSwitch
	EndIf
WEnd


Func Focused_Value()
	Local $focused_control = ControlGetFocus("") ;get current control name
	Return ControlGetText("", "", $focused_control)
EndFunc   ;==>Focused_Value


Func Focus_change()
	Local $focused_control = ControlGetFocus("") ;get current control name
	if $Previous_focused_control <> $focused_control Then
		$Previous_focused_control = $focused_control
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>Focus_change


Func Set_displayMode()
	$Command = "M" & _GUICtrlComboBox_GetCurSel($Cb_mode) ;retrieve current selected index
	GUICtrlSetData($In_command, $Command) ;write a value ($Command) to $In_command control
EndFunc   ;==>Set_displayMode


Func Set_brightness()
	$Command = "B" & GUICtrlRead($Cb_brightness) ;retrieve current selected value
	GUICtrlSetData($In_command, $Command) ;write a value ($Command) to $In_command control
EndFunc   ;==>Set_brightness


Func Set_systemDate()
	$Command = GUICtrlRead($Ed_systemDate)
	$Command = "D" & StringMid($Command, 3, 2) & StringMid($Command, 6, 2) & StringRight($Command, 2)
	GUICtrlSetData($In_command, $Command) ;write a value ($Command) to $In_command control
EndFunc   ;==>Set_systemDate


Func Set_systemTime()
	$Command = GUICtrlRead($Ed_systemTime)
	$Command = "T" & StringLeft($Command, 2) & StringMid($Command, 4, 2) & StringRight($Command, 2)
	GUICtrlSetData($In_command, $Command) ;write a value ($Command) to $In_command control
EndFunc   ;==>Set_systemTime


Func Set_alarmTime()
	$Command = GUICtrlRead($Ed_alarmTime)
	$Command = "A" & StringLeft($Command, 2) & StringMid($Command, 4, 2) & StringRight($Command, 2)
	GUICtrlSetData($In_command, $Command) ;write a value ($Command) to $In_command control
EndFunc   ;==>Set_alarmTime


Func Set_alarmEnable()
	$Command = "E0" & _GUICtrlComboBox_GetCurSel($Cb_alarmEnable) ;eg. E00 = disable Alarm0, E01 enable Alarm0
	GUICtrlSetData($In_command, $Command) ;write a value ($Command) to $In_command control
EndFunc   ;==>Set_alarmEnable


Func Serial_setPort()
	$iPort = Int(GUICtrlRead($In_port)) ;get value from $In_port control
	$iBaud = Int(GUICtrlRead($cb_baudRate)) ;get value from $cb_baudRate control
EndFunc   ;==>Serial_loadSettings


Func Serial_send()
	Local $command_length = StringLen($Command)

	if $command_length = 0 Then
		MsgBox($MB_SYSTEMMODAL, "Error", "Command string must not be null", 10)
	 Else
		Message_on_statusBar("Wait...")
		Serial_setPort()
		Local $sResult = Serial_transmit($Command, 1)
		if @error Then
			Serial_errorMessage(@error, @extended, $sResult)
		Else
			Message_on_statusBar($sResult)
		EndIf
	EndIf
EndFunc   ;==>Serial_send


Func Serial_read()
	$Command = "G"
	GUICtrlSetData($In_command, $Command) ;write a value ("G") to $In_command control
	Message_on_statusBar("Wait...")
	Serial_setPort()
	Local $sResult = Serial_transmit($Command, 1)
	;Local $sResult = Serial_receive()
	if @error Then
		Serial_errorMessage(@error, @extended, $sResult)
	 Else
		Message_on_statusBar($sResult)
	    Local $info = StringSplit($sResult, ",")
		Switch $info[1]
		Case 0
			GUICtrlSetData($Cb_mode, "Font Normal")
		Case 1
			GUICtrlSetData($Cb_mode, "Font 3x5")
		Case 2
			GUICtrlSetData($Cb_mode, "Font Large")
		 EndSwitch

		GUICtrlSetData($Cb_brightness, $info[2])

	    Local $str_dateTime = StringLeft($info[3], 2) & ":" & StringMid($info[3], 3, 2) & ":" & StringRight($info[3], 2)
		GUICtrlSetData($Ed_systemDate, $str_dateTime & " 00:00:00")

	    $str_dateTime = StringLeft($info[4], 2) & ":" & StringMid($info[4], 3, 2) & ":" & StringRight($info[4], 2)
		GUICtrlSetData($Ed_systemTime, "2010-01-01 " & $str_dateTime)

		$str_dateTime = StringLeft($info[5], 2) & ":" & StringMid($info[5], 3, 2) & ":" & StringRight($info[5], 2)
		GUICtrlSetData($Ed_alarmTime, "2010-01-01 " & $str_dateTime)

		Switch $info[6]
		Case 0
		GUICtrlSetData($Cb_alarmEnable, "No")
				Case 1
		GUICtrlSetData($Cb_alarmEnable, "Yes")
		EndSwitch
	EndIf
 EndFunc   ;==>Serial_read


 Func Message_on_statusBar($str)
		 _GUICtrlStatusBar_SetText($StatusBar1,  @TAB & _NowTime() & "> " &$str, 0)
 EndFunc






