clc; clear; close all;
%% Datos del circuito 
R=10;
L = 1e-3;
C= 100e-6;

num = 1/(L*C);
den = [1 R/L 1/(L*C)];
G= tf(num, den);

%Definiri el rango de frecuencias (Hz) , pasabajo, lazo abierto
N=100;
w = logspace(1,7,N);

bode(G,w);
