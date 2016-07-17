/*
       Arduino AD0
            |
  VCC---2K2---470---1k---
            |     |     |   
           Up   Down  Select  
          (SW1) (SW2) (SW3) 
            |     |     |    
  Gnd--------------------
*/

//////////////////////////////////////////////////////////////////////////
//  multiple buttons on 1 analog pin
//////////////////////////////////////////////////////////////////////////
byte read_buttons() {            
  int adc_key_in = analogRead(0);  // read the value from Analog0

  //value read: 0(SW1),180(SW2), 410(SW3), 1023(OPEN)
  if (adc_key_in > 1000) return btnNONE;
  if (adc_key_in < 75)  return btnUP;
  if (adc_key_in < 250)  return btnDOWN;
  if (adc_key_in < 600)  return btnSELECT;
  return btnNONE;
}

//////////////////////////////////////////////////////////////////////////
// debounce a button: a single press doesn't appear like multiple presses
//////////////////////////////////////////////////////////////////////////
int counter = 0;       // how many times we have seen new value
long previous_time = 0;    // the last time the output pin was sampled
byte debounce_count = 10; // number of millis/samples to consider before declaring a debounced input
byte current_state = 0;   // the debounced input value

byte  key_press(){
  // If we have gone on to the next millisecond
  if(millis() != previous_time)
  {
    byte this_button = read_buttons();

    if(this_button == current_state && counter > 0) counter--;

    if(this_button != current_state) counter++; 

    // If the Input has shown the same value for long enough let's switch it
    if(counter >= debounce_count) {
      counter = 0;
      current_state = this_button;
      return this_button;
    }
    previous_time = millis();
  }
  return 0;
}

