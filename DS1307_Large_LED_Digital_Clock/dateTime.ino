//////////////////////////////////////////////////////////////////////////
// convert RTCTime data type to time string
// return time string in hh:nn:ss format (eg. 12:34:56)
//////////////////////////////////////////////////////////////////////////
String timeStr(RTCTime time) {
  String result = int2str(time.hour) + (":") + int2str(time.minute) + (":") + int2str(time.second);
  return result;
}

//////////////////////////////////////////////////////////////////////////
// convert RTCDate data type to date string
// return date string in yy-mm-dd format (eg. 16-12-31)
//////////////////////////////////////////////////////////////////////////
String dateStr(RTCDate date) {
  String result = int2str(date.year) + ("-") + int2str(date.month) + ("-") + int2str(date.day);
  return result;
}

//////////////////////////////////////////////////////////////////////////
// check the validity of the time
//////////////////////////////////////////////////////////////////////////
boolean check_time(RTCTime time) {
  if ((time.hour > 23) || (time.hour < 0)) return false;
  if ((time.minute > 59) || (time.minute < 0)) return false;
  if ((time.second > 59) || (time.second < 0)) return false;
  return true;
}

//////////////////////////////////////////////////////////////////////////
// check the validity of the date
//////////////////////////////////////////////////////////////////////////
boolean check_date(RTCDate date) {
 // int years, byte months, byte days) {
  if ((date.year > 99) || (date.year < 0)) return false;
  if ((date.month > 12) || (date.month < 1)) return false;
  byte lastday = get_lastday(date.year, date.month);
  if ((date.day > lastday) || (date.day < 1)) return false;
  return true;
}

//////////////////////////////////////////////////////////////////////////
// get last day of a month
//////////////////////////////////////////////////////////////////////////
byte get_lastday(int years, byte months) {
  byte daysInMonth[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
  byte lastday = daysInMonth[months - 1];
  if (((years % 4) == 0) && (months==2)) lastday = 29; //leap year
  return lastday;
}

