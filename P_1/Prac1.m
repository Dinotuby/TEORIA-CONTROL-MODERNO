data = readtable('C:\Users\PROBOOK\Desktop\Universidad\sexto semestre\Teoria Control\Practicas\data_motor.csv', 'VariableNamingRule', 'preserve');
disp(data.Properties.VariableNames);    % Verificar los nombres de las variables

time = data{:, 2};                      % Primer columna: tiempo
ex_signal_u = data{:, 3};               % Segunda columna: señal de excitación u(t)
system_response_y = data{:, 4};         % Tercera columna: respuesta del sistema y(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1 = time(12);                          % Tiempo en el elemento 12
t2 = time(26);                          % Tiempo en el elemento 26
y1 = system_response_y(12);             % Respuesta en el elemento 12
y2 = system_response_y(26);             % Respuesta en el elemento 26
m = (y2 - y1) / (t2 - t1);              % Pendiente
y_tangent = m * (time- t1) + y1;        % Ec. Rtang y - y1 = m * (x - t1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
promedio_estabilidad = mean(system_response_y(time > time(36)));                % Línea 100% (Resp.Promedio desde >tiempo(36)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = (promedio_estabilidad - system_response_y(1)) / (ex_signal_u(end) - ex_signal_u(1));    %Ganancia K
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
O = t1-(y1 / m) ; % Ec. Corte y=0
C = (promedio_estabilidad - y1) / m + t1; % Ec. corte y=Linea100%

disp(['La pendiente es ', num2str(m)]);
disp(['El corte de la tangente con el eje y = 0 ocurre en t = ', num2str(O), ' segundos.']);
disp(['El corte de la tangente con la línea del 100% ocurre en t = ', num2str(C), ' segundos.']);
disp(['El valor calculado de K es: ', num2str(K)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_Ziegler = O;
tau_Ziegler = C - theta_Ziegler;
disp(['θ Ziegler: ', num2str(theta_Ziegler)]);
disp(['τ Ziegler: ', num2str(tau_Ziegler)]);
%-----------------------------------------------------------------------------------------------------------
t_63_21 = 0.6321 * promedio_estabilidad;                    %Calculo del 63.21 del deltaY
t_6321 = find(system_response_y >= t_63_21, 1, 'first');    %1er valor mas cercano
t6321 = time(t_6321);                                       %Conversion a tiempo
tau_Miller = t6321 - theta_Ziegler;
disp(['θ Miller:', num2str(theta_Ziegler)]);
disp(['τ Miller: ', num2str(tau_Miller)]);
%-----------------------------------------------------------------------------------------------------------¿
% Escribimos el sistema de ecuaciones de la forma Ax = B
A = [1, 1; 1, 1/3];         % A= matriz coef de θ y τ

% Definir los valores de salida objetivo
y_63 = 0.6321 * promedio_estabilidad;
y_28 = 0.284 * promedio_estabilidad;

% Encontrar los tiempos en los que la respuesta del sistema se aproxima a estos valores
idx_63 = find(system_response_y >= y_63, 1, 'first');  
idx_28 = find(system_response_y >= y_28, 1, 'first'); 

% Obtener los tiempos correspondientes
t_63 = time(idx_63);
t_28 = time(idx_28);

B = [t_63; t_28];           %Coef. LD de las Ec
sol = A \ B;  % Resolvemos el sistema Ax = B (θ y τ)
theta_analitico = sol(1); % θ
tau_analitico = sol(2);   % τ
disp(['θ Analítico: ', num2str(theta_analitico)]);
disp(['τ Analítico: ', num2str(tau_analitico)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definir la función de transferencia FOTD
G = tf(K, [tau_Ziegler 1], 'InputDelay', theta_Ziegler); 
GM = tf(K, [tau_Miller 1], 'InputDelay', theta_Ziegler); 
GA = tf(K, [tau_analitico 1], 'InputDelay', theta_analitico); 

%[response] = lsim(G, ex_signal_u, time);        % Salida simulada usando 'ex_signal_u' y 'time'
[responseM] = lsim(GM, ex_signal_u, time);      % "         "
[responseA] = lsim(GA, ex_signal_u, time);      % "         "
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crear el gráfico
figure;                                                 % Crea una nueva figura
plot(time, ex_signal_u, 'c', 'LineWidth', 1.5);         % Señal de excitación (u(t))
hold on;                                                % Mantener Graf para agregar la Resp

plot(time, system_response_y, 'r', 'LineWidth', 1.5);   % Resp del sistema (y(t))
plot(time, y_tangent, 'g--', 'LineWidth', 1.5);         % Línea Tangente
yline(promedio_estabilidad, 'm--', 'LineWidth', 1.5);   % Línea 100%
plot(time, response, 'g', 'LineWidth', 1.5);            %Ziegler
plot(time, responseM, 'b', 'LineWidth', 1.5);           %Miller
plot(time, responseA, 'k', 'LineWidth', 1.5);           %Analitico
title('Excitación y Respuesta del Sistema');            % Título
xlabel('Tiempo (s)');                                   % Etiqueta eje x
ylabel('Amplitud');                                     % Etiqueta eje y
legend('Señal de excitación u(t)', 'Respuesta del sistema y(t)', 'Recta tangente', 'Línea 100%',' Ziegler','Miller','Analitico','Location', 'Best'); % Leyenda
grid on;                                                % Activar la cuadrícula
xlim([0, 5]);                                           % Rango eje X (tiempo,0 a 10)
ylim([-0.5, 2]);                                        % Rango del eje Y (amplitud 0 a 1.2)

hold off; % Liberar la figura para futuros gráficos