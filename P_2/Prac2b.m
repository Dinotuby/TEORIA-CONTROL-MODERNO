
% Sistema de segundo orden con retardo
num = 3;
den = [1 2 3];
theta = 2;  % Tiempo muerto (retardo)
Gs = tf(num, den, 'InputDelay', theta);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = 0:0.1:30;  % Tiempo de 0 a 50 segundos (ajustalo según sea necesario)
rampa = t;            % Rampa lineal con pendiente 1

% La señal total es la suma de los dos escalones
signal = 5 * (heaviside(t - 10)) + 5 * (heaviside(t - 20));

% Simulación de la respuesta
[y, t_out] = lsim(Gs, signal, t);  % Calcula la respuesta del sistema a la señal

figure;  % Crear una nueva figura
plot(t, signal, 'LineWidth', 1.5, 'DisplayName', 'Señal de Entrada Escalón');  % Graficar la señal de entrada
hold on;  % Mantener la misma figura para la siguiente gráfica
plot(t_out, y, 'LineWidth', 1.5, 'DisplayName', 'Respuesta del Sistema');  % Graficar la respuesta del sistema
% Etiquetas y título
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal de Entrada y Respuesta del Sistema');
legend show;  % Mostrar leyenda
grid on;