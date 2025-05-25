s = tf('s');

% Inestable oscilante
G1 = 1 / (s^2 - 0.5*s + 4);

% Inestable no oscilante
G2 = 1 / (25*s^2 - 12.5*s + 1);

step(G1, G2)
legend('Oscilante', 'No oscilante')
grid on

figure;
pzmap(G1, G2);
grid on;
legend('Inestable oscilante', 'Inestable no oscilante');
title('Mapa de polos de sistemas inestables');