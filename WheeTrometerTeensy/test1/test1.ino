long int CPU_MARK;
long int CPU_CYCS;
int trig = 22;

int US_Tx_PINs = 2;
int US_Tx_PIN[] = {4,5};
uint32_t US_Tx_Freq[] = {40000, 40100};

int loop_count = 0;
void setup() {
  pinMode(trig, OUTPUT); // pin 3 to trigger oscilloscope
  ARM_DEMCR |= ARM_DEMCR_TRCENA;
  ARM_DWT_CTRL |= ARM_DWT_CTRL_CYCCNTENA;
  for (int i = 0; i < US_Tx_PINs; i++) {
    analogWriteFrequency(US_Tx_PIN[i], US_Tx_Freq[i]);
    analogWrite(US_Tx_PIN[i], 128);
  }
  Serial.begin(9600);
}

void loop() {
  loop_count++;
//  if (Serial.available()) {
    Serial.println(Serial.read());
    //digitalWriteFast(6, HIGH);
    digitalWriteFast(trig, HIGH);
   FLEXPWM2_SM0CTRL2 |= FLEXPWM_SMCTRL2_FRCEN | FLEXPWM_SMCTRL2_FORCE; // pin 22
    FLEXPWM2_SM1CTRL2 |= FLEXPWM_SMCTRL2_FRCEN | FLEXPWM_SMCTRL2_FORCE; // pin 23
    delayMicroseconds(10);
    digitalWriteFast(trig, LOW);
    delay(1000);
//  }
  if (loop_count % 500000 == 0) {
    Serial.println(loop_count);
  }
}
