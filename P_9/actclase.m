clc; clear; close all;

%% Datos del circuito
R = 10;
L = 1e-3;
C = 100e-6;

% Creamos función de transferencia G(s)
num = 100;
den = [1 100];
G = tf(num, den);
f = logspace(0, 6, 10000);  % Frecuencia en Hz 
w = 2*pi*f;            % Convertimos a radianes
s = 1j*w;                     
Gjw = freqs(num, den, w);   
mag = abs(Gjw);              %Sacamos el valor absoluto              
mag_dB = 20*log10(mag);      % Magnitud en dB 
fase = angle(Gjw);           
fase_deg = rad2deg(fase);    % Fase en grados )
N=1000000;
w = logspace(1,7,N);

bode(G,w);N=100;
w = logspace(1,7,N);
bode(G,w);

%obtenemos en -3dB 93.3 rad/s  --> 14.8491561905 Hz