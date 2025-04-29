 % Parámetros del circuito
 R = 100; % Resistencia (ohmios)
 L = 0.1; % Inductancia (henrios)
 Cap = 1e-6; % Capacitancia (faradios)
 A = [0, 1;-1/(L*Cap),-R/L];  % Matriz de Estado
 B = [0; 1/L];                % Matriz de Entrada
 C = [1/Cap 0];               % Matriz de Salida
 D = 0;                       % Matriz de Transferencia directa

 ts = 0.015;                  % Tiempo de simulación
 tspan = [0 ts];
 u = 1;                       % V.Entrada
 x0 = [0; 0];                 % Condiciones iniciales

 [t, X] = ode45(@(t,x) modelRLC(t, x, A, B, u), tspan, x0);
 y = C * X.' + D * u;

figure;
plot(t, y);                   % Grafica V.salida
xlabel('Tiempo [s]');
ylabel('Voltaje de salida [V]');
title('Respuesta del circuito RLC usando ode45');
grid on;

function dx = modelRLC(t, x, A, B, u)
 dx = A * x + B * u;          % Ec.Estado
end