// =========================
// === CONFIGURACIÓN DE PINES ===
// =========================
#define PIN_PULSES 2      // Entrada de pulsos del encoder (canal A), se usa para interrupción
#define PIN_PWM 3         // Salida PWM hacia el pin EN del L293D (control de velocidad del motor)
#define PIN_CTRL0 5       // Pin de control IN3 del L293D
#define PIN_CTRL1 6       // Pin de control IN4 del L293D

// =========================
// === VARIABLES GLOBALES ===
// =========================
volatile int countPulses = 0;   // Número de pulsos contados por interrupción (encoder)
float rpm_actual = 0;          // Velocidad actual del motor (calculada en RPM)
float rpm_deseada = 0;         // Valor de referencia de RPM, definida por potenciómetro A0
float salida_pwm = 0;          // Valor de la señal de control (PWM) que se aplica al motor
unsigned long t0 = 0;          // Variable de tiempo anterior (en ms)
const unsigned long intervalo = 50; // Tiempo de muestreo: 50 ms (frecuencia de 20 Hz)

// =========================
// === CONSTANTES DEL PID ===
// =========================
float Kp = 0.4;     // Ganancia proporcional
float Ti = 0.5;       // Tiempo integral (en segundos)
float Td = 0.01;   // Tiempo derivativo (en segundos)

// =========================
// === VARIABLES PID DINÁMICAS ===
// =========================
float error_actual = 0;
float error_anterior = 0;
float integral = 0;
float derivada = 0;

// =========================
// === CÁLCULO DE TIEMPO ENTRE CICLOS ===
// =========================
float dt = intervalo / 1000.0; // Tiempo de muestreo en segundos (50 ms = 0.05 s)

// =========================
// === CONVERSIÓN PULSOS → RPM ===
// =========================
float convertP(int pulsos) {
  // Fórmula: RPM = (pulsos / pulsosPorRevolución) / tiempo * 60
  return (float)(pulsos) / 36.0 / dt * 60.0;
}

// =========================
// === INTERRUPCIÓN DEL ENCODER ===
// =========================
void contarPulsos() {
  // Esta función se ejecuta automáticamente cada vez que se detecta un flanco de subida
  countPulses++;
}

// =========================
// === CONFIGURACIÓN INICIAL ===
// =========================
void setup() {
  pinMode(PIN_PULSES, INPUT_PULLUP);   // Entrada digital con resistencia pull-up para el encoder
  pinMode(PIN_PWM, OUTPUT);            // Salida PWM hacia el puente H
  pinMode(PIN_CTRL0, OUTPUT);          // Control de dirección
  pinMode(PIN_CTRL1, OUTPUT);          // Control de dirección

  attachInterrupt(digitalPinToInterrupt(PIN_PULSES), contarPulsos, RISING); // Interrupción en flanco ascendente

  // Sentido de giro fijo (ambos HIGH puede representar frenado o inversión, depende de L293D)
  digitalWrite(PIN_CTRL0, HIGH);
  digitalWrite(PIN_CTRL1, HIGH);

  Serial.begin(115200);  // Inicializa comunicación serial a 115200 baudios
}

// =========================
// === BUCLE PRINCIPAL ===
// =========================
void loop() {
  unsigned long t1 = millis();  // Tiempo actual

  if (t1 - t0 >= intervalo) {   // Si ha pasado el intervalo de muestreo (50 ms)
    rpm_actual = convertP(countPulses); // Calcula la velocidad real del motor en RPM

    // === ENTRADA: Potenciómetro en A0 define la velocidad deseada ===
    int refVal = analogRead(A0);     // Lectura analógica (0–1023)
    rpm_deseada = map(refVal, 0, 1023, 0, 6000);  // Escalado a 0–6000 RPM

    // === SIMULACIÓN DE CARGA/PERTURBACIÓN EXTERNA CON POTENCIÓMETRO EN A1 ===
    int perturbacion = analogRead(A1);  
    float carga_simulada = map(perturbacion, 0, 1023, 0, 6000); // Simulación de resistencia externa

    // === CONTROLADOR PID DIGITAL (DISCRETO) ===
    error_actual = rpm_deseada - rpm_actual;     // Diferencia entre lo deseado y lo medido
    integral += error_actual * dt;               // Acumulación del error (integral)
    derivada = (error_actual - error_anterior) / dt; // Cambio del error (derivada)

    // Fórmula del PID: P + I + D (formato clásico con tiempos Ti y Td)
    float pid_output = Kp * (error_actual + (1.0 / Ti) * integral + Td * derivada);

    // Guarda el error actual para el siguiente ciclo
    error_anterior = error_actual;

    // === APLICACIÓN DEL CONTROL Y PERTURBACIÓN ===
    salida_pwm = pid_output - carga_simulada;    // Se le resta la carga para simular una pérdida de fuerza
    salida_pwm = constrain(salida_pwm, 0, 255);   // Se limita el valor al rango PWM permitido

    analogWrite(PIN_PWM, (int)salida_pwm);       // Aplica el PWM al motor

    // === REINICIO DE VARIABLES DE TIEMPO Y PULSOS ===
    countPulses = 0;  // Reinicia el conteo de pulsos
    t0 = t1;          // Actualiza el tiempo anterior

    // === MONITOREO POR SERIAL ===
    Serial.print(",");
    Serial.print(rpm_deseada);        // Muestra la referencia
    Serial.print(" | RPM: ");
    Serial.print(rpm_actual);         // Muestra la velocidad real
    Serial.print(",");
    Serial.print(salida_pwm);         // Muestra el PWM aplicado
    Serial.print(",");
    Serial.println(carga_simulada);   // Muestra la perturbación aplicada
  }
}
