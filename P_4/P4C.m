% Parámetros del circuito
R = 100; % Resistencia (ohmios)
L = 0.1; % Inductancia (henrios)
Cap = 1e-6; % Capacitancia (faradios)
A = [0, 1; -1/(L*Cap), -R/L];
B = [0; 1/L];
C = [1/Cap, 1];
D = 0;

% Generar la señal arbitraria (a trozos)
% Vectores que separan los dominios de la función a trozos
x1 = linspace(0, 0.010, 100); % 100 puntos para el primer segmento
x2 = linspace(0.010, 0.020, 100); % 100 puntos para el segundo segmento
x3 = linspace(0.020, 0.030, 100); % 100 puntos para el tercer segmento
x4 = linspace(0.030, 0.040, 100); % 100 puntos para el cuarto segmento
x5 = linspace(0.040, 0.050, 100);
x6 = linspace(0.050, 0.060, 100);
% Vectores de los valores en el rango de sus respectivos dominios
y1 = zeros(length(x1), 1);
y2 = ((500)*x2 - 5) ;
y3 = 10 * ones(length(x3),1);
y4 = -500 * x4 + 25, 1;
y5 = 5 * ones(length(x5),1);
y6 = 5 * zeros(length(x5),1);
y2 = y2'
y4 = y4'

% Función a trozos
x_arb = linspace(0, 0.060, 600); % Concatenamos todos los vectores de tiempo
y_arb = [y1; y2; y3; y4; y5;y6];   % Concatenamos todos los vectores de la señal

N = length(x_arb);  % Longitud del vector de entrada

% Inicializar la respuesta del sistema
x = zeros(N, 2);  % Estado del sistema (posición y velocidad)
t = zeros(N, 1);  % Tiempo

% Condiciones iniciales
x0 = [0; 0];  % Estado inicial

% Simulación de la respuesta del sistema
for k = 2:N  % Iterar sobre cada intervalo de tiempo
    % Resolver la ecuación diferencial para el intervalo [x_arb(k-1), x_arb(k)]
    [tk, Xk] = ode45(@(t, x) modelRLC(t, x, A, B, y_arb(k)), [x_arb(k-1), x_arb(k)], x(k-1, :));
    
    % Almacenar el tiempo final y el estado final
    t(k) = tk(end);  % Tiempo final del intervalo
    x(k, :) = Xk(end, :);  % Estado final en el intervalo
end

% Calcular la salida del sistema (voltaje en el capacitor)
y_output = C * x.';  % Salida del sistema

% Graficar los resultados
figure;

% Subgráfico 1: Graficar la señal arbitraria de entrada
plot(x_arb, y_arb, 'LineStyle', '--', 'LineWidth', 1.5);
hold on;
plot(t, y_output, 'LineWidth', 1.5);  % Respuesta del sistema
ylabel('Voltaje [V]');
title('Señal Arbitraria de Entrada y Respuesta del Sistema');
legend('Señal Arbitraria', 'Respuesta del Sistema');
grid on;


% Función para el modelo RLC en espacio de estados
function dx = modelRLC(t, x, A, B, u)
    dx = A * x + B * u;  % Ecuación de estado
end