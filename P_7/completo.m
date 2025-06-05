% Numerador y denominador de la función de transferencia
num = [1 3];
den = [1 5 20 16 0];

% Cálculo de ceros y polos
zs = roots(num);
ps = roots(den);

% Gráfica de polos (x) y ceros (o)
figure
v = [-6 6 -6 6]; 
axis(v); axis square;
hold on; grid on;
plot(real(zs), imag(zs), 'bo', 'LineWidth', 2); % Ceros (azul)
plot(real(ps), imag(ps), 'rx', 'LineWidth', 2); % Polos (rojo)
title('Polos y Ceros de la Función de Transferencia');

% Centro de las asíntotas
sigma0 = -2/3;

% Barrido de x para dibujar las rectas con ±60°
x = sigma0:0.1:6;
y1 = sqrt(3) * (x - sigma0);  % Pendiente +60°
y2 = -y1;                     % Pendiente -60°

% Recta horizontal (ángulo 0°)
xa = -6:0.1:sigma0;
ya = zeros(1, length(xa));

% Gráfico
plot(x, y1, 'k-.');     % Asíntota +60°
plot(x, y2, 'k-.');     % Asíntota -60°
plot(xa, ya, 'k-.');    % Asíntota 180°

% Función de transferencia
G = tf(num, den);

% LGR automático con rlocus
figure
rlocus(G)
title('Lugar Geométrico de las Raíces (MATLAB)');
grid on

% Polinomio obtenido al derivar K y anular la derivada
% 3s^4 + 22s^3 + 65s^2 + 120s + 48 = 0
coef = [3 22 65 120 48];

% Raíces reales: posibles puntos de llegada
roots(coef)

% Polinomio: s^4 + 5s^3 + 20s^2 + (16+K)s + 3K = 0
% Se analiza para obtener el valor de K marginalmente estable

% Coeficientes simbólicos
syms K
a0 = 1; 
a1 = 5;
a2 = 20;
a3 = 16 + K;
a4 = 3*K;

% Tabla de Routh simplificada (solo los elementos claves)
b1 = (a1*a2 - a0*a3) / a1;
c1 = (a1*a4 - a0*0) / a1;
d1 = (b1*c1 - a1*a4) / b1;

% Ecuación para marginalmente estable
eq = K^2 + 7*K - 1344;
sol = solve(eq, K);

% Reemplazar valor de K = 33.3273
K = 33.3273;
a3 = 16 + K;
a4 = 3 * K;

% Polinomio con K insertado
num = [1 5 20 a3 a4];

% Raíces para ver cruce en eje imaginario
roots(num)
