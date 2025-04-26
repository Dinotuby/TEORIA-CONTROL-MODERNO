num = 3;
den = [1 2 3];
theta = 2;
G = tf(num, den,'InputDelay', theta);

% 2. Respuesta al ESCALÓN
[y_step, t_step] = step(G);
figure();
plot(t_step, y_step, 'b', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Respuesta al Escalón con Retardo');
grid on;

% 3. Marcar el valor máximo en la respuesta al escalón
[max_step, idx_step] = max(y_step);
t_max_step = t_step(idx_step);
hold on;
plot(t_max_step, max_step, 'ko', 'MarkerFaceColor', 'g');
legend('Respuesta al escalón', 'Máximo');

% 4. Respuesta al IMPULSO
[y_imp, t_imp] = impulse(G);
figure();
plot(t_imp, y_imp, 'r', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Respuesta al Impulso con Retardo');
grid on;

% 5. Marcar el valor máximo en la respuesta al impulso
[max_imp, idx_imp] = max(y_imp);            % valor máximo en la respuesta al impulso
t_max_imp = t_imp(idx_imp);                 % tiempo en el que ocurre ese máximo
hold on;                    
plot(t_max_imp, max_imp, 'ko', 'MarkerFaceColor', 'm');% marcarlo en la gráfica
legend('Respuesta al impulso', 'Máximo');

% 6. Verificar tiempo de inicio de respuesta (considerando umbral)
umbral = 1e-3;

% Tiempo de inicio - ESCALÓN
idx_ini_step = find(y_step > umbral, 1);
t_ini_step = t_step(idx_ini_step);

% Tiempo de inicio - IMPULSO
idx_ini_imp = find(y_imp > umbral, 1);
t_ini_imp = t_imp(idx_ini_imp);

% Mostrar en consola
fprintf('--- ANÁLISIS DE RESPUESTAS ---\n');
fprintf('Tiempo de inicio (escalón): %.2f s\n', t_ini_step);
fprintf('Valor máximo (escalón): %.4f en t = %.2f s\n', max_step, t_max_step);
fprintf('\n');
fprintf('Tiempo de inicio (impulso): %.2f s\n', t_ini_imp);
fprintf('Valor máximo (impulso): %.4f en t = %.2f s\n', max_imp, t_max_imp);
