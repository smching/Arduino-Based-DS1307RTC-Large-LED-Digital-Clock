#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=koda\forms\led clock baudrate combo.kxf
$Form1_1 = GUICreate("LED Clock V1.0", 350, 270, -1, -1)
$Label1 = GUICtrlCreateLabel("Com Port", 13, 16, 47, 17)
$Label2 = GUICtrlCreateLabel("Baud Rate", 182, 16, 55, 17)
$Label3 = GUICtrlCreateLabel("Display Mode", 13, 62, 68, 17)
$Label4 = GUICtrlCreateLabel("Brightness", 13, 88, 53, 17)
$Label5 = GUICtrlCreateLabel("System Date", 13, 115, 64, 17)
$Label6 = GUICtrlCreateLabel("System Time", 13, 141, 64, 17)
$Label7 = GUICtrlCreateLabel("Alarm Time", 13, 167, 56, 17)
$Label8 = GUICtrlCreateLabel("Alarm Enable", 13, 194, 66, 17)
$Label9 = GUICtrlCreateLabel("Command", 13, 220, 51, 17)
$In_port = GUICtrlCreateInput("1", 85, 13, 85, 21)

$Cb_baudRate = GUICtrlCreateCombo("9600", 237, 13, 85, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "300|600|1200|2400|4800|9600|14400|19200|28800|38400|57600|115200")

$Cb_mode = GUICtrlCreateCombo("", 85, 59, 85, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Font Normal|Font 3x5|Font Large", "Font Normal")

$Cb_brightness = GUICtrlCreateCombo("", 85, 85, 85, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "0|1|2|3|4|5|6|7", "1")

$Ed_systemDate = GUICtrlCreateDate("2016/01/21", 85, 111, 86, 21, BitOR($DTS_UPDOWN,$DTS_TIMEFORMAT))
	GUICtrlSendMsg(-1, $DTM_SETFORMATW, 0, "yyyy-mm-dd") ; DTM_SETFORMATW

$Ed_systemTime = GUICtrlCreateDate("", 85, 137, 86, 21, BitOR($DTS_UPDOWN,$DTS_TIMEFORMAT))
	GUICtrlSendMsg(-1, $DTM_SETFORMATW, 0, "HH:mm:ss") ; DTM_SETFORMATW

$Ed_alarmTime = GUICtrlCreateDate("", 85, 163, 86, 21, BitOR($DTS_UPDOWN,$DTS_TIMEFORMAT))
	GUICtrlSendMsg(-1, $DTM_SETFORMATW, 0, "HH:mm:ss") ; DTM_SETFORMATW

$Cb_alarmEnable = GUICtrlCreateCombo("", 85, 189, 85, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "No|Yes", "Yes")

$In_command = GUICtrlCreateInput("", 85, 215, 85, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$StatusBar1 = _GUICtrlStatusBar_Create($Form1_1)
Dim $StatusBar1_PartsWidth[1] = [-1]
_GUICtrlStatusBar_SetParts($StatusBar1, $StatusBar1_PartsWidth)
_GUICtrlStatusBar_SetText($StatusBar1, @TAB & "By: SM.Ching (http://ediy.com.my)", 0)
$Pic1 = GUICtrlCreatePic("LED Clock.jpg", 182, 59, 150, 150)
$Graphic1 = GUICtrlCreateGraphic(13, 46, 320, 1)
GUICtrlSetColor(-1, 0x000000)
$Bt_send = GUICtrlCreateButton("Send (F2)", 182, 215, 72, 20)
$Bt_read = GUICtrlCreateButton("Read (F3)", 262, 215, 72, 20)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

