% Parámetros del circuito RLC
R = 5;
L = 0.1;
C = 220e-6;

% PID
Kp = 10;
Ki = 1000;
Kd = 0.01;

% Funciones de transferencia
s = tf('s');
H_rlc = 1 / (L*C*s^2 + R*C*s + 1);  % Planta RLC
PID = Kp + Ki/s + Kd*s;             % Controlador PID

% Lazo abierto y cerrado
open_loop = series(PID, H_rlc);
closed_loop = feedback(open_loop, 1);

% Mostrar función de transferencia
disp('FT en lazo cerrado:');
closed_loop


% Revisar estabilidad con polos
disp('Polos del sistema:');
disp(pole(closed_loop));

% Graficar
figure;
subplot(2,1,1);
step(closed_loop);
title('Respuesta al escalón');

subplot(2,1,2);
pzmap(closed_loop);
title('Mapa de Polos y Ceros');
grid on;
