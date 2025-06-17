clc; clear; close all;
%% metodo 1
R=100;
L = 112.54e-3;
C= 22.5e-6;

num = [1 0 0];
den = [1 R/L 1/(L*C)];
G= tf(num, den);

%Definir el rango de frecuencias (Hz)
N=1000;
w = logspace(0,6,N);    %de 10^1 a 10^4 hz
margin(G);
figure();
bode(G,w);

%% metodo 2
f = logspace(0, 6, 1000); % Frecuencia en Hz 
w = 2*pi*f;               % Convertimos a radianes

s = 1j*w;                     
Gjw = freqs(num, den, w);  
mag = abs(Gjw);            %Sacamos el valor absoluto              
mag_dB = 20*log10(mag);    % Magnitud en dB
fase = angle(Gjw);           
fase_deg = rad2deg(fase);    % Fase en grados 

% Graficar manualmente el diagrama de Bode
figure();
subplot(2,1,1);
semilogx(f, mag_dB, 'LineWidth', 2);  % Eje en Hz
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
title('Diagrama de Bode - Magnitud');
grid on;

subplot(2,1,2);
semilogx(f, fase_deg, 'LineWidth', 2);  % Eje en Hz el f
xlabel('Frecuencia (Hz)');
ylabel('Fase (°)');
title('Diagrama de Bode - Fase');
grid on;