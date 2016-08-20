; #INDEX# =======================================================================================================================
; Name ..........: CommInterface.au3
; Title .........: Communications Functions of Windows API
; Description ...: Communications Functions of Windows API calls that have been translated to AutoIt functions.
; Version Date ..: 2014-04-08
; AutoIt Version : 3.3.8.1
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363194(v=vs.85).aspx
; Tag(s) ........: RS-232, serial port, COM port
; Author(s) .....:
; Dll(s) ........: kernel32.dll
; Error handling : Everytime @extended is set, it is filled with @ScriptLineNumber of the error.
; ===============================================================================================================================

#include-once
#include "CommAPIHelper.au3"
#include "CommUtilities.au3"
#include <WinAPI.au3>
#NoAutoIt3Execute
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_ClosePort
; Description ...: CLoses a specified communications device.
; Syntax ........: _CommAPI_ClosePort(Const $hFile)
; Parameters ....: $hFile               - [in] A handle to the communications device.
; Return values .: Success - True
;                  Failure - False
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_OpenPort
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_ClosePort(Const $hFile)
	Local $fSuccess = _WinAPI_CloseHandle($hFile)
	If @error Then Return SetError(@error, 0, False)
	If Not $fSuccess Then Return SetError(-1, @ScriptLineNumber, False)
	Return $fSuccess
EndFunc   ;==>_CommAPI_ClosePort

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_OpenCOMPort
; Description ...: Opens a COM Port.
; Syntax ........: _CommAPI_OpenCOMPort(Const $iPort[, $iBaudRate = Default[, $iParity = Default[, $iByteSize = Default[,
;                  $iStopBits = Default]]]])
; Parameters ....: $iPort               - [in] A port number.
;                  $iBaudRate           - [in] The baud rate at which the communications device operates.
;                  $iParity             - [in] The parity scheme to be used.
;                  $iByteSize           - [in] Specifies the number of data bits in a character.
;                  $iStopBits           - [in] Specifies the number of stop bits that define the end of a character: 1, 1.5, or 2.
; Return values .: Success - Open handle to a specified communications device
;                  Failure - 0
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                            11 struct not a correct struct returned by DllStructCreate
;                            12 element value out of range
;                            13 index would be outside of the struct
;                            14 element data type is unknown
;                            15 index <= 0
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_OpenPort, _CommAPI_ClosePort, _CommAPI_CreateModeString
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_OpenCOMPort(Const $iPort, Const $iBaudRate = Default, Const $iParity = Default, Const $iByteSize = Default, Const $iStopBits = Default)
	Local $sMode = _CommAPI_CreateModeString($iPort, $iBaudRate, $iParity, $iByteSize, $iStopBits)
	Local $hFile = _CommAPI_OpenPort($sMode)
	If @error Then Return SetError(@error, @extended, 0)
	Return $hFile
EndFunc   ;==>_CommAPI_OpenCOMPort

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_OpenPort
; Description ...: Opens a specified communications device.
; Syntax ........: _CommAPI_OpenPort(Const $sMode)
; Parameters ....: $sMode               - [in] A device-definition string.
; Return values .: Success - Open handle to a specified communications device
;                  Failure - 0
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                            11 struct not a correct struct returned by DllStructCreate
;                            12 element value out of range
;                            13 index would be outside of the struct
;                            14 element data type is unknown
;                            15 index <= 0
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_OpenCOMPort, _CommAPI_ClosePort, _CommAPI_SetCommState
; Link ..........: http://msdn.microsoft.com/en-us/library/aa365430(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_OpenPort(Const $sMode)
	Local $sFileName = "\\.\" & StringLeft($sMode, StringInStr($sMode, ":") - 1)
	Local $hFile = _WinAPI_CreateFile($sFileName, 3, 6)
	If @error Then Return SetError(@error, @ScriptLineNumber, 0)
	If $hFile <= 0 Then Return SetError(-1, @ScriptLineNumber, 0)

	Local $tDCB = DllStructCreate($tagDCB)
	Local $tCommTimeouts = DllStructCreate($tagCOMMTIMEOUTS)

	_CommAPI_BuildCommDCB($sMode, $tDCB)
	If @error Then Return SetError(@error, @extended, 0)

	_CommAPI_SetCommTimeoutsElement($tCommTimeouts, "ReadTotalTimeoutMultiplier", 1)
	If @error Then Return SetError(@error, @extended, 0)

	_CommAPI_SetCommTimeoutsElement($tCommTimeouts, "WriteTotalTimeoutMultiplier", 1)
	If @error Then Return SetError(@error, @extended, 0)

	If Not _CommAPI_SetCommState($hFile, $tDCB) Then Return SetError(@error, @extended, 0)
	If Not _CommAPI_SetCommTimeouts($hFile, $tCommTimeouts) Then Return SetError(@error, @extended, 0)

	Return $hFile
EndFunc   ;==>_CommAPI_OpenPort

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_ReceiveBinary
; Description ...: Receives data (RxD/RX/RD) to a specified communications device.
; Syntax ........: _CommAPI_ReceiveBinary(Const $hFile[, $iTimeout = 1[, $iMaxLength = 0[, $vSeparator = ""]]])
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $iTimeout            - [in] An integer value for total read timeout in milliseconds.
;                                              Is activated only by positive values.
;                  $iMaxLength          - [in] An integer value for maximum length of result.
;                                              Is activated only by positive values.
;                  $vSeparator          - [in] A value which is used as a separator.
;                                              Is activated only by non-empty values.
; Return values .: Success - Received binary data
;                  Failure - Received binary data
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
;                           -2 timeout
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_ReceiveString, _CommAPI_TransmitData
; Link ..........: http://msdn.microsoft.com/en-us/library/aa365467(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_ReceiveBinary(Const $hFile, Const $iTimeout = 1, Const $iMaxLength = 0, Const $vSeparator = "")
	Local $bSeparator = Binary($vSeparator)
	Local $iSepLength = BinaryLen($bSeparator)
	Local $fSuccess = False
	Local $tBuffer = DllStructCreate("BYTE")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $iRead = 0
	Local $bResult = Binary("")
	Local $iResLength = 0
	Local $hTimer = TimerInit()
	While True
		$fSuccess = _WinAPI_ReadFile($hFile, $pBuffer, 1, $iRead)
		If @error Then Return SetError(@error, @ScriptLineNumber, $bResult)
		If Not $fSuccess Then Return SetError(-1, @ScriptLineNumber, $bResult)
		If $iRead Then
			$bResult &= BinaryMid(Binary(DllStructGetData($tBuffer, 1)), 1, 1)
			$iResLength = BinaryLen($bResult)
			If $iMaxLength And $iResLength = $iMaxLength Then Return $bResult
			If $iSepLength And $bSeparator = BinaryMid($bResult, 1 + $iResLength - $iSepLength) Then Return BinaryMid($bResult, 1, $iResLength - $iSepLength)
		Else
			If $bResult And Not $iSepLength Then Return $bResult
			If $iTimeout And $iTimeout < TimerDiff($hTimer) Then Return SetError(-2, @ScriptLineNumber, $bResult)
		EndIf
	WEnd
EndFunc   ;==>_CommAPI_ReceiveBinary

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_ReceiveString
; Description ...: Receives data (RxD/RX/RD) to a specified communications device.
; Syntax ........: _CommAPI_ReceiveString(Const $hFile[, $iTimeout = 1[, $iMaxLength = 0[, $sSeparator = ""]]])
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $iTimeout            - [in] An integer value for total read timeout in milliseconds.
;                                              Is activated only by positive values.
;                  $iMaxLength          - [in] An integer value for maximum length of result.
;                                              Is activated only by positive values.
;                  $sSeparator          - [in] A value which is used as a separator.
;                                              Is activated only by non-empty values.
;                  $iFlag               - [in] Flag for function BinaryToString().
; Return values .: Success - Received string
;                  Failure - Received string
;                            Received binary data in case of @error = -3
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
;                           -2 timeout
;                           -3 error in BinaryToString
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_ReceiveBinary, _CommAPI_TransmitData
; Link ..........: http://msdn.microsoft.com/en-us/library/aa365467(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_ReceiveString(Const $hFile, Const $iTimeout = 1, Const $iMaxLength = 0, Const $sSeparator = "", Const $iFlag = 1)
	Local $bResult = _CommAPI_ReceiveBinary($hFile, $iTimeout, $iMaxLength, StringToBinary($sSeparator, $iFlag))
	Local $iError = @error
	Local $iExtended = @extended
	Local $sResult = ""
	If $bResult Then
		$sResult = BinaryToString($bResult, $iFlag)
		If @error Then SetError(-3, @ScriptLineNumber, $bResult)
	EndIf
	Return SetError($iError, $iExtended, $sResult)
EndFunc   ;==>_CommAPI_ReceiveString

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_TransmitBinary
; Description ...: Transmits data (TxD/TX/TD) to a specified communications device.
; Syntax ........: _CommAPI_TransmitData(Const $hFile, Const $sData)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $vData               - [in] A binary value to transmit.
; Return values .: Success - Number of written bytes
;                  Failure - Number of written bytes
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_TransmitString, _CommAPI_ReceiveBinary
; Link ..........: http://msdn.microsoft.com/en-us/library/aa365747(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_TransmitBinary(Const $hFile, Const $vData)
	Local $bData = Binary($vData)
	Local $iLength = BinaryLen($vData)
	Local $iWritten = 0
	Local $tBuffer = DllStructCreate("BYTE[" & $iLength & "]")
	DllStructSetData($tBuffer, 1, $bData)
	Local $fSuccess = _WinAPI_WriteFile($hFile, DllStructGetPtr($tBuffer), $iLength, $iWritten)
	If @error Then Return SetError(@error, @ScriptLineNumber, 0)
	If Not $fSuccess Then Return SetError(-1, @ScriptLineNumber, $iWritten)
	Return $iWritten
EndFunc   ;==>_CommAPI_TransmitBinary

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_TransmitString
; Description ...: Transmits data (TxD/TX/TD) to a specified communications device.
; Syntax ........: _CommAPI_TransmitData(Const $hFile, Const $sData)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $sData               - [in] A string value to transmit.
;                  $iFlag               - [in] Flag for function StringToBinary().
; Return values .: Success - Number of written bytes
;                  Failure - Number of written bytes
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_TransmitBinary, _CommAPI_ReceiveString
; Link ..........: http://msdn.microsoft.com/en-us/library/aa365747(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_TransmitString(Const $hFile, Const $sData, Const $iFlag = 1)
	Local $iWritten = _CommAPI_TransmitBinary($hFile, StringToBinary($sData, $iFlag))
	If @error Then Return SetError(@error, @extended, $iWritten)
	Return $iWritten
EndFunc