//////////////////////////////////////////////////////////////////////////
// select menu
//////////////////////////////////////////////////////////////////////////
void show_menu() {
  dmd.selectFont(System3x5);
  previousMillis = millis(); // reset timeout so that the timeout will not occur
  int menu_item = 0;
  dmd.clearScreen();
  dmd.drawString(0, FIRST_LINE, " [MENU]");
  dmd.drawString(0, SECOND_LINE, menu[menu_item]);

  while (1) { // loop forver
    if (isTimeout()) { //exit loop if timeout occured
      dmd.clearScreen();
      break;
    }

    byte this_key_press = key_press();   // read the buttons
    if (this_key_press == btnDOWN) {
      menu_item++;
      if (menu_item > MENU_COUNT - 1) menu_item = 0;
    } else if (this_key_press == btnUP) {
      menu_item--;
      Serial.println(menu_item);
      if (menu_item < 0) menu_item = MENU_COUNT - 1;
    } else if (this_key_press == btnSELECT) {
      run_selected(menu_item);
      dmd.clearScreen();
      break;
    }

    if (this_key_press != btnNONE) { //if a button is pressed
      previousMillis = millis(); // reset timeout so that the timeout will not occur
      dmd.drawString(0, SECOND_LINE, menu[menu_item]);
    }
  } //while (1)
}

//////////////////////////////////////////////////////////////////////////
// run selected menu item
//////////////////////////////////////////////////////////////////////////
void run_selected(byte menu_item) {
  dmd.clearScreen();
  switch (menu_item) {
    case SET_FONT:
      DEBUG_PRINTLN("Set Font");
      set_font();
      break;    
    case SET_BRIGHTNESS:
      DEBUG_PRINTLN("Set Brightness");
      dmd.drawString(0, FIRST_LINE, "BRIGHT");
      set_brightness();
      break;      
    case SET_DATE:
      DEBUG_PRINTLN("Set Date");
      dmd.drawString(0, FIRST_LINE, "SET DATE");
      set_date();
      break;
    case SET_TIME:
      DEBUG_PRINTLN("Set Time");
      dmd.drawString(0, FIRST_LINE, "SET TIME");
      set_time('T'); //T value indicated system time
      break;
    case SET_ALARM:
      DEBUG_PRINTLN("Set Alarm");
      dmd.drawString(0, FIRST_LINE, "SET ALARM");
      set_time('0'); //0 valude indicated Alarm0
      break;
    case SET_ENABLE_DISABLE_ALARM:
      DEBUG_PRINTLN("Disable/Enable alarm"); 
      dmd.drawString(0, FIRST_LINE, "EN ALARM"); 
      set_enable_disable_alarm();        
      break;
  }
}

