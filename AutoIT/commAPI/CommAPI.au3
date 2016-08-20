; #INDEX# =======================================================================================================================
; Name ..........: CommAPI.au3
; Title .........: Communications Functions of Windows API
; Description ...: Communications Functions of Windows API calls that have been translated to AutoIt functions.
; Version Date ..: 2014-04-04
; AutoIt Version : 3.3.8.1
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363194(v=vs.85).aspx
; Tag(s) ........: RS-232, serial port, COM port
; Author(s) .....:
; Dll(s) ........: kernel32.dll
; Error handling : Everytime @extended is set, it is filled with @ScriptLineNumber of the error.
; ===============================================================================================================================

#include-once
#include "CommAPIConstants.au3"
#NoAutoIt3Execute
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_BuildCommDCB
; Description ...: Fills a specified DCB structure with values specified in a device-control string.
; Syntax ........: _CommAPI_BuildCommDCB(Const $sMode, Byref $tDBC)
; Parameters ....: $sMode               - [in] A device-definition string.
;                  $tDBC                - [out] A DCB structure.
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
; Related .......: _CommAPI_BuildCommDCBAndTimeouts, $tagDCB
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363143(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_BuildCommDCB(Const $sMode, ByRef $tDBC)
	Local $aResult = DllCall("kernel32.dll", "bool", "BuildCommDCB", "str", $sMode, "ptr", DllStructGetPtr($tDBC))
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_BuildCommDCB

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_BuildCommDCBAndTimeouts
; Description ...: Translates a device-definition string into appropriate device-control block codes and places them into a device control block.
;                  The function can also set up time-out values for a device.
; Syntax ........: _CommAPI_BuildCommDCBAndTimeouts(Const $sMode, Byref $tDBC, Byref $tCommTimeouts)
; Parameters ....: $sMode               - [in] A device-definition string.
;                  $tDBC                - [out] A DCB structure.
;                  $tCommTimeouts       - [out] A COMMTIMEOUTS structure.
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
; Related .......: _CommAPI_BuildCommDCB, $tagDCB, $tagCOMMTIMEOUTS
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363145(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_BuildCommDCBAndTimeouts(Const $sMode, ByRef $tDBC, ByRef $tCommTimeouts)
	Local $aResult = DllCall("kernel32.dll", "bool", "BuildCommDCBAndTimeouts", "str", $sMode, "ptr", DllStructGetPtr($tDBC), "ptr", DllStructGetPtr($tCommTimeouts))
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_BuildCommDCBAndTimeouts

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_ClearCommBreak
; Description ...: Restores character transmission for a specified communications device and places the transmission line in a nonbreak state.
; Syntax ........: _CommAPI_ClearCommBreak(Const $hFile)
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
; Related .......: _CommAPI_ClearCommError
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363179(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_ClearCommBreak(Const $hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "ClearCommBreak", "handle", $hFile)
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_ClearCommBreak

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_ClearCommError
; Description ...: Retrieves information about a communications error and reports the current status of a communications device.
; Syntax ........: _CommAPI_ClearCommError(Const $hFile[, $tComStat = 0])
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $tComStat            - [out] A COMSTAT structure in which the device's status information is returned.
; Return values .: Success - A mask indicating the type of error.
;                  Failure - 0
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_ClearCommBreak, $tagCOMSTAT
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363180(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_ClearCommError(Const $hFile, $tComStat = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "ClearCommError", "handle", $hFile, "dword*", 0, "ptr", DllStructGetPtr($tComStat))
	If @error Then Return SetError(@error, @ScriptLineNumber, 0)
	If Not $aResult[0] Then SetError(-1, @ScriptLineNumber)
	Return $aResult[2]
EndFunc   ;==>_CommAPI_ClearCommError

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_EscapeCommFunction
; Description ...: Directs the specified communications device to perform an extended function.
; Syntax ........: _CommAPI_EscapeCommFunction(Const $hFile, Const $iFunction)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $iFunction           - [in] The extended function to be performed.
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
; Related .......: _CommAPI_SetOnDTR, _CommAPI_SetOnRTS
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363254(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_EscapeCommFunction(Const $hFile, Const $iFunction)
	Local $aResult = DllCall("kernel32.dll", "bool", "EscapeCommFunction", "handle", $hFile, "dword", $iFunction)
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_EscapeCommFunction

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_GetCommMask
; Description ...: Retrieves the value of the event mask for a specified communications device.
; Syntax ........: _CommAPI_GetCommMask(Const $hFile)
; Parameters ....: $hFile               - [in] A handle to the communications device.
; Return values .: Success - A mask of events that are currently enabled.
;                  Failure - 0
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363257(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_GetCommMask(Const $hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetCommMask", "handle", $hFile, "dword*", 0)
	If @error Then Return SetError(@error, @ScriptLineNumber, 0)
	If Not $aResult[0] Then SetError(-1, @ScriptLineNumber)
	Return $aResult[2]
EndFunc   ;==>_CommAPI_GetCommMask

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_GetCommModemStatus
; Description ...: Retrieves the modem control-register values.
; Syntax ........: _CommAPI_GetCommModemStatus(Const $hFile, Byref $pModemStatus)
; Parameters ....: $hFile               - [in] A handle to the communications device.
; Return values .: Success - The current state of the modem control-register values.
;                  Failure - 0
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_IsOnCTS, _CommAPI_IsOnDSR, _CommAPI_IsOnRI, _CommAPI_IsOnDCD, _CommAPI_WaitCommEvent
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363258(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_GetCommModemStatus(Const $hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetCommModemStatus", "handle", $hFile, "dword*", 0)
	If @error Then Return SetError(@error, @ScriptLineNumber, 0)
	If Not $aResult[0] Then SetError(-1, @ScriptLineNumber)
	Return $aResult[2]
EndFunc   ;==>_CommAPI_GetCommModemStatus

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_GetCommProperties
; Description ...: Retrieves information about the communications properties for a specified communications device.
; Syntax ........: _CommAPI_GetCommProperties(Const $hFile[, $tCOMMPROP = 0])
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $tCOMMPROP           - [out] A COMMPROP structure in which the communications properties information is returned.
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
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363259(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_GetCommProperties(Const $hFile, $tCOMMPROP = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetCommProperties", "handle", $hFile, "ptr", DllStructGetPtr($tCOMMPROP))
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_GetCommProperties

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_GetCommState
; Description ...: Retrieves the current control settings for a specified communications device.
; Syntax ........: _CommAPI_GetCommState(Const $hFile, $tDCB = 0)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $tDCB                - [out] A DCB structure that receives the control settings information.
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
; Related .......: _CommAPI_SetCommState, $tagDCB
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363260(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_GetCommState(Const $hFile, $tDCB = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetCommState", "handle", $hFile, "ptr", DllStructGetPtr($tDCB))
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_GetCommState

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_GetCommTimeouts
; Description ...: Retrieves the time-out parameters for all read and write operations on a specified communications device.
; Syntax ........: _CommAPI_GetCommTimeouts(Const $hFile, $tCommTimeouts = 0)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $tCommTimeouts       - [out] A COMMTIMEOUTS structure in which the time-out information is returned.
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
; Related .......: _CommAPI_SetCommTimeouts, $tagCOMMTIMEOUTS
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363261(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_GetCommTimeouts(Const $hFile, $tCommTimeouts = 0)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetCommTimeouts", "handle", $hFile, "ptr", DllStructGetPtr($tCommTimeouts))
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_GetCommTimeouts

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_PurgeComm
; Description ...: Discards all characters from the output or input buffer of a specified communications resource.
;                  It can also terminate pending read or write operations on the resource.
; Syntax ........: _CommAPI_PurgeComm(Const $hFile[, $iFlags = $PURGE_ALL])
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $iFlags              - [in] An integer value.
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
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363428(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_PurgeComm(Const $hFile, Const $iFlags = $PURGE_ALL)
	Local $aResult = DllCall("kernel32.dll", "bool", "PurgeComm", "handle", $hFile, "dword", $iFlags)
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_PurgeComm

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_SetCommBreak
; Description ...: Suspends character transmission for a specified communications device and places the transmission line in a break state until the ClearCommBreak function is called.
; Syntax ........: _CommAPI_SetCommBreak(Const $hFile)
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
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363433(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_SetCommBreak(Const $hFile)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetCommBreak", "handle", $hFile)
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_SetCommBreak

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_SetCommMask
; Description ...: Specifies a set of events to be monitored for a communications device.
; Syntax ........: _CommAPI_SetCommMask(Const $hFile, Const $iEventMask)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $iEventMask          - [in] The events to be enabled. A value of zero disables all events.
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
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363435(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_SetCommMask(Const $hFile, Const $iEventMask)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetCommMask", "handle", $hFile, "dword", $iEventMask)
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_SetCommMask

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_SetCommState
; Description ...: Configures a communications device according to the specifications in a device-control block.
;                  The function reinitializes all hardware and control settings, but it does not empty output or input queues.
; Syntax ........: _CommAPI_SetCommState(Const $hFile, Const $tDCB)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $tDCB                - [in] A DCB structure that contains the configuration information for the specified communications device.
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
; Related .......: _CommAPI_GetCommState, $tagDCB
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363436(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_SetCommState(Const $hFile, Const $tDCB)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetCommState", "handle", $hFile, "ptr", DllStructGetPtr($tDCB))
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_SetCommState

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_SetCommTimeouts
; Description ...: Sets the time-out parameters for all read and write operations on a specified communications device.
; Syntax ........: _CommAPI_SetCommTimeouts(Const $hFile, Const $tCommTimeouts)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $tCommTimeouts       - [in] A COMMTIMEOUTS structure that contains the new time-out values.
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
; Related .......: _CommAPI_GetCommTimeouts, $tagCOMMTIMEOUTS
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363437(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_SetCommTimeouts(Const $hFile, Const $tCommTimeouts)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetCommTimeouts", "handle", $hFile, "ptr", DllStructGetPtr($tCommTimeouts))
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_SetCommTimeouts

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_SetupComm
; Description ...: Initializes the communications parameters for a specified communications device.
; Syntax ........: _CommAPI_SetupComm(Const $hFile, Const $iInQueue, Const $iOutQueue)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $iInQueue            - [in] The recommended size of the device's internal input buffer, in bytes.
;                  $iOutQueue           - [in] The recommended size of the device's internal output buffer, in bytes.
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
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363439(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_SetupComm(Const $hFile, Const $iInQueue, Const $iOutQueue)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetupComm", "handle", $hFile, "dword", $iInQueue, "dword", $iOutQueue)
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_SetupComm

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_TransmitCommChar
; Description ...: Transmits a specified character ahead of any pending data in the output buffer of the specified communications device.
; Syntax ........: _CommAPI_TransmitCommChar(Const $hFile, Const $cChar)
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $sChar               - [in] The character to be transmitted.
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
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363473(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_TransmitCommChar(Const $hFile, Const $cChar)
	Local $tChar = DllStructCreate("char")
	DllStructSetData($tChar, 1, $cChar)
	Local $aResult = DllCall("kernel32.dll", "bool", "TransmitCommChar", "handle", $hFile, "char", $tChar)
	If @error Then Return SetError(@error, @ScriptLineNumber, False)
	If Not $aResult[0] Then Return SetError(-1, @ScriptLineNumber, False)
	Return True
EndFunc   ;==>_CommAPI_TransmitCommChar

; #FUNCTION# ====================================================================================================================
; Name ..........: _CommAPI_WaitCommEvent
; Description ...: Waits for an event to occur for a specified communications device.
; Syntax ........: _CommAPI_WaitCommEvent(Const $hFile [, Const $tOverlapped = 0])
; Parameters ....: $hFile               - [in] A handle to the communications device.
;                  $tOverlapped         - [in] An OVERLAPPED structure.
; Return values .: Success - A mask indicating the type of event that occurred.
;                  Failure - 0
;                  @error  - 1 unable to use the DLL file
;                            2 unknown "return type"
;                            3 "function" not found in the DLL file
;                            4 bad number of parameters
;                            5 bad parameter
;                           -1 function fails (To get extended error information, call _WinAPI_GetLastError or _WinAPI_GetLastErrorMessage)
; Author ........:
; Modified ......:
; Remarks .......:
; Related .......: _CommAPI_EscapeCommFunction, _CommAPI_GetCommModemStatus
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363479(v=vs.85).aspx
; Example .......: No
; ===============================================================================================================================
Func _CommAPI_WaitCommEvent(Const $hFile, Const $tOverlapped = 0)
	Local $pOverlapped = DllStructGetPtr($tOverlapped)
	If Not $pOverlapped Then $pOverlapped = DllStructGetPtr(DllStructCreate($tagOverlapped))
	Local $aResult = DllCall("kernel32.dll", "bool", "WaitCommEvent", "handle", $hFile, "dword*", 0, "ptr", $pOverlapped)
	If @error Then Return SetError(@error, @ScriptLineNumber, 0)
	If Not $aResult[2] Then Return SetError(-1, @ScriptLineNumber, 0)
	Return $aResult[2]
EndFunc   ;==>_CommAPI_WaitCommEvent