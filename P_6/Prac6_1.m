clc; clear; close all;

% Definir la función de transferencia: G(s) = 1/(2s + 1)
num = 1;
den = [2 1];
Gs = tf(num, den);

% Obtener la respuesta al escalón
[y, t] = step(Gs);

% Calcular constante de tiempo
tau = den(1);             % En este caso, τ = 2
t_4tau = 4 * tau;         % Tiempo estimado para alcanzar el 98% del valor final

% Buscar valor aproximado en ese instante
[~, idx] = min(abs(t - t_4tau));
y_4tau = y(idx);
y_final = y(end);

% Mostrar en consola
fprintf('Constante de tiempo τ = %.2f s\n', tau);
fprintf('t = 4τ = 4 * %.2f = %.2f s\n', tau, t_4tau);
fprintf('Valor de la respuesta en t = 4τ: %.4f\n', y_4tau);
fprintf('Valor final aproximado: %.4f\n', y_final);

% Calcular y mostrar los polos
p = roots(den);
fprintf('Polos del sistema: %.4f\n', p);

% Graficar la respuesta
figure;
plot(t, y, 'LineWidth', 1.8); hold on;
grid on;
xlabel('Tiempo (s)');
ylabel('y(t)');
title('Respuesta al escalón del sistema G(s)');

% Línea vertical en t = 4τ
plot([t_4tau t_4tau], [0 y_final], 'r--', 'LineWidth', 1.2);
text(t_4tau, 0.7*y_final, 't = 4\tau', 'Color', 'r', 'FontSize', 12);

legend('Respuesta al escalón', 't = 4\tau', 'Location', 'southeast');
