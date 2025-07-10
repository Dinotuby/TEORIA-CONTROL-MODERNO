#define PIN_PULSES 2    // Canal A del encoder
#define PIN_PWM    3    // PWM al IN del EPC (driver)
#define POT_PIN    A3    // Potenciómetro conectado a A3

volatile int countPulses = 0;
float rpms = 0;
float u = 0;
unsigned long prevMillis = 0;

// === Función para convertir pulsos a RPM ===
float convertP(int pulses) {
  return (float)pulses / 36.0 / 0.05 * 60.0;  // pulsos → vueltas → RPM
}

// === ISR: conteo de flancos del encoder ===
void pulses() {
  countPulses++;
}

void setup() {
  pinMode(PIN_PULSES, INPUT_PULLUP);
  pinMode(PIN_PWM, OUTPUT);
  pinMode(POT_PIN, INPUT);

  attachInterrupt(digitalPinToInterrupt(PIN_PULSES), pulses, RISING);

  Serial.begin(115200);

  prevMillis = millis();
}

void loop() {
  unsigned long current = millis();

  if (current - prevMillis >= 50) {  // cada 50 ms
    rpms = convertP(countPulses);

    int potValue = analogRead(POT_PIN);   // 0 a 1023
    u = map(potValue, 0, 1023, 0, 125
    );   // PWM proporcional  //aqui poner el pid pract11  0.01 ti 0.01 en td

    analogWrite(PIN_PWM, (int)u);         // Aplicar PWM al motor

    Serial.print(rpms);
    Serial.print("\t");
    Serial.println(u);

    countPulses = 0;
    prevMillis = current;
  }
}
