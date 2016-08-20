; #INDEX# =======================================================================================================================
; Name ..........: CommAPIConstants.au3
; Title .........: Communications structures and constants of Windows API
; Description ...: Communications structures of Windows API have been translated to AutoIt structures.
; Version Date ..: 2014-03-31
; AutoIt Version : 3.3.8.1
; Link ..........: http://msdn.microsoft.com/en-us/library/aa363199(v=vs.85).aspx
; Tag(s) ........: RS-232, serial port, COM port
; Author(s) .....:
; Dll(s) ........: kernel32.dll
; ===============================================================================================================================

#include-once
#include "StructureConstants.au3"
#NoAutoIt3Execute
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7


Global Const $tagCOMMPROP = _
		"WORD  wPacketLength;" & _
		"WORD  wPacketVersion;" & _
		"DWORD dwServiceMask;" & _
		"DWORD dwReserved1;" & _
		"DWORD dwMaxTxQueue;" & _
		"DWORD dwMaxRxQueue;" & _
		"DWORD dwMaxBaud;" & _
		"DWORD dwProvSubType;" & _
		"DWORD dwProvCapabilities;" & _
		"DWORD dwSettableParams;" & _
		"DWORD dwSettableBaud;" & _
		"WORD  wSettableData;" & _
		"WORD  wSettableStopParity;" & _
		"DWORD dwCurrentTxQueue;" & _
		"DWORD dwCurrentRxQueue;" & _
		"DWORD dwProvSpec1;" & _
		"DWORD dwProvSpec2;" & _
		"WCHAR wcProvChar[1];"

Global Const $tagCOMMTIMEOUTS = _
		"DWORD ReadIntervalTimeout;" & _
		"DWORD ReadTotalTimeoutMultiplier;" & _
		"DWORD ReadTotalTimeoutConstant;" & _
		"DWORD WriteTotalTimeoutMultiplier;" & _
		"DWORD WriteTotalTimeoutConstant;"

#cs
	http://msdn.microsoft.com/en-us/library/aa363200(v=vs.85).aspx
	The eight actual COMSTAT bit-sized data fields within the four bytes of fBitFields can be manipulated by bitwise logical And/Or operations.
	FieldName           Bits    Description
	-----------------   -----   ---------------------------
	fCtsHold             1      Tx waiting for CTS signal
	fDsrHold             2      Tx waiting for DSR signal
	fRlsdHold            3      Tx waiting for RLSD signal
	fXoffHold            4      Tx waiting, XOFF char rec'd
	fXoffSent            5      Tx waiting, XOFF char sent
	fEof                 6      EOF character sent
	fTxim                7      character waiting for Tx
	fReserved            8-32   reserved (25 bits)
#ce

Global Const $tagCOMSTAT = _
		"DWORD fBitFields;" & _ ; see comment above
		"DWORD cbInQue;" & _
		"DWORD cbOutQue;"

#cs
	http://msdn.microsoft.com/en-us/library/aa363214(v=vs.85).aspx
	The fourteen actual DCB bit-sized data fields within the four bytes of fBitFields can be manipulated by bitwise logical And/Or operations.
	FieldName           Bits    Description
	-----------------   -----   ---------------------------
	fBinary              1      binary mode, no EOF check
	fParity              2      enable parity checking
	fOutxCtsFlow         3      CTS output flow control
	fOutxDsrFlow         4      DSR output flow control
	fDtrControl          5-6    DTR flow control type
	fDsrSensitivity      7      DSR sensitivity
	fTXContinueOnXoff    8      XOFF continues Tx
	fOutX                9      XON/XOFF out flow control
	fInX                10      XON/XOFF in flow control
	fErrorCHAR          11      enable error replacement
	fNull               12      enable null stripping
	fRtsControl         13-14   RTS flow control
	fAbortOnError       15      abort reads/writes on error
	fDummy2             16-32   reserved (17 bits)
#ce

Global Const $tagDCB = _
		"DWORD DCBlength;" & _
		"DWORD BaudRate;" & _
		"DWORD fBitFields;" & _ ; see comment above
		"WORD  wReserved;" & _
		"WORD  XonLim;" & _
		"WORD  XoffLim;" & _
		"BYTE  ByteSize;" & _
		"BYTE  Parity;" & _
		"BYTE  StopBits;" & _
		"CHAR  XonChar;" & _
		"CHAR  XoffChar;" & _
		"CHAR  ErrorChar;" & _
		"CHAR  EofChar;" & _
		"CHAR  EvtChar;" & _
		"WORD  wReserved1;"

Global Const $tagMODEMDEVCAPS = _
		"DWORD dwActualSize;" & _
		"DWORD dwRequiredSize;" & _
		"DWORD dwDevSpecificOffset;" & _
		"DWORD dwDevSpecificSize;" & _
		"DWORD dwModemProviderVersion;" & _
		"DWORD dwModemManufacturerOffset;" & _
		"DWORD dwModemManufacturerSize;" & _
		"DWORD dwModemModelOffset;" & _
		"DWORD dwModemModelSize;" & _
		"DWORD dwModemVersionOffset;" & _
		"DWORD dwModemVersionSize;" & _
		"DWORD dwDialOptions;" & _
		"DWORD dwCallSetupFailTimer;" & _
		"DWORD dwInactivityTimeout;" & _
		"DWORD dwSpeakerVolume;" & _
		"DWORD dwSpeakerMode;" & _
		"DWORD dwModemOptions;" & _
		"DWORD dwMaxDTERate;" & _
		"DWORD dwMaxDCERate;" & _
		"BYTE  abVariablePortion[1];"

Global Const $tagMODEMSETTINGS = _
		"DWORD dwActualSize;" & _
		"DWORD dwRequiredSize;" & _
		"DWORD dwDevSpecificOffset;" & _
		"DWORD dwDevSpecificSize;" & _
		"DWORD dwCallSetupFailTimer;" & _
		"DWORD dwInactivityTimeout;" & _
		"DWORD dwSpeakerVolume;" & _
		"DWORD dwSpeakerMode;" & _
		"DWORD dwPreferredModemOptions;" & _
		"DWORD dwNegotiatedModemOptions;" & _
		"DWORD dwNegotiatedDCERate;" & _
		"BYTE  abVariablePortion[1];"


Global Const $SETXOFF = 1
Global Const $SETXON = 2
Global Const $SETRTS = 3
Global Const $CLRRTS = 4
Global Const $SETDTR = 5
Global Const $CLRDTR = 6
Global Const $SETBREAK = 8
Global Const $CLRBREAK = 9

Global Const $CE_RXOVER = 0x0001
Global Const $CE_OVERRUN = 0x0002
Global Const $CE_RXPARITY = 0x0004
Global Const $CE_FRAME = 0x0008
Global Const $CE_BREAK = 0x0010

Global Const $EV_RXCHAR = 0x0001
Global Const $EV_RXFLAG = 0x0002
Global Const $EV_TXEMPTY = 0x0004
Global Const $EV_CTS = 0x0008
Global Const $EV_DSR = 0x0010
Global Const $EV_RLSD = 0x0020
Global Const $EV_BREAK = 0x0040
Global Const $EV_ERR = 0x0080
Global Const $EV_RING = 0x0100
Global Const $EV_PERR = 0x0200
Global Const $EV_RX80FULL = 0x0400
Global Const $EV_EVENT1 = 0x0800
Global Const $EV_EVENT2 = 0x1000

Global Const $MS_CTS_ON = 0x0010
Global Const $MS_DSR_ON = 0x0020
Global Const $MS_RING_ON = 0x0040
Global Const $MS_RLSD_ON = 0x0080

Global Const $PURGE_TXABORT = 0x0001
Global Const $PURGE_RXABORT = 0x0002
Global Const $PURGE_TXCLEAR = 0x0004
Global Const $PURGE_RXCLEAR = 0x0008
Global Const $PURGE_ALL = 0x000F