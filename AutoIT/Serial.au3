;#include <GuiComboBox.au3>
#include "CommInterface.au3"

Global $iPort = 1
Global $iBaud = 9600
Global $iParity = 0
Global $iByteSize = 8
Global $iStopBits = 1

#comments-start
	example to use the Serial_errorMessage function
	if @error Then
	Serial_errorMessage(@error, @extended, $sResult)
	EndIf
#comments-end
Func Serial_errorMessage($err, $ext, $result)
	Switch $err
		;Case 0
		;MsgBox(64, "Result", $result)
		Case -1
			MsgBox(32, "Error", _WinAPI_GetLastErrorMessage())
		Case -2
			MsgBox(32, "Timeout", $result)
		Case Else
			MsgBox(32, "Error", "Error " & $err & " in line " & $ext)
	EndSwitch
EndFunc   ;==>Serial_errorMessage


#comments-start
	open a serial port & set the timeout
#comments-end
Func Serial_openPort()
	Global $hFile = _CommAPI_OpenCOMPort($iPort, $iBaud, $iParity, $iByteSize, $iStopBits)
	If @error Then Return SetError(@error, @ScriptLineNumber)

	;timeout is set to one millisecond by default.
	;you need to use a bigger value (here using 50ms) for some slow devices
	_CommAPI_ChangeCommTimeoutsElement($hFile, "ReadTotalTimeoutMultiplier", 50)
	If @error Then Return SetError(@error, @ScriptLineNumber)
EndFunc   ;==>Serial_openPort


#comments-start
	receive data from a serial port
#comments-end
Func Serial_receive()
	Serial_openPort()
	if @error Then Return SetError(@error, @ScriptLineNumber)

	Local $sResult = _CommAPI_ReceiveString($hFile, 5000)
	If @error Then Return SetError(@error, @ScriptLineNumber, $sResult)

	_CommAPI_ClosePort($hFile)
	If @error Then Return SetError(@error, @ScriptLineNumber, $sResult)

	Return $sResult
EndFunc   ;==>Serial_receive


#comments-start
	E.g. Serial_transmit("data to send"), send data to serial port without acknowledge
	E.g. Serial_transmit("data to send", 1), send data to serial port & return its status
#comments-end
Func Serial_transmit($cmd, $needReply = 0)
	Serial_openPort()
	if @error Then Return SetError(@error, @ScriptLineNumber)

	_CommAPI_ClearCommError($hFile)
	If @error Then Return SetError(@error, @ScriptLineNumber)

	_CommAPI_PurgeComm($hFile)
	If @error Then Return SetError(@error, @ScriptLineNumber)

	Local $sCommand = $cmd & @CRLF ;end with carriage return and line feed
	_CommAPI_TransmitString($hFile, $sCommand)
	If @error Then Return SetError(@error, @ScriptLineNumber)
	sleep(100)

	if $needReply = 1 Then
		Local $sResult = _CommAPI_ReceiveString($hFile, 5000)
		If @error Then Return SetError(@error, @ScriptLineNumber, $sResult)
	Else
		$sResult = ""
	EndIf

	_CommAPI_ClosePort($hFile)
	If @error Then Return SetError(@error, @ScriptLineNumber, $sResult)

	Return $sResult
EndFunc   ;==>Serial_transmit

