s = tf('s');
wn = 5;

% Sistemas
G1 = wn^2 / (s^2 + wn^2);               % No amortiguado
G2 = wn^2 / (s^2 + 2*0.3*wn*s + wn^2);  % Subamortiguado
G3 = wn^2 / (s^2 + 2*wn*s + wn^2);      % Críticamente amortiguado
G4 = wn^2 / (s^2 + 2*2*wn*s + wn^2);    % Sobreamortiguado

% Definir vector de tiempo fijo: de 0 a 10 segundos
t = 0:0.01:10;

% Ahora sí: usar step con 4 sistemas y tiempo definido
step(G1, G2, G3, G4, t)
legend('No amortiguado', 'Subamortiguado', 'Críticamente amortiguado', 'Sobreamortiguado')
title('Respuestas al escalón de sistemas de segundo orden')
xlabel('Tiempo (s)')
ylabel('Amplitud')
grid on


figure;
pzmap(G1, G2, G3, G4);
grid on;
legend('No amortiguado', 'Subamortiguado', 'Críticamente amortiguado', 'Sobreamortiguado')
title('Mapa de polos de sistemas de segundo orden')
