; #INDEX# =======================================================================================================================
; Name ..........: CommAPIHelper.au3
; Title .........: Communications Functions of Windows API
; Description ...: Communications Functions of Windows API calls that have been translated to AutoIt functions.
; Version Date ..: 2014-03-07
; AutoIt Version : 3.3.8.1
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363194(v=vs.85).aspx
; Tag(s) ........: RS-232, serial port, COM port
; Author(s) .....:
; Dll(s) ........: kernel32.dll
; Error handling : Everytime @extended is set, it is filled with @ScriptLineNumber of the error.
; ===============================================================================================================================

#include-once
#include "CommAPI.au3"
#NoAutoIt3Execute
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_ChangeCommStateElement
; Description ...: Change one control setting for an element of a specified communications device.
; Syntax ........: _CommAPI_ChangeCommStateElement(Const $hFile, Const $sElement, Const $vValue)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $sElement            - [in] A element name of DCB structure.
;                  $vValue              - [in] A new value for the element.
; Return values .: Success - Previous data in the element of the struct.
;                  Failure - 0
;                  @error  - 11 struct not a correct struct returned by DllStructCreate
;                            12 element value out of range
;                            13 index would be outside of the struct
;                            14 element data type is unknown
;                            15 index <= 0
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_SetCommStateElement, $tagDCB
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363214(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_ChangeCommStateElement(Const $hFile, Const $sElement, Const $vValue)
	Local $tDCB = DllStructCreate($tagDCB)
	_CommAPI_GetCommState($hFile, $tDCB)
	If @error Then Return SetError(@error, @extended, 0)
	Local $vResult = _CommAPI_SetCommStateElement($tDCB, $sElement, $vValue)
	_CommAPI_SetCommState($hFile, $tDCB)
	If @error Then Return SetError(@error, @extended, 0)
	Return $vResult
EndFunc   ;==>_CommAPI_ChangeCommStateElement

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_ChangeCommTimeoutsElement
; Description ...: Change one time-out parameter for an element off a specified communications device.
; Syntax ........: _CommAPI_ChangeCommTimeoutsElement(Const $hFile, Const $sElement, Const $vValue)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $sElement            - [in] A element name of COMMTIMEOUTS structure.
;                  $vValue              - [in] A new value for the element.
; Return values .: Success - Previous data in the element of the struct.
;                  Failure - 0
;                  @error  - 11 struct not a correct struct returned by DllStructCreate
;                            12 element value out of range
;                            13 index would be outside of the struct
;                            14 element data type is unknown
;                            15 index <= 0
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_SetCommTimeoutsElement, $tagCOMMTIMEOUTS
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363190(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_ChangeCommTimeoutsElement(Const $hFile, Const $sElement, Const $vValue)
	Local $tCommTimeouts = DllStructCreate($tagCOMMTIMEOUTS)
	_CommAPI_GetCommTimeouts($hFile, $tCommTimeouts)
	If @error Then Return SetError(@error, @extended, 0)
	Local $vResult = _CommAPI_SetCommTimeoutsElement($tCommTimeouts, $sElement, $vValue)
	_CommAPI_SetCommTimeouts($hFile, $tCommTimeouts)
	If @error Then Return SetError(@error, @extended, 0)
	Return $vResult
EndFunc   ;==>_CommAPI_ChangeCommTimeoutsElement

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_GetCommStateElement
; Description ...: Retrieves one control setting for an element of a specified communications device.
; Syntax ........: _CommAPI_GetCommStateElement(Const $tDCB, Const $sElement)
; Parameters ....: $tDCB                - [in] A DCB structure.
;                  $sElement            - [in] A element name of DCB structure.
; Return values .: Success - Data in the element of the struct.
;                  Failure - 0
;                  @error  - 11 struct not a correct struct returned by DllStructCreate
;                            12 element value out of range
;                            13 index would be outside of the struct
;                            14 element data type is unknown
;                            15 index <= 0
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_GetCommState, _CommAPI_SetCommStateElement, $tagDCB
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363214(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_GetCommStateElement(Const $tDCB, Const $sElement)
	Local $vResult = 0
	Local $iShift = 0
	Local $bValid = 0x1
	Switch $sElement
		Case "fBinary"
		Case "fParity"
			$iShift = 1
		Case "fOutxCTSFlow"
			$iShift = 2
		Case "fOutxDSRFlow"
			$iShift = 3
		Case "fDTRControl"
			$iShift = 4
			$bValid = 0x3
		Case "fDsrSensitivity"
			$iShift = 6
		Case "fTXContinueOnXoff"
			$iShift = 7
		Case "fOutX"
			$iShift = 8
		Case "fInX"
			$iShift = 9
		Case "fErrorChar"
			$iShift = 10
		Case "fNull"
			$iShift = 11
		Case "fRTSControl"
			$iShift = 12
			$bValid = 0x3
		Case "fAbortOnError"
			$iShift = 14
		Case "Dymmy2"
			$iShift = 15
			$bValid = 0x1FFFF
		Case Else
			$vResult = DllStructGetData($tDCB, $sElement)
			If @error Then Return SetError(@error+10, @ScriptLineNumber, 0)
			Return $vResult
	EndSwitch
	$vResult = DllStructGetData($tDCB, "fBitFields")
	If @error Then Return SetError(@error+10, @ScriptLineNumber, 0)
	Return BitAND($bValid, BitShift($vResult, $iShift))
EndFunc   ;==>_CommAPI_GetCommStateElement

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_GetCommTimeoutsElement
; Description ...: Retrieves one time-out parameter for an element of a specified communications device.
; Syntax ........: _CommAPI_GetCommTimeoutsElement(Const $tCommTimeouts, Const $sElement)
; Parameters ....: $tCommTimeouts       - [in] A COMMTIMEOUTS structure.
;                  $sElement            - [in] A element name of DCB structure.
; Return values .: Success - Data in the element of the struct.
;                  Failure - 0
;                  @error  - 11 struct not a correct struct returned by DllStructCreate
;                            12 element value out of range
;                            13 index would be outside of the struct
;                            14 element data type is unknown
;                            15 index <= 0
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_GetCommTimeouts, _CommAPI_SetCommTimeoutsElement, $tagCOMMTIMEOUTS
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363190(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_GetCommTimeoutsElement(Const $tCommTimeouts, Const $sElement)
	Local $vResult = 0
	$vResult = DllStructGetData($tCommTimeouts, $sElement)
	If @error Then Return SetError(@error+10, @ScriptLineNumber, 0)
	Return $vResult
EndFunc   ;==>_CommAPI_GetCommTimeoutsElement

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_IsOnCTS
; Description ...: The CTS (clear-to-send) signal is on.
; Syntax ........: _CommAPI_IsOnCTS(Const $hFile)
; Parameters ....: $hFile               - [in] A handle to the communications device.
; Return values .: Success - True
;                  Failure - False
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_GetCommModemStatus
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363258(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_IsOnCTS(Const $hFile)
	Local $iModemStatus = _CommAPI_GetCommModemStatus($hFile)
	If @error Then Return SetError(@error, @extended, False)
	If BitAND($iModemStatus, $MS_CTS_ON) Then Return True
	Return False
EndFunc   ;==>_CommAPI_IsOnCTS

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_IsOnDSR
; Description ...: The DSR (data-set-ready) signal is on.
; Syntax ........: _CommAPI_IsOnDSR(Const $hFile)
; Parameters ....: $hFile               - [in] A handle to the communications device.
; Return values .: Success - True
;                  Failure - False
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_GetCommModemStatus
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363258(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_IsOnDSR(Const $hFile)
	Local $iModemStatus = _CommAPI_GetCommModemStatus($hFile)
	If @error Then Return SetError(@error, @extended, False)
	If BitAND($iModemStatus, $MS_DSR_ON) Then Return True
	Return False
EndFunc   ;==>_CommAPI_IsOnDSR

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_IsOnRI
; Description ...: The RI (ring indicator) signal is on.
; Syntax ........: _CommAPI_IsOnRI(Const $hFile)
; Parameters ....: $hFile               - [in] A handle to the communications device.
; Return values .: Success - True
;                  Failure - False
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_GetCommModemStatus
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363258(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_IsOnRI(Const $hFile)
	Local $iModemStatus = _CommAPI_GetCommModemStatus($hFile)
	If @error Then Return SetError(@error, @extended, False)
	If BitAND($iModemStatus, $MS_RING_ON) Then Return True
	Return False
EndFunc   ;==>_CommAPI_IsOnRI

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_IsOnDCD
; Description ...: The DCD/CD/RLSD (Data Carrier Detect/Carrier Detect/receive-line-signal-detect) signal is on.
; Syntax ........: _CommAPI_IsOnDCD(Const $hFile)
; Parameters ....: $hFile               - [in] A handle to the communications device.
; Return values .: Success - True
;                  Failure - False
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_GetCommModemStatus
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363258(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_IsOnDCD(Const $hFile)
	Local $iModemStatus = _CommAPI_GetCommModemStatus($hFile)
	If @error Then Return SetError(@error, @extended, False)
	If BitAND($iModemStatus, $MS_RLSD_ON) Then Return True
	Return False
EndFunc   ;==>_CommAPI_IsOnDCD

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_SetCommStateElement
; Description ...: Set one control setting for an element of a specified communications device.
; Syntax ........: _CommAPI_SetCommStateElement(ByRef $tDCB, Const $sElement, Const $vValue)
; Parameters ....: $tDCB                - [in/out] A DCB structure.
;                  $sElement            - [in] A element name of DCB structure.
;                  $vValue              - [in] A new value for the element.
; Return values .: Success - Previous data in the element of the struct.
;                  Failure - 0
;                  @error  - 11 struct not a correct struct returned by DllStructCreate
;                            12 element value out of range
;                            13 index would be outside of the struct
;                            14 element data type is unknown
;                            15 index <= 0
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_SetCommState, _CommAPI_GetCommStateElement, $tagDCB
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363214(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_SetCommStateElement(ByRef $tDCB, Const $sElement, Const $vValue)
	Local $vResult = 0
	Local $iShift = 0
	Local $bValid = 0x1
	Local $bMask = 0xFFFFFFFF
	Switch $sElement
		Case "fBinary"
			$bMask = 0xFFFFFFFE
		Case "fParity"
			$iShift = -1
			$bMask = 0xFFFFFFFD
		Case "fOutxCTSFlow"
			$iShift = -2
			$bMask = 0xFFFFFFFB
		Case "fOutxDSRFlow"
			$iShift = -3
			$bMask = 0xFFFFFFF7
		Case "fDTRControl"
			$iShift = -4
			$bValid = 0x3
			$bMask = 0xFFFFFFCF
		Case "fDsrSensitivity"
			$iShift = -6
			$bMask = 0xFFFFFFBF
		Case "fTXContinueOnXoff"
			$iShift = -7
			$bMask = 0xFFFFFF7F
		Case "fOutX"
			$iShift = -8
			$bMask = 0xFFFFFEFF
		Case "fInX"
			$iShift = -9
			$bMask = 0xFFFFFDFF
		Case "fErrorChar"
			$iShift = -10
			$bMask = 0xFFFFFBFF
		Case "fNull"
			$iShift = -11
			$bMask = 0xFFFFF7FF
		Case "fRTSControl"
			$iShift = -12
			$bValid = 0x3
			$bMask = 0xFFFFCFFF
		Case "fAbortOnError"
			$iShift = -14
			$bMask = 0xFFFFBFFF
		Case "Dymmy2"
			$iShift = -15
			$bValid = 0x1FFFF
			$bMask = 0x7FFF
		Case Else
			$vResult = DllStructSetData($tDCB, $sElement, $vValue)
			If @error Then Return SetError(@error+10, @ScriptLineNumber, 0)
			Return $vResult
	EndSwitch
	$vResult = DllStructGetData($tDCB, "fBitFields")
	If @error Then Return SetError(@error+10, @ScriptLineNumber, 0)
	$vResult = BitXOR(BitShift(BitAND($vValue, $bValid), $iShift), BitAND($vResult, $bMask))
	$vResult = DllStructSetData($tDCB, "fBitFields", $vResult)
	If @error Then Return SetError(@error+10, @ScriptLineNumber, 0)
	Return $vResult
EndFunc   ;==>_CommAPI_SetCommStateElement

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_SetCommTimeoutsElement
; Description ...: Sets one time-out parameter for an element off a specified communications device.
; Syntax ........: _CommAPI_SetCommTimeoutsElement(Byref $tCommTimeouts, Const $sElement, Const $vValue)
; Parameters ....: $tCommTimeouts       - [in/out] A COMMTIMEOUTS structure.
;                  $sElement            - [in] A element name of COMMTIMEOUTS structure.
;                  $vValue              - [in] A new value for the element.
; Return values .: Success - Previous data in the element of the struct.
;                  Failure - 0
;                  @error  - 11 struct not a correct struct returned by DllStructCreate
;                            12 element value out of range
;                            13 index would be outside of the struct
;                            14 element data type is unknown
;                            15 index <= 0
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_ChangeCommTimeoutsElement, _CommAPI_SetCommTimeouts, _CommAPI_GetCommTimeoutsElement, $tagCOMMTIMEOUTS
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363190(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_SetCommTimeoutsElement(ByRef $tCommTimeouts, Const $sElement, Const $vValue)
	Local $vResult = DllStructSetData($tCommTimeouts, $sElement, $vValue)
	If @error Then Return SetError(@error+10, @ScriptLineNumber, 0)
	Return $vResult
EndFunc   ;==>_CommAPI_SetCommTimeoutsElement

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_SetOnDTR
; Description ...: Sends or clears the DTR (data-terminal-ready) signal.
; Syntax ........: _CommAPI_SetOnDTR(Const $hFile, Const $iDTR)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $iDTR                - [in] A boolean value: True  - Sends the DTR (data-terminal-ready) signal.
;                                                               False - Clears the DTR (data-terminal-ready) signal.
; Return values .: Success - True
;                  Failure - False
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_EscapeCommFunction
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363254(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_SetOnDTR(Const $hFile, Const $iDTR)
	Local $iFunction = 0
	Switch StringUpper($iDTR)
		Case "0", "OFF", "FALSE", String($CLRDTR)
			$iFunction = $CLRDTR
		Case "1", "ON", "TRUE", String($SETDTR)
			$iFunction = $SETDTR
		Case Else
			Return False
	EndSwitch
	_CommAPI_EscapeCommFunction($hFile, $iFunction)
	If @error Then Return SetError(@error, @extended, False)
	Return True
EndFunc   ;==>_CommAPI_SetOnDTR

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_SetOnRTS
; Description ...: Sends or clears the RTS (request-to-send) signal.
; Syntax ........: _CommAPI_SetOnRTS(Const $hFile, Const $iRTS)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $iRTS                - [in] A boolean value: True  - Sends the RTS (request-to-send) signal.
;                                                               False - Clears the RTS (request-to-send) signal.
; Return values .: Success - True
;                  Failure - False
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_EscapeCommFunction
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363254(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_SetOnRTS(Const $hFile, Const $iRTS)
	Local $iFunction = 0
	Switch StringUpper($iRTS)
		Case "0", "OFF", "FALSE", String($CLRRTS)
			$iFunction = $CLRRTS
		Case "1", "ON", "TRUE", String($SETRTS)
			$iFunction = $SETRTS
		Case Else
			Return False
	EndSwitch
	_CommAPI_EscapeCommFunction($hFile, $iFunction)
	If @error Then Return SetError(@error, @extended, False)
	Return True
EndFunc   ;==>_CommAPI_SetOnRTS