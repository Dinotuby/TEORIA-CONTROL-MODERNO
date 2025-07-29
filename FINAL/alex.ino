#define PIN_PULSES 2
#define PIN_PWM    3
#define PIN_IN1    5
#define PIN_IN2    6

volatile int countPulses = 0;
float rpm_actual = 0;

const unsigned long intervalo = 20;
const unsigned long duracionExperimento = 10000;  // 10 segundos
unsigned long t0 = 0;
unsigned long tiempoInicio = 0;
bool capturando = false;

float convertP(int pulsos) {
  return (float)(pulsos) / 240.0 / (intervalo / 1000.0) * 60.0;
}

void contarPulsos() {
  countPulses++;
}

void setup() {
  pinMode(PIN_PULSES, INPUT_PULLUP);
  pinMode(PIN_PWM, OUTPUT);
  pinMode(PIN_IN1, OUTPUT);
  pinMode(PIN_IN2, OUTPUT);

  attachInterrupt(digitalPinToInterrupt(PIN_PULSES), contarPulsos, RISING);

  digitalWrite(PIN_IN1, HIGH);
  digitalWrite(PIN_IN2, LOW);
  analogWrite(PIN_PWM, 0); // Apagado al inicio

  Serial.begin(115200);
}

void loop() {
  if (Serial.available() > 0) {
    char comando = Serial.read();
    if (comando == 'S' && !capturando) {
      capturando = true;
      tiempoInicio = millis();
      t0 = tiempoInicio;
      analogWrite(PIN_PWM, 150);  // Aplicar PWM
    }
  }

  if (capturando && millis() - t0 >= intervalo) {
    unsigned long tiempoRelativo = millis() - tiempoInicio;

    if (tiempoRelativo <= duracionExperimento) {
      rpm_actual = convertP(countPulses);
      Serial.print(tiempoRelativo / 1000.0, 3);  // tiempo en segundos
      Serial.print(",");
      Serial.println(rpm_actual);
    } else {
      analogWrite(PIN_PWM, 0);  // Detener motor
      capturando = false;
      Serial.println("FIN");
    }

    countPulses = 0;
    t0 = millis();
  }
}
