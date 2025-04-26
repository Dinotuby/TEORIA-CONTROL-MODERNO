% Sistema con retardo
num = 3;
den = [1 2 3];
theta = 2;
Gs = tf(num, den, 'InputDelay', theta);

t = 0:0.1:80;  % Tiempo extendido de 0 a 80 segundos

% 1. De 0 a 5 segundos: Constante en 0
constante_0 = 0 * (t < 5);
% 2. De 5 a 10 segundos: Rampa de 0 a 5
rampa_0_5 = (5 / 5) * (t - 5) .* (heaviside(t - 5) - heaviside(t - 10));  % Rampa de 0 a 5
% 3. De 10 a 20 segundos: Constante en 5
constante_5 = 5 * (heaviside(t - 10) - heaviside(t - 20));
% 4. De 20 a 30 segundos: Constante en 10
constante_10 = 10 * (heaviside(t - 20) - heaviside(t - 30));
% 5. De 30 a 50 segundos: Rampa descendente de 25 a 15
rampa_25_15 = -0.5 * (t - 30) + 25;  % Rampa de 25 a 15 con pendiente negativa
rampa_25_15 = rampa_25_15 .* (heaviside(t - 30)-heaviside(t - 50));  % Limitar entre t=30 y t=50
constante_15 = 15 * (heaviside(t - 50) - heaviside(t - 60));
constante_0_final = 0 * heaviside(t - 60);  % Opcional

% Señal total
signal = constante_0 + rampa_0_5 + constante_5 + constante_10 + rampa_25_15+constante_15+constante_0_final;


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
