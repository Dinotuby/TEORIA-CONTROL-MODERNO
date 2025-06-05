%% Taller 7 - Lugar Geométrico de las Raíces
clc; clear; close all;

%% 1. Definir función de transferencia
num = [1 3];
den = [1 5 20 16 0];

G = tf(num, den);

% Cálculo de polos y ceros
zs = roots(num);
ps = roots(den);

%% 2. Graficar Polos y Ceros
figure
v = [-6 6 -6 6]; 
axis(v); axis square;
hold on; grid on;

plot(real(zs), imag(zs), 'bo', 'LineWidth', 2, 'DisplayName','Ceros');
plot(real(ps), imag(ps), 'rx', 'LineWidth', 2, 'DisplayName','Polos');

%% 3. Trazar Asíntotas
n = length(ps); 
m = length(zs);
sigma0 = sum(real(ps)) - sum(real(zs));
sigma0 = sigma0 / (n - m);

% Generar líneas
x = sigma0:0.1:6;
y1 = sqrt(3) * (x - sigma0);
y2 = -y1;

% Punto central (sigma0)
plot(sigma0, 0, 'go', 'MarkerSize', 8, 'DisplayName','Punto partida asíntotas');

% Eje horizontal (asíntota a 180°)
xa = -6:0.1:sigma0;
ya = zeros(size(xa));

plot(x, y1, 'k-.', 'DisplayName','Asíntota +60°');
plot(x, y2, 'k-.', 'DisplayName','Asíntota -60°');
plot(xa, ya, 'k-.', 'DisplayName','Asíntota 180°');

%% 4. Cruce de asíntotas con eje imaginario
x0 = 0;
y_cruce = sqrt(3)*(x0 - sigma0);
plot(x0, y_cruce, 'kd', 'MarkerFaceColor','k', 'DisplayName','Cruce asíntota eje jω');
plot(x0, -y_cruce, 'kd', 'MarkerFaceColor','k');

%% 5. Punto de intersección de raíces con eje imaginario (Routh-Hurwitz)
% Ecuación característica: s^4 + 5s^3 + 20s^2 + (16+K)s + 3K = 0
% Se anula el elemento s1 para estabilidad marginal

K = 33.3273;  % Valor obtenido de resolver K^2 + 7K - 1344 = 0
a3 = 16 + K;
a4 = 3 * K;

den_marginal = [1 5 20 a3 a4];
raices_marginal = roots(den_marginal);

% Filtrar raíces puramente imaginarias
for i = 1:length(raices_marginal)
    if abs(real(raices_marginal(i))) < 1e-3
        plot(real(raices_marginal(i)), imag(raices_marginal(i)), 'ms', ...
             'MarkerFaceColor', 'm', 'DisplayName','Cruce raíces eje jω');
    end
end

%% 6. Puntos de llegada (raíces reales de la derivada de K)
% Ecuación: 3s^4 + 22s^3 + 65s^2 + 120s + 48 = 0
coef_derivada = [3 22 65 120 48];
raices_derivada = roots(coef_derivada);

for i = 1:length(raices_derivada)
    if abs(imag(raices_derivada(i))) < 1e-3
        plot(real(raices_derivada(i)), 0, 'c^', 'MarkerFaceColor', 'c', ...
             'DisplayName', 'Punto de llegada');
    end
end

%% 7. LGR completo
rlocus(G);  % Para sobreponer el lugar geométrico completo

title('Lugar Geométrico de las Raíces - Taller 7');
legend('Location','bestoutside');
