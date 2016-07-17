#define ALARM_ADDRESS 10
#define ALARM_PIN  5
unsigned long Alarm_startTime[ALARM_COUNT + 1] = {0, 0};

//do not use Analog pin (D14 to D19) for output, it will reset to LOW automatically
int Alarm_output_pin[ALARM_COUNT + 1] = {4, 5};

//////////////////////////////////////////////////////////////////////////
// putting functions into array
//////////////////////////////////////////////////////////////////////////
typedef void (*AlarmFunction) ();
AlarmFunction trigger_alarm_action[] = {
  alarm_action0,
  alarm_action1
};

//////////////////////////////////////////////////////////////////////////
// Alarm0 triggered
//////////////////////////////////////////////////////////////////////////
void alarm_action0() { //run this function when first alarm triggered
  Alarm_startTime[0] = millis();
  switch_alarm(0, HIGH);
}

//////////////////////////////////////////////////////////////////////////
// Alarm1 triggered
//////////////////////////////////////////////////////////////////////////
void alarm_action1() {  //run this function when second alarm triggered
  Alarm_startTime[1] = millis();
  switch_alarm(1, HIGH);
}

//////////////////////////////////////////////////////////////////////////
// turn ON/OFF alarm
//////////////////////////////////////////////////////////////////////////
void switch_alarm(byte alarmID, boolean state) {
  pinMode(Alarm_output_pin[alarmID], OUTPUT);
  digitalWrite(Alarm_output_pin[alarmID], state);
  DEBUG_PRINT("AlarmID:");
  DEBUG_PRINT(alarmID);
  if (state == 0) {
    DEBUG_PRINTLN(" OFF");
  } else {
    DEBUG_PRINTLN(" ON");
  }
}

//////////////////////////////////////////////////////////////////////////
// alarm status
//////////////////////////////////////////////////////////////////////////
boolean alarm_state(byte alarmID) {
  return digitalRead(Alarm_output_pin[alarmID]);
}

//////////////////////////////////////////////////////////////////////////
// turn off all alarm immediately
//////////////////////////////////////////////////////////////////////////
void off_all_alarm() {
  for (byte alarmID = 0; alarmID < ALARM_COUNT; alarmID++) {
    switch_alarm(alarmID, LOW);
  }
}

//////////////////////////////////////////////////////////////////////////
// turn off alarm automatically after the alarm is triggered
//////////////////////////////////////////////////////////////////////////
void auto_off_alarm(int seconds) {
  for (byte alarmID = 0; alarmID < ALARM_COUNT; alarmID++) {
    if ((Alarm[alarmID].flags == 1) && (alarm_state(alarmID) == HIGH)) { //if alarm is enabled & already triggered
      if (millis() >= Alarm_startTime[alarmID] + seconds * 1000) {
        switch_alarm(alarmID, LOW);
      }
    }
  }
}

//////////////////////////////////////////////////////////////////////////
// load alarm settings from EEPROM
//////////////////////////////////////////////////////////////////////////
void load_alarmSettings() {
  for (byte alarmID = 0; alarmID < ALARM_COUNT; alarmID++) {
    byte alarm_address = ALARM_ADDRESS + alarmID * 7;
    Alarm[alarmID].hour = EEPROM.read(alarm_address);
    if (Alarm[alarmID].hour > 23) {
      Alarm[alarmID].hour = 0;
      Alarm[alarmID].minute = 0;
      Alarm[alarmID].second = 0;
      //Alarm[alarmID].dow = 1;
      //Alarm[alarmID].day = 1;
    } else {
      Alarm[alarmID].minute = EEPROM.read(alarm_address + 1);
      Alarm[alarmID].second = EEPROM.read(alarm_address + 2);
      //Alarm[alarmID].dow = EEPROM.read(alarm_address + 3); //day of week
      //Alarm[alarmID].day = EEPROM.read(alarm_address + 4); //day of week
      Alarm[alarmID].flags = EEPROM.read(ALARM_ADDRESS + 5);
    }

    Serial.print("AlarmID:"); Serial.print(alarmID);
    if (Alarm[alarmID].flags == 1) {
      Serial.print(" Enabled ");
    } else {
      Serial.print(" Disabled ");
    }
    Serial.print(int2str(Alarm[alarmID].hour));
    Serial.print(":"); Serial.print(int2str(Alarm[alarmID].minute));
    Serial.print(":"); Serial.println(int2str(Alarm[alarmID].second));
  }
}

//////////////////////////////////////////////////////////////////////////
//  write alarm settings to eeprom
//////////////////////////////////////////////////////////////////////////
void alarm_write_eeprom(byte alarmID) {
  byte alarm_address = ALARM_ADDRESS + alarmID * 7;
  EEPROM.write(alarm_address, Alarm[alarmID].hour);
  EEPROM.write(alarm_address + 1, Alarm[alarmID].minute);
  EEPROM.write(alarm_address + 2, Alarm[alarmID].second);
  //EEPROM.write(alarm_address + 3, Alarm[alarmID].dow);
  //EEPROM.write(alarm_address + 4, Alarm[alarmID].day);;
  EEPROM.write(alarm_address + 5, Alarm[alarmID].flags);
}

//////////////////////////////////////////////////////////////////////////
// convert Alarm_Time to RTC_Time
//////////////////////////////////////////////////////////////////////////
RTCTime alarmTime_to_RTCtime(byte alarmID) {
  RTCTime time;
  time.hour = Alarm[AlarmID].hour;
  time.minute = Alarm[AlarmID].minute;
  time.second = Alarm[AlarmID].second;
  return time;
}

//////////////////////////////////////////////////////////////////////////
// convert RTC_Time to Alarm_Time
//////////////////////////////////////////////////////////////////////////
RTCAlarm RTCtime_to_alarmTime(byte alarmID, RTCTime time) {
  Alarm[AlarmID].hour = time.hour;
  Alarm[AlarmID].minute = time.minute;
  Alarm[AlarmID].second = time.second;
  return Alarm[AlarmID];
}

//////////////////////////////////////////////////////////////////////////
// check alarm (compare current time with all alarm time)
//////////////////////////////////////////////////////////////////////////
void checkAlarm(RTCTime system_time, RTCAlarm * Alarm) {
  for (byte alarmID = 0; alarmID < ALARM_COUNT; alarmID++) {
    if (Alarm[alarmID].flags == 1) {
      RTCTime alarmTime;
      alarmTime = alarmTime_to_RTCtime(alarmID);
      if (system_time.hour == alarmTime.hour && system_time.minute == alarmTime.minute && system_time.second == alarmTime.second) {
        trigger_alarm_action[alarmID](); // trigger an alarm if necessary
      }
    }
  }
}

