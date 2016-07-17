/*
  32x16 Dot Matrix Display DS1307RTC digital clock
  Compatible with the Arduino IDE 1.6.8
  By SM Ching (http://ediy.com.my)
*/

#define DEBUG //comment this line to disable Serial.print() & Serial.println()
#ifdef DEBUG
#define DEBUG_SERIAL_BEGIN(x) Serial.begin(x);
#define DEBUG_PRINT(x)  Serial.print(x)
#define DEBUG_PRINTLN(x)  Serial.println(x)
#else
#define DEBUG_SERIAL_BEGIN(x)
#define DEBUG_PRINT(x)
#define DEBUG_PRINTLN(x)
#endif

#include "SPI.h" // Serial Peripheral Interface protocol used by DMD2
#include "DMD2.h" // https://github.com/freetronics/DMD2 
#include "fonts/SystemFont5x7.h"
#include "fonts/Arial14.h"
#include "fonts/SystemFont3x5.h" // http://forum.freetronics.com/viewtopic.php?t=5955
#include "EEPROM.h" //use to store settings such as brightness & alarm time
#include "DS1307RTC.h" //http://rweather.github.io/arduinolibs
#include "SoftI2C.h" //http://rweather.github.io/arduinolibs
#include "RTC.h" //http://rweather.github.io/arduinolibs

// do not use analog pin (A0 to A5) including hardware I2C
// it will conflicted with DMD2 library
SoftI2C i2c(2, 3);
DS1307RTC rtc(i2c);

RTCDate RTC_date;
RTCTime RTC_time;

#define ALARM_COUNT 1 //you can create more Alarm, only one Alarm existed at the moment
RTCAlarm Alarm[ALARM_COUNT];
byte AlarmID = 0;

// define some values used by the panel and buttons
#define btnNONE   0
#define btnUP     1
#define btnDOWN   2
#define btnSELECT 3

#define FIRST_LINE  1 //text position for first line
#define SECOND_LINE 10 //text position for second line
SoftDMD dmd(1, 1); // DMD controls the entire display

// define some values used by display mode
#define FONT_NORMAL 0 //show date & time with small font for second
#define FONT_3X5   1 //show date & time with same font size
#define FONT_LARGE  2 //show hour & minute only with very large font
byte FontMode = FONT_NORMAL; //set dafault display mode to FONT_NORMAL

unsigned long previousMillis = 0;   //hold the current millis
#define BRIGHTNESS_ADDRESS 20
#define BRIGHTNESS_COUNT 8
byte brightness_position;
byte brightness[BRIGHTNESS_COUNT] = {2, 5, 10, 30, 60, 90, 130, 255};

// define some values used by menu
#define SET_FONT 0
#define SET_DATE 1
#define SET_TIME 2
#define SET_ALARM 3
#define SET_ENABLE_DISABLE_ALARM 4
#define SET_BRIGHTNESS 5

#define MENU_COUNT 6
String menu[MENU_COUNT] = {"1 MODE", "2 BRIGHT", "3 DATE  ", "4 TIME   ", "5 ALARM ", "6 EN ARM"};

//////////////////////////////////////////////////////////////////////////
// the setup routine runs once when you press reset
//////////////////////////////////////////////////////////////////////////
void setup() {
  //power_usart0_disable(); //disable Serial for power save
  //power_spi_disable(); //disable SPI for power save
  //power_twi_disable(); //disable TWI for power save

  DEBUG_SERIAL_BEGIN(9600);
  DEBUG_PRINTLN("DS1307RTC DMD Clock");
  off_all_alarm(); //turn off all alarm
  load_alarmSettings();
  brightness_position = EEPROM.read(BRIGHTNESS_ADDRESS);
  if (brightness_position > 4)  brightness_position = 0;
  DEBUG_PRINT("brightness = ");
  DEBUG_PRINTLN(brightness_position);
  dmd.setBrightness(brightness[brightness_position]);
  dmd.begin();
  //switch_alarm(LOW);
  dmd.clearScreen();
}

//////////////////////////////////////////////////////////////////////////
// the loop routine runs over and over again forever
//////////////////////////////////////////////////////////////////////////
byte previous_ss;
void loop() {
  rtc.readTime(&RTC_time); //get time from real time IC
  rtc.readDate(&RTC_date); //get date from real time IC

  if (previous_ss != RTC_time.second) { //if current seconds diff. from previous seconds
    previous_ss = RTC_time.second;
    show_time(FIRST_LINE, RTC_time, FontMode); //show time on first line of DMD screen
    show_date(SECOND_LINE, RTC_date); //show time on second line of DMD screen
    // show_alarmtime(); //show alarm time on right corner of DMD screen
    DEBUG_PRINT(dateStr(RTC_date)); DEBUG_PRINT("  "); DEBUG_PRINTLN(timeStr(RTC_time));
    checkAlarm(RTC_time, Alarm);  //check all alarms, trigger an alarm if necessary
    auto_off_alarm(10); //turn off alarm after 10 seconds
  }

  String input = serial_input();
  if (input.length() > 0) save_settings(input);
  byte this_key_press = key_press();   // read the buttons
  if (this_key_press == btnSELECT) show_menu();
}

//////////////////////////////////////////////////////////////////////////
// show time on DMD panel
//////////////////////////////////////////////////////////////////////////
void show_time(byte pos_y, RTCTime time, int font_size) {
  switch (font_size) {
    case FONT_NORMAL: //show date & time, small font for second
      dmd.selectFont(SystemFont5x7);
      dmd.drawString(0, pos_y, int2str(time.hour));
      dmd.drawString(13, pos_y, int2str(time.minute));
      dmd.selectFont(System3x5);
      dmd.drawString(25, pos_y + 2, int2str(time.second));
      break;
    case FONT_3X5: //show date & time with same font size
      dmd.selectFont(System3x5);
      dmd.drawString(2, pos_y, int2str(time.hour));
      dmd.drawString(12, pos_y, int2str(time.minute));
      dmd.drawString(22, pos_y, int2str(time.second));
      break;
    case FONT_LARGE: //show hour & minute only with very large font
      byte offset = 2;
      dmd.selectFont(Arial14);
      String strTime = int2str(time.hour) + "." + int2str(time.minute);
      dmd.drawString(0, pos_y - offset, strTime);
      //dmd.drawString(0, pos_y - offset, int2str(time.hour));
      //dmd.drawString(16, pos_y - offset, ".");
      //dmd.drawString(18, pos_y - offset, int2str(time.minute));
      break;
  }
}

//////////////////////////////////////////////////////////////////////////
// show date on DMD panel
//////////////////////////////////////////////////////////////////////////
void show_date(byte pos_y, RTCDate date) {
  byte offset = 0;
  if (FontMode == FONT_LARGE) offset = 1;
  dmd.selectFont(System3x5);
  dmd.drawString(2, pos_y + offset, int2str(date.year % 100));
  dmd.drawString(12, pos_y + offset, int2str(date.month));
  dmd.drawString(22, pos_y + offset, int2str(date.day));
}

//////////////////////////////////////////////////////////////////////////
// return incomingString if data available in serial port
//////////////////////////////////////////////////////////////////////////
String serial_input() {
  String incomingString = "";
  while (Serial.available()) { // check if there's incoming serial data
    // read a byte from the serial buffer.
    char incomingByte = Serial.read();
    delay(1); //for stability
    incomingString += incomingByte;
  }
  return incomingString;
}

//////////////////////////////////////////////////////////////////////////
// set date: save_settings(Dyymmdd) eg. save_settings(D160131)
// set time: save_settings(Thhnnss) eg. save_settings(T203456)
// set alarm: save_settings(Ahhnnssx) eg. save_settings(A2034560)
// set brightness: save_settings(Bx), where x = 0 to 7. eg. save_settings(B1)
// disable/enable alarm: save_settings(Exs), where x is alarmID, s is status (0 or 1), eg. save_settings(E01) 
//////////////////////////////////////////////////////////////////////////
void save_settings(String input) {
  //convert to upper char, the value of cmd will be D or T or A
  char cmd = input[0] & ~(0x20);

  if (cmd == 'B') { //set brightness
    byte tem_brightness_position = input.substring(1, 2).toInt();
    // checking for valid brightness
    if (tem_brightness_position < 5) {
      brightness_position = tem_brightness_position;
      dmd.setBrightness(brightness[brightness_position]);
      EEPROM.write(BRIGHTNESS_ADDRESS, brightness_position);
      display_message("OK");
    }
  }
  
  if (cmd == 'D') { //set date
    RTCDate new_date;
    new_date.year = input.substring(1, 3).toInt(); //from 2nd character to 4th character
    new_date.month = input.substring(3, 5).toInt(); //from 5th character to 6th character
    new_date.day = input.substring(5, 7).toInt();

    // checking for valid date, save settings if a date is valid
    if (check_date(new_date)) {
      new_date.year = new_date.year + 2000;
      rtc.writeDate(&new_date);
      display_message("OK");
    }
    else {
      display_message("ERROR");
    }
  }

  if (cmd == 'T' || cmd == 'A') { //set time or set alarm
    //if (cmd == 'T') { //set time
    // checking for valid time, save settings if a time is valid
    RTCTime new_time;
    new_time.hour = input.substring(1, 3).toInt();
    new_time.minute = input.substring(3, 5).toInt();
    new_time.second = input.substring(5, 7).toInt();
    byte alarmID = input.substring(7).toInt(); //from  8th character to the end of string
    if (check_time(new_time)) {
      if (cmd == 'T') {
        rtc.writeTime(&new_time);
      } else {
        RTCtime_to_alarmTime(alarmID, new_time);
        alarm_write_eeprom(alarmID);
      }
      display_message("OK");
    }
    else {
      display_message("ERROR");
    }
  }

  if (cmd == 'E') { //disable or enable alarm
    byte alarmID = input.substring(1, 2).toInt();
    byte new_flag = input.substring(2).toInt(); 
    Alarm[alarmID].flags = new_flag;
    alarm_write_eeprom(alarmID);
    display_message("OK");
  }
}

//////////////////////////////////////////////////////////////////////////
// display message on DMD
//////////////////////////////////////////////////////////////////////////
void display_message(String msg) {
  DEBUG_PRINTLN(msg);
  dmd.clearScreen();
  dmd.selectFont(SystemFont5x7);
  dmd.drawString(8, FIRST_LINE, msg);
  delay(2000);
  dmd.clearScreen();
}

//////////////////////////////////////////////////////////////////////////
// set display mode (set font)
//////////////////////////////////////////////////////////////////////////
void set_font() {
  previousMillis = millis(); // reset timeout so that the timeout will not occur
  rtc.readTime(&RTC_time);
  int new_FontMode = FontMode;
  show_time(FIRST_LINE, RTC_time, new_FontMode); //show time on first line of DMD screen
  while (true) { // loop forver
    if (isTimeout()) { //exit while if timeout occured
      break;
    }

    byte this_key_press = key_press();   // read the buttons
    if (this_key_press == btnUP) {
      new_FontMode = new_FontMode + 1;
      if (new_FontMode > 2) new_FontMode = 0;
    } else if (this_key_press == btnDOWN) {
      new_FontMode = new_FontMode - 1;
      if (new_FontMode < 0) new_FontMode = 2;
    } else if (this_key_press == btnSELECT) {
      display_message("OK");
      FontMode = new_FontMode;
      break;
    }

    if (this_key_press != btnNONE) { //if a button is pressed
      previousMillis = millis(); // reset timeout so that the timeout will not occur
      rtc.readTime(&RTC_time);
      dmd.clearScreen();
      show_time(FIRST_LINE, RTC_time, new_FontMode); //show time on first line of DMD screen
    }
  }
}

//////////////////////////////////////////////////////////////////////////
// set brigthness
//////////////////////////////////////////////////////////////////////////
void set_brightness() {
  previousMillis = millis(); // reset timeout so that the timeout will not occur
  int new_brightness_position = brightness_position;
  preview_brighteness(new_brightness_position);

  while (true) { // loop forver
    if (isTimeout()) { //exit while if timeout occured
      dmd.setBrightness(brightness[brightness_position]);
      break;
    }

    byte this_key_press = key_press();   // read the buttons
    if (this_key_press == btnUP) {
      new_brightness_position++;
      if (new_brightness_position > BRIGHTNESS_COUNT - 1) new_brightness_position = 0;
    } else if (this_key_press == btnDOWN) {
      new_brightness_position--;
      if (new_brightness_position < 0) new_brightness_position = BRIGHTNESS_COUNT - 1;
    } else if (this_key_press == btnSELECT) {
      save_settings("B" + String(new_brightness_position));
      break;
    }

    if (this_key_press != btnNONE) { //if a button is pressed
      previousMillis = millis(); // reset timeout so that the timeout will not occur
      preview_brighteness(new_brightness_position);
      //dmd.setBrightness(brightness[new_brightness_position]);
    }
  } //while (true)
}

//////////////////////////////////////////////////////////////////////////
// set system date
// return Dyymmnn (eg. "D161231")
//////////////////////////////////////////////////////////////////////////
void set_date() {
  rtc.readDate(&RTC_date);
  show_date(SECOND_LINE, RTC_date);
  int years = -1; int months = -1; int days = -1;

  //button_to_integer(initial value, x_position, min value, max value)
  years = button_to_integer(RTC_date.year - 2000, 2, 0, 99); //year ranged from 0(2000) to 99(2099)
  if (years != -1) {
    months = button_to_integer(RTC_date.month, 12, 1, 12); //month ranged from 1 to 12
  }

  if (months != -1) {
    byte lastday = get_lastday(RTC_date.year, RTC_date.month); //last day of a month
    days = button_to_integer(RTC_date.day, 22, 1, lastday);
  }

  if (days != -1) {
    String new_dateStr = "D" + int2str(years) + int2str(months) + int2str(days);
    save_settings(new_dateStr);
  }
}

//////////////////////////////////////////////////////////////////////////
// set system time: Thhmmss (eg. "T130150")
// set alarm time: Ahhmmssx (eg. "A1301500" for Alarm0, "A1301501" for Alarm1)
//////////////////////////////////////////////////////////////////////////
void set_time(char timeID) {
  byte alarmID;
  if (timeID == 'T') { //set system time
    rtc.readTime(&RTC_time);  //current time
  } else { //set alarm time
    alarmID = timeID - '0'; //convert char to integer
    RTC_time = alarmTime_to_RTCtime(alarmID); //convert AlarmTime to RTC_Time
  }

  show_time(SECOND_LINE, RTC_time, FONT_3X5); //show time on second line of DMD screen
  int hours = -1; int minutes = -1; int seconds = -1;

  //button_to_integer(initial value, x_position, min value, max value)
  hours = button_to_integer(RTC_time.hour, 2, 0, 23); //hour ranged from 0 to 23
  if (hours == -1) return;

  minutes = button_to_integer(RTC_time.minute, 12, 0, 59); //minute ranged from 0 to 59
  if (minutes == -1) return;

  seconds = button_to_integer(RTC_time.second, 22, 0, 59); //second ranged from 0 to 59
  if (seconds == -1) return;

  String str_newTime = int2str(hours) + int2str(minutes) + int2str(seconds);
  if (timeID == 'T') { //if set system time
    save_settings('T' + str_newTime); //eg. save_settings("T121314")
  } else {
    save_settings('A' + str_newTime + timeID); //eg. save_settings("A1213140") for alarm0
  }
}

//////////////////////////////////////////////////////////////////////////
// disble/enable alarm
//////////////////////////////////////////////////////////////////////////
void set_enable_disable_alarm() {
  byte alarmID = 0;
  byte new_flag = Alarm[alarmID].flags;
  previousMillis = millis(); // reset timeout so that the timeout will not occur
  while (true) { // loop forver
    if (isTimeout()) { //exit while if timeout occured
      dmd.clearScreen();
    }
    byte this_key_press = key_press();   // read the buttons
    if ((this_key_press == btnUP) || (this_key_press == btnUP)) {
      previousMillis = millis();
      if (new_flag == 1) { //The least significant bit will be 0 if the alarm is disabled or 1 if the alarm is enabled
        DEBUG_PRINTLN("Disable alarm 0");
        dmd.drawString(0, SECOND_LINE, "DISABLE");
        new_flag = 0;
      } else {
        DEBUG_PRINTLN("Enable alarm 0");
        dmd.drawString(0, SECOND_LINE, "ENABLE");
        new_flag = 1;
      }
    } else if (this_key_press == btnSELECT) {
      save_settings("E" + String(alarmID) + String(new_flag));
      break;
    }
  }
}

//////////////////////////////////////////////////////////////////////////
// preview brightness
//////////////////////////////////////////////////////////////////////////
void preview_brighteness(byte new_brightness_position) {
  String str_brighness = "";
  dmd.setBrightness(brightness[new_brightness_position]);
  str_brighness = "VALUE: " + String(new_brightness_position + 1);
  dmd.drawString(0, SECOND_LINE, str_brighness);
}

//////////////////////////////////////////////////////////////////////////
// read input from button switches & return an integer
//////////////////////////////////////////////////////////////////////////
int button_to_integer(int val, byte pos_x, int min, int max) {
  previousMillis = millis(); // reset timeout so that the timeout will not occur
  while (true) { // loop forver
    if (isTimeout()) { //exit while if timeout occured
      dmd.clearScreen();
      return -1;
    }

    byte this_key_press = key_press();   // read the buttons
    if (this_key_press == btnUP)  {
      val++;
      if (val > max) val = min;
    } else if (this_key_press == btnDOWN) {
      val--;
      if (val < min) val = max;
    } else if (this_key_press == btnSELECT) {
      //dmd.clearScreen();
      dmd.drawString(pos_x, SECOND_LINE, int2str(val));
      return val;
    }
    blink_text(pos_x, int2str(val));

    if (this_key_press != btnNONE) { //if a button is pressed
      previousMillis = millis(); // reset timeout so that the timeout will not occur
      DEBUG_PRINTLN(int2str(val));
    }
  } //while (true)
}

//////////////////////////////////////////////////////////////////////////
// blink text
//////////////////////////////////////////////////////////////////////////
unsigned long blink_previousMillis = 0;
boolean showText = true;
void blink_text(byte pos_x, String str) {
  String str_space = "    "; // reserve enough space for blink text
  byte str_length = str.length();
  str_space = str_space.substring(0, str_length); //actual space for blink text

  if (millis() >= blink_previousMillis + 150) { //blink text every 150ms
    blink_previousMillis = millis();
    if (showText) {
      dmd.drawString(pos_x, SECOND_LINE, str);
      showText = false;
    } else {
      dmd.drawString(pos_x, SECOND_LINE, str_space);
      showText = true;
    }
  }
}

//////////////////////////////////////////////////////////////////////////
// convert integer (max. 2 digits) to string with leading zero
//////////////////////////////////////////////////////////////////////////
String int2str(int i) {
  String str = String(i); //convert to string
  if (i < 10) {
    str = "0" + str; //add leading zero
  }
  return str;
}

//////////////////////////////////////////////////////////////////////////
// return true when idle for 10 seconds (defined by EVENT_TIMEOUT)
//////////////////////////////////////////////////////////////////////////
# define EVENT_TIMEOUT 10 //set timeout after ten seconds
boolean isTimeout() {
  unsigned long event_timeout = EVENT_TIMEOUT * 1000; //convert to second
  if (millis() >= previousMillis + event_timeout) {
    // play_timeout_tone();
    return true;
  }
  else return false;
}






