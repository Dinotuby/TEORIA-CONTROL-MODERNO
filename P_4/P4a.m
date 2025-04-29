 % Parámetros del circuito
 R = 100;                   % Resistencia (ohmios)
 L = 0.1;                   % Inductancia (henrios)
 Cap = 1e-6;                % Capacitancia (faradios)
 A = [0, 1;-1/(L*Cap),-R/L];% Matriz de Estado
 B = [0; 1/L];              % Matriz de Entrada
 C = [0 1];                 % Matriz de Salida
 D = 0;                     % Matriz de Transferencia directa

 sys = ss(A,B,C,D);
 subplot(2,1,1);
 step(sys);
 xlabel('Time [s]'); ylabel('Vc [V]');
 subplot(2,1,2);
 impulse(sys);
 xlabel('Time [s]'); ylabel('Vc [V]');