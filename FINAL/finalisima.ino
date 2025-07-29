// === Pines del sistema ===
const int encoderA = 2;     // Pin de entrada para canal A del encoder (interrupción externa)
const int IN3 = 5;          // Pin de dirección del motor (L293D o similar)
const int IN4 = 6;          // Pin de dirección del motor (para giro contrario)
const int ENB = 3;          // Pin de salida PWM para controlar velocidad del motor

// === Variables del encoder ===
volatile int contador = 0;             // Contador de pulsos del encoder (acumulado entre muestras)
float velocidadRPM = 0;                // Velocidad calculada en RPM
const float pulsosPorVuelta = 240;     // Pulsos generados por una vuelta completa (según el encoder)

// === Ganancias PID (inicializadas a 0) ===
float Kp = 0;      // Ganancia proporcional
float Ki = 0;      // Ganancia integral
float Kd = 0;      // Ganancia derivativa
float Tm = 0.05;   // Tiempo de muestreo en segundos (50 ms)

// === Estado interno del PID (errores y controladores previos) ===
float error = 0;    // Error actual
float error1 = 0;   // Error anterior
float error2 = 0;   // Error dos muestras atrás
float cv = 0;       // Señal de control actual (PWM)
float cv1 = 0;      // Señal de control anterior

int setpoint = 120; // Velocidad deseada en RPM (puedes cambiar esto para probar distintos casos)

// === Temporización ===
unsigned long ultimoTiempo = 0;   // Para controlar el tiempo de muestreo en el loop principal

// === Configuración inicial ===
void setup() {
  pinMode(IN3, OUTPUT);             // Configura pin de dirección como salida
  pinMode(IN4, OUTPUT);             // Configura pin de dirección como salida
  pinMode(ENB, OUTPUT);             // Configura pin de PWM como salida
  pinMode(encoderA, INPUT_PULLUP);  // Entrada con resistencia pull-up para evitar ruido

  attachInterrupt(digitalPinToInterrupt(encoderA), contarPulsos, RISING); // Interrupción por flanco de subida

  Serial.begin(115200);             // Inicializa puerto serial para enviar datos

  delay(2000);                      // Espera 2 segundos para estabilizar todo
  Serial.println("Velocidad,Setpoint,PWM"); // Cabecera del CSV para facilitar lectura en MATLAB
}

// === Bucle principal ===
void loop() {
  unsigned long tiempoActual = millis();  // Tiempo actual en milisegundos

  // Ejecutar control cada Tm segundos
  if (tiempoActual - ultimoTiempo >= Tm * 1000) {

    // === Medición de velocidad ===
    noInterrupts();               // Desactivar interrupciones temporalmente para leer contador
    int pulsos = contador;        // Copiar número de pulsos
    contador = 0;                 // Reiniciar contador
    interrupts();                 // Activar interrupciones nuevamente

    // Calcular velocidad en RPM: (pulsos/vuelta) * (tiempo en un minuto / tiempo de muestreo)
    velocidadRPM = ((float)pulsos / pulsosPorVuelta) * (60000.0 / (Tm * 1000.0));

    // === Selección de parámetros PID según el setpoint ===
    if (setpoint < 40) {
      Kp = 0.8;
      Ki = 2.5;
      Kd = 0.008;
    } else {
      Kp = 0.4;
      Ki = 3.08;
      Kd = 0.001;
    }

    // === PID discreto (forma trapezoidal / Tustin) ===
    error2 = error1;                          // Desplazar errores antiguos
    error1 = error;                           // Guardar error anterior
    error = setpoint - velocidadRPM;          // Calcular nuevo error

    // Fórmula PID discreta con anti-windup implícito
    cv = cv1 + (Kp + Kd / Tm) * error +
         (-Kp + Ki * Tm - 2 * Kd / Tm) * error1 +
         (Kd / Tm) * error2;

    cv1 = cv;                                 // Guardar valor anterior de control

    cv = constrain(cv, 0, 255);               // Limitar la señal de control al rango válido del PWM

    // === Control del motor ===
    digitalWrite(IN3, HIGH);                  // Fijar dirección del motor
    digitalWrite(IN4, LOW);                   // Fijar dirección del motor contraria apagada
    analogWrite(ENB, (int)cv);                // Aplicar PWM para controlar velocidad

    // === Enviar datos al puerto serial en formato CSV ===
    Serial.print(velocidadRPM); Serial.print(",");
    Serial.print(setpoint); Serial.print(",");
    Serial.println(Kp);  // Puedes cambiar esto a 'cv' si prefieres exportar el PWM real

    // Actualizar referencia de tiempo
    ultimoTiempo = tiempoActual;
  }
}

// === Función de interrupción para contar pulsos del encoder ===
void contarPulsos() {
  contador++;   // Incrementar contador en cada flanco de subida
}
