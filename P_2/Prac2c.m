% Sistema con retardo
num = 3;
den = [1 2 3];
theta = 2;
Gs = tf(num, den, 'InputDelay', theta);

t = 0:0.1:50;  % Tiempo total

constante_5 = 5 * (heaviside(t - 10) - heaviside(t - 20));

% Rampa de 15 a 25 entre 20 y 30 segundos
rampa = ((t - 20) * 1 + 15);  % Rampa lineal, pendiente = 1
rampa = rampa .* (heaviside(t - 20) - heaviside(t - 30));  % Activar solo entre 20 y 30 segundos

% Constante 25 desde t >= 30
constante_25 = 25 * (heaviside(t - 30));

signal = constante_5 + rampa  + constante_25;
% Simular respuesta
[y, t_out] = lsim(Gs, signal, t);

% Graficar entrada y respuesta
figure;
plot(t, signal, 'b--', 'LineWidth', 2, 'DisplayName', 'Señal de Entrada');
hold on;
plot(t_out, y, 'r', 'LineWidth', 2, 'DisplayName', 'Respuesta del Sistema');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Entrada vs Respuesta del Sistema (con retardo)');
legend;
grid on;
