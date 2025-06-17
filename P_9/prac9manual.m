clc; clear; close all;

%% Datos del circuito
R = 10;
L = 1e-3;
C = 100e-6;

%% Creamos función de transferencia G(s)
% G(s) = 1/(LC) / (s^2 + R/L*s + 1/(LC))
num = 1/(L*C);
den = [1 R/L 1/(L*C)];
G = tf(num, den);

%% Frecuencia en Hz (escala logarítmica) y luego convertimos a radianes/segundo
% ¿Qué debería hacer para obtener la gráfica en Hertz?
% Definir un vector de frecuencias en Hz y luego lo convertimos a ω (rad/s)
% ya que matlab trabaja por defecto con radianes
f = logspace(0, 6, 1000);     % Frecuencia en Hz (1 Hz a 1 MHz) vector de frecuencias 
w = 2*pi*f;                   % Convertimos a radianes por segundo

%% Evaluar la función de transferencia en cada frecuencia w
% ¿Cómo hizo para evaluar la función de transferencia en una frecuencia determinada?
% Se evalúa sustituyendo s = jω en la función de transferencia, es decir, en el eje imaginario
%esto se debe a que el análisis de Bode se realiza en este eje del plano complejo
%asi obtenemos G(jw) para luego tener magnitud y fase
s = 1j*w;                     
Gjw = freqs(num, den, w);    % También puede usarse: Gjw = squeeze(freqresp(G, w));
%freq es una funcion que evalua la respuesta en frecuencia , de las
%frecuencias que estan en el vector w
%Gjw es un vector de valores complejos , resp en frecuencia de esas f

%% ¿Qué unidad debe tener la magnitud?
% La magnitud debe estar en decibelios (dB) porque permite representar relaciones de ganancia logarítmicamente
% Permite representar un amplio rango de valores en una escala más compacta.
%Facilita la multiplicación de ganancias como una suma en dB, sistemas en cascada


% Cálculo de la magnitud
% ¿Cómo calculó la magnitud?
% Se calcula como el módulo del número complejo G(jω), y se pasa a decibelios (dB)
mag = abs(Gjw);              %Sacamos el valor absoluto              
mag_dB = 20*log10(mag);      % Magnitud en dB (unidad necesaria en el diagrama de Bode)


%% Pregunta: ¿Qué unidad debe tener la fase?
% La fase se representa en grados porque es la unidad convencional en sistemas de control
% Porque los diagramas de Bode muestran la diferencia de fase entre entrada y salida de un sistema, 
% y esta diferencia se mide comúnmente en grados para facilitar la interpretación 
% (por ejemplo, un retardo de 90° o 180°). Aunque la fase internamente se calcula en radianes

% Cálculo de la fase
% ¿Cómo calculó la fase?
% Se obtiene el ángulo del número complejo G(jω) y se convierte de radianes a grados
fase = angle(Gjw);           
fase_deg = rad2deg(fase);    % Fase en grados (unidad necesaria en el diagrama de Bode)

% Graficar manualmente el diagrama de Bode

figure;
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


