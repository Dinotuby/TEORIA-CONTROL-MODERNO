clc; clear; close all;

%% Parámetros del circuito RLC
R = 22;                % Ohmios
L = 500e-6;            % Henrios
C = 220e-6;            % Faradios

%% Función de transferencia: Vo(s)/Vi(s)
num = [1];
den = [L*C, R*C, 1];
G_RLC = tf(num, den);

%% Polos y ceros del sistema original
disp('Polos del sistema RLC:');
polos_sistema = pole(G_RLC)
disp('Ceros del sistema RLC:');
ceros_sistema = zero(G_RLC)

%% Gráfico 1: Respuesta al escalón del sistema original
figure;
step(G_RLC);
title('Figura 1. Respuesta al escalón del sistema RLC sin compensar');
grid on;

%% Gráfico 2: Lugar de las raíces del sistema original
figure;
rlocus(G_RLC);
title('Figura 2. LGR del sistema RLC sin compensar');
grid on;

%% Especificaciones de diseño
Mp = 0.25;                % 25%
tss = 50e-3;              % 50 ms

% Cálculo de ζ y ωn
zeta = -log(Mp) / sqrt(pi^2 + log(Mp)^2);
wn = 4 / (zeta * tss);

% Ecuación característica deseada
char_eq_deseada = [1, 2*zeta*wn, wn^2];
polos_deseados = roots(char_eq_deseada);
disp('Polos deseados del sistema:');
disp(polos_deseados);

%% Gráfico 3: LGR del sistema original con polos deseados
figure;
rlocus(G_RLC);
hold on;
plot(real(polos_deseados), imag(polos_deseados), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('Figura 3. LGR con polos deseados - Sistema original');
legend('LGR','Polos deseados');
grid on;

%% Diseño del compensador en adelanto
% Colocamos un cero en el polo más alejado del sistema original
zero_compensador = real(polos_sistema(1));  % cancelación
p1 = real(polos_sistema(2));
p2 = real(polos_sistema(1));

% Cálculo del ángulo θ requerido
theta4 = pi - atan(imag(polos_deseados(1)) / -(p1 - real(polos_deseados(1))));

% Cálculo del nuevo polo (adelantado)
polo_compensador = imag(polos_deseados(1)) / tan(pi - theta4) + real(polos_deseados(1));

disp(['Cero del compensador = ', num2str(zero_compensador)]);
disp(['Polo del compensador = ', num2str(polo_compensador)]);

%% Gráfico 4: Polos y ceros del sistema original + compensador + polos deseados
figure;
rlocus(G_RLC);
hold on;
plot(real(polos_deseados), imag(polos_deseados), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
plot(-zero_compensador, 0, 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot(-polo_compensador, 0, 'bo', 'MarkerSize', 10, 'LineWidth', 2);
title('Figura 4. LGR con compensador y polos deseados');
legend('LGR','Polos deseados','Cero compensador','Polo compensador');
grid on;

%% Construcción del compensador
num_comp = [1, -zero_compensador];
den_comp = [1, -polo_compensador];
G_compensador = tf(num_comp, den_comp);

% Sistema en lazo abierto con compensador (sin ganancia aún)
G_total_abierto = series(G_RLC, G_compensador);

%% Cálculo de Kc para ubicar los polos deseados
s_eval = polos_deseados(1);
Kc = 1 / abs(evalfr(G_total_abierto, s_eval));
disp(['Kc calculado = ', num2str(Kc)]);

% Compensador con ganancia
G_total_con_Kc = feedback(Kc * G_total_abierto, 1);

%% Gráfico 5: Respuesta al escalón del sistema compensado
figure;
step(G_total_con_Kc);
title('Figura 5. Respuesta al escalón del sistema RLC compensado');
grid on;

%% Gráfico 6: LGR del sistema compensado completo
figure;
rlocus(Kc * G_total_abierto);
hold on;
plot(real(polos_deseados), imag(polos_deseados), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
title('Figura 6. LGR del sistema RLC compensado con Kc');
legend('LGR','Polos deseados');
grid on;

%% Validación final
info = stepinfo(G_total_con_Kc);
fprintf('\n--- Desempeño del sistema compensado ---\n');
fprintf('Overshoot: %.2f %%\n', info.Overshoot);
fprintf('Tiempo de establecimiento: %.4f s\n', info.SettlingTime);
%% Figura 7: Polos y ceros del sistema completo
figure;
pzmap(G_total_con_Kc); 
hold on;
plot(real(polos_deseados), imag(polos_deseados), 'rx', 'MarkerSize', 10, 'LineWidth', 2); % polos deseados
plot(-zero_compensador, 0, 'go', 'MarkerSize', 10, 'LineWidth', 2); % cero
plot(-polo_compensador, 0, 'bo', 'MarkerSize', 10, 'LineWidth', 2); % polo
title('Figura 7. Polos y ceros: sistema, compensador y deseados');
legend('Polos del sistema','Polos deseados','Cero compensador','Polo compensador');
grid on;

%% Figura 8: LGR del sistema compensado en lazo cerrado
% Esta gráfica es similar al LGR compensado, pero confirmando cierre del lazo
figure;
rlocus(Kc * G_total_abierto);
hold on;
pz = pole(G_total_con_Kc);
plot(real(pz), imag(pz), 'ms', 'MarkerSize', 10, 'LineWidth', 2); % Polos reales del sistema en lazo cerrado
title('Figura 8. LGR del sistema compensado en lazo cerrado');
legend('LGR','Polos lazo cerrado');
grid on;
