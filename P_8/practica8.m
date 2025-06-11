clc;
clear;

%% Parámetros comunes del sistema
ki = 9.43e-3;
kb = 1010;
jm = 330;
bm = 10e-3;
ra = 0.635;
la = 0.0883;

Kc = 138.9612;
kc = Kc * kb;

zc = 7.1457;
pc = 7.9543;

zeta = 0.5912;
wn = 6.7664;

% Polos deseados
sd1 = -4 + 1j*5.4575;
sd2 = -4 - 1j*5.4575;
p_deseados = [sd1, sd2];

%% Sistema sin compensar
num = ki / (la * jm);
den = [1, (bm/jm + ra/la), (ra*bm + ki*kb)/(la*jm)];
G = tf(num, den);

%% Compensador
Gc = tf([Kc, Kc*zc], [1, pc]);

%% Sistema compensado
Gcomp = feedback(Gc * G, kb);
Gnoc = feedback(G, kb);  % sistema sin compensar

%% Respuesta al escalón
t = 0:0.01:150;
[y1, ~] = step(Gnoc, t);
[y2, ~] = step(Gcomp, t);

% Normalizar
y1 = y1 / dcgain(Gnoc);
y2 = y2 / dcgain(Gcomp);

% Figura 1: Comparación respuesta al escalón
figure;
plot(t, y1, 'b-', 'LineWidth', 2); hold on;
plot(t, y2, 'g', 'LineWidth', 2);
grid on;
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Comparación: Respuesta al Escalón');
legend('Sin compensar', 'Compensado');

%% Lugar de las raíces sistema sin compensar
char_eq = [1 2*zeta*wn wn^2];
figure;
rlocus(G); hold on;
plot(real(p_deseados), imag(p_deseados), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
legend('Lugar de las raíces', 'Polos deseados');
title('Lugar de las raíces - Sistema sin compensar');
grid on;

%% Lugar de raíces del sistema con compensador
% Compensador sin ganancia (análisis de ángulos)
Gc_ang = tf([1 -zc], [1 -pc]);
G_total = Gc_ang * G;

figure;
rlocus(G_total); hold on;
plot(real(p_deseados), imag(p_deseados), 'go', 'MarkerSize', 10, 'LineWidth', 2);
legend('Lugar de las raíces', 'Polos deseados');
title('Lugar de las raíces - Sistema con compensador sin ganancia');
grid on;

%% Función de transferencia total del sistema con compensador
numgc = [1 zc];
dengc = [1 pc];
Gc_real = tf(numgc * kc, dengc);
Gs = tf(num, den);
G1 = series(Gs, Gc_real);

sys = feedback(G1, 1);
sys2 = feedback(Gs, 1);

%% PZMAP - sistema compensado
figure;
xlim([-9 2]);
ylim([-7 7]);
pzmap(sys);
grid on;
title('Diagrama Polo-Cero - Sistema Compensado');

%% Lugar de raíces del sistema compensado con ganancia
figure;
xlim([-9 2]);
ylim([-7 7]);
rlocus(sys);
grid on;
title('Lugar de raíces - Sistema Compensado con Ganancia');

%% Respuesta al escalón del sistema compensado con ganancia
figure;
step(sys);
grid on;
title('Respuesta al Escalón - Sistema Compensado con Ganancia');
