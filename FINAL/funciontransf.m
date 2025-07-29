clc; clear; close all;

% === 1. Cargar datos del CSV ===
data = readtable('datos_arduino.csv');  % Cambia al nombre real de tu archivo

% Asumiendo nombres de columnas
velocidad = data.Velocidad;     % Salida del sistema (RPM)
setpoint = data.Setpoint;       % Referencia
pwm = data.PWM;                 % Entrada del sistema (PWM)

% === 2. Definir tiempo de muestreo ===
Ts = 0.05;   % 50 ms

% === 3. Crear objeto de datos de identificación ===
% Se asume que PWM es la entrada (u) y velocidad es la salida (y)
datos_id = iddata(velocidad, pwm, Ts);

% === 4. Estimar una función de transferencia discreta ===
% Puedes ajustar el orden (número de ceros y polos). Aquí se usa orden (2,2)
modelo_estimado = tfest(datos_id, 2, 2);  

% Mostrar la función estimada
disp('Función de transferencia estimada:')
modelo_estimado

% === 5. Simular la salida estimada y compararla con la real ===
figure;
compare(datos_id, modelo_estimado);
title('Comparación entre salida real y estimada');

% === 6. Graficar respuesta al escalón del modelo ===
figure;
step(modelo_estimado);
title('Respuesta al escalón del sistema estimado');


