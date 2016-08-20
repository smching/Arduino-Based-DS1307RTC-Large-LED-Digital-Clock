; #INDEX# =======================================================================================================================
; Name ..........: CommUtilities.au3
; Title .........: Communications Functions of Windows API
; Description ...: Communications Functions of Windows API calls that have been translated to AutoIt functions.
; Version Date ..: 2014-03-07
; AutoIt Version : 3.3.8.1
; Link(s) .......: http://www.autoitscript.com/wiki/CommUtilities.au3
;                  http://msdn.microsoft.com/en-us/library/aa363194(v=vs.85).aspx
; Tag(s) ........: RS-232, serial port, COM port
; Author(s) .....:
; Dll(s) ........: kernel32.dll
; Error handling : Everytime @extended is set, it is filled with @ScriptLineNumber of the error.
; ===============================================================================================================================

#include-once
#NoAutoIt3Execute
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_CommStateToString
; Description ...: Create a string representation of a DCB structure.
; Syntax ........: _CommAPI_CommStateToString(Const $tDCB)
; Parameters ....: $tDCB                - [in] A DCB structure.
; Return values .: Success - A string representation of a DCB structure.
;                  Failure - Empty string
;                  @error  - 11 struct not a correct struct returned by DllStructCreate
;                            12 element value out of range
;                            13 index would be outside of the struct
;                            14 element data type is unknown
;                            15 index <= 0
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: $tagDCB
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363214(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_CommStateToString(Const $tDCB)
	Local $sResult = ""
	Local $vValue = 0
	For $i = 1 To 15
		$vValue = DllStructGetData($tDCB, $i)
		If @error Then Return SetError(@error, @ScriptLineNumber, "")
		Switch $i
			Case 1
				$sResult &= "DCBlength = " & $vValue & @CRLF
			Case 2
				$sResult &= "Baudrate = " & $vValue & @CRLF
			Case 3
				$sResult &= "fBitFields = " & $vValue & @CRLF
				$sResult &= @TAB & "fBinary = " & BitAND(0x1, BitShift($vValue, 0)) & @CRLF
				$sResult &= @TAB & "fParity = " & BitAND(0x1, BitShift($vValue, 1)) & @CRLF
				$sResult &= @TAB & "fOutxCTSFlow = " & BitAND(0x1, BitShift($vValue, 2)) & @CRLF
				$sResult &= @TAB & "fOutxDSRFlow = " & BitAND(0x1, BitShift($vValue, 3)) & @CRLF
				$sResult &= @TAB & "fDTRControl = " & BitAND(0x3, BitShift($vValue, 4)) & @CRLF
				$sResult &= @TAB & "fDsrSensitivity = " & BitAND(0x1, BitShift($vValue, 6)) & @CRLF
				$sResult &= @TAB & "fTXContinueOnXoff = " & BitAND(0x1, BitShift($vValue, 7)) & @CRLF
				$sResult &= @TAB & "fOutX = " & BitAND(0x1, BitShift($vValue, 8)) & @CRLF
				$sResult &= @TAB & "fInX = " & BitAND(0x1, BitShift($vValue, 9)) & @CRLF
				$sResult &= @TAB & "fErrorChar = " & BitAND(0x1, BitShift($vValue, 10)) & @CRLF
				$sResult &= @TAB & "fNull = " & BitAND(0x1, BitShift($vValue, 11)) & @CRLF
				$sResult &= @TAB & "fRTSControl = " & BitAND(0x3, BitShift($vValue, 12)) & @CRLF
				$sResult &= @TAB & "fAbortOnError = " & BitAND(0x1, BitShift($vValue, 14)) & @CRLF
				$sResult &= @TAB & "Dymmy2 = " & BitAND(0x1FFFF, BitShift($vValue, 15)) & @CRLF
			Case 4
				$sResult &= "wReserved = " & $vValue & @CRLF
			Case 5
				$sResult &= "XonLim = " & $vValue & @CRLF
			Case 6
				$sResult &= "XoffLim = " & $vValue & @CRLF
			Case 7
				$sResult &= "ByteSize = " & $vValue & @CRLF
			Case 8
				$sResult &= "Parity = " & $vValue & @CRLF
			Case 1
				$sResult &= "Stopbits = " & $vValue & @CRLF
			Case 10
				$sResult &= "XonChar = " & Binary($vValue) & @CRLF
			Case 11
				$sResult &= "XoffChar = " & Binary($vValue) & @CRLF
			Case 12
				$sResult &= "ErrorChar = " & Binary($vValue) & @CRLF
			Case 13
				$sResult &= "EofChar = " & Binary($vValue) & @CRLF
			Case 14
				$sResult &= "EvtChar = " & Binary($vValue) & @CRLF
			Case 15
				$sResult &= "wReserved = " & $vValue
		EndSwitch
	Next
	Return $sResult
EndFunc   ;==>_CommAPI_CommStateToString

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_CommTimeoutsToString
; Description ...: Create s string representation of a COMMTIMEOUTS structure.
; Syntax ........: _CommAPI_CommTimeoutsToString(Const $tCommTimeouts)
; Parameters ....: $tCommTimeouts       - [in] A COMMTIMEOUTS structure.
; Return values .: Success - A string representation of a COMMTIMEOUTS structure.
;                  Failure - Empty string
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: $tagCOMMTIMEOUTS
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363190(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_CommTimeoutsToString(Const $tCommTimeouts)
	Local $sResult = ""
	Local $vValue = 0
	For $i = 1 To 5
		$vValue = DllStructGetData($tCommTimeouts, $i)
		If @error Then Return ""
		Switch $i
			Case 1
				$sResult &= "ReadIntervalTimeout = " & String($vValue) & @CRLF
			Case 2
				$sResult &= "ReadTotalTimeoutMultiplier = " & String($vValue) & @CRLF
			Case 3
				$sResult &= "ReadTotalTimeoutConstant = " & String($vValue) & @CRLF
			Case 4
				$sResult &= "WriteTotalTimeoutMultiplier = " & String($vValue) & @CRLF
			Case 5
				$sResult &= "WriteTotalTimeoutConstant = " & String($vValue)
		EndSwitch
	Next
	Return $sResult
EndFunc   ;==>_CommAPI_CommTimeoutsToString

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_CreateModeString
; Description ...: Create definition string
; Syntax ........: _CommAPI_CreateModeString(Const $iPort[, $iBaudRate = Default[, $iParity = Default[, $iByteSize = Default[,
;                  $iStopBits = Default[, $iTimeouts = Default[, $iXON = Default[, $iDSR = Default[, $iCTS = Default[,
;                  $iDTR = Default[, $iRTS = Default[, $iIDSR = Default]]]]]]]]]]])
; Parameters ....: $iPort               - [in] A port number.
;                  $iBaudRate           - [in] The baud rate at which the communications device operates.
;                  $iParity             - [in] The parity scheme to be used.
;                  $iByteSize           - [in] Specifies the number of data bits in a character.
;                  $iStopBits           - [in] Specifies the number of stop bits that define the end of a character: 1, 1.5, or 2.
;                  $iXON                - [in] Specifies whether the xon or xoff protocol for data-flow control is on or off.
;                  $iDSR                - [in] Specifies whether output handshaking that uses the Data Set Ready (DSR) circuit is on or off.
;                  $iCTS                - [in] Specifies whether output handshaking that uses the Clear To Send (CTS) circuit is on or off.
;                  $iDTR                - [in] Specifies whether the Data Terminal Ready (DTR) circuit is on or off or set to handshake.
;                  $iRTS                - [in] Specifies whether the Request To Send (RTS) circuit is set to on, off, handshake, or toggle.
;                  $iIDSR               - [in] Specifies whether the DSR circuit sensitivity is on or off.
; Return values .: Device-control String
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_OpenPort
; Link ..........: http://technet.microsoft.com/en-us/library/cc732236.aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_CreateModeString(Const $iPort, Const $iBaudRate = Default, Const $iParity = Default, Const $iByteSize = Default, Const $iStopBits = Default, Const $iXON = Default, $iDSR = Default, $iCTS = Default, $iDTR = Default, $iRTS = Default, $iIDSR = Default)
	Local $sResult = ""
	Switch Number($iPort)
		Case 1 To 256
			$sResult = "COM" & $iPort & ":"
		Case Else
			$sResult = "COM1:"
	EndSwitch
	Switch Number($iBaudRate)
		Case 11 To 256000
			$sResult &= " BAUD=" & $iBaudRate
	EndSwitch
	Switch StringUpper($iParity)
		Case "0", "N", "NONE"
			$sResult &= " PARITY=N"
		Case "1", "O", "ODD"
			$sResult &= " PARITY=O"
		Case "2", "E", "EVEN"
			$sResult &= " PARITY=E"
		Case "3", "M", "MARK"
			$sResult &= " PARITY=M"
		Case "4", "S", "SPACE"
			$sResult &= " PARITY=S"
	EndSwitch
	Switch Number($iByteSize)
		Case 5 To 8
			$sResult &= " DATA=" & $iByteSize
	EndSwitch
	If IsNumber($iStopBits) Then
		Switch $iStopBits
			Case 0
				$sResult &= " STOP=1"
			Case 1
				$sResult &= " STOP=1.5"
			Case 2
				$sResult &= " STOP=2"
		EndSwitch
	Else
		Switch StringUpper($iStopBits)
			Case "1", "O", "ONE"
				$sResult &= " STOP=1"
			Case "1.5", "F", "FIVE"
				$sResult &= " STOP=1.5"
			Case "2", "T", "TWO"
				$sResult &= " STOP=2"
		EndSwitch
	EndIf
	Switch StringUpper($iXON)
		Case "0", "OFF", "FALSE"
			$sResult &= " XON=OFF"
		Case "1", "ON", "TRUE"
			$sResult &= " XON=ON"
	EndSwitch
	Switch StringUpper($iDSR)
		Case "0", "OFF", "FALSE"
			$sResult &= " ODSR=OFF"
		Case "1", "ON", "TRUE"
			$sResult &= " ODSR=ON"
	EndSwitch
	Switch StringUpper($iCTS)
		Case "0", "OFF", "FALSE"
			$sResult &= " OCTS=OFF"
		Case "1", "ON", "TRUE"
			$sResult &= " OCTS=ON"
	EndSwitch
	Switch StringUpper($iDTR)
		Case "0", "OFF", "FALSE"
			$sResult &= " DTR=OFF"
		Case "1", "ON", "TRUE"
			$sResult &= " DTR=ON"
		Case "2", "HS"
			$sResult &= " DTR=HS"
	EndSwitch
	Switch StringUpper($iRTS)
		Case "0", "OFF", "FALSE"
			$sResult &= " RTS=OFF"
		Case "1", "ON", "TRUE"
			$sResult &= " RTS=ON"
		Case "2", "HS"
			$sResult &= " RTS=HS"
		Case "3", "TG"
			$sResult &= " RTS=TG"
	EndSwitch
	Switch StringUpper($iIDSR)
		Case "0", "OFF", "FALSE"
			$sResult &= " IDSR=OFF"
		Case "1", "ON", "TRUE"
			$sResult &= " IDSR=ON"
	EndSwitch
	Return $sResult
EndFunc   ;==>_CommAPI_CreateModeString

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_GetCOMPorts
; Description ...:
; Syntax ........: _CommAPI_GetCOMPorts()
; Parameters ....:
; Return values .: Success - A string with all COM Ports.
;                  Failure - Empty string
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_GetCOMPorts()
	Local $sResult
	Local $oWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2")
	If @error Then Return SetError(@error, @ScriptLineNumber, "")
	Local $oItems = $oWMIService.ExecQuery("SELECT * FROM Win32_PnPEntity WHERE Name LIKE '%(COM%)'", "WQL", 48)
	For $oItem In $oItems
		$sResult &= $oItem.Name & @CRLF
	Next
	Return $sResult
EndFunc   ;==>_CommAPI_GetCOMPorts