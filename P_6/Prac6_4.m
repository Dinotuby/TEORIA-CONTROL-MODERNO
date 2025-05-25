s = tf('s');
G1 = 3/s;
G2 = 1/(s^2 + 1);
H = 3;

G = series(G1, G2);  % Combinamos en serie
Gs = feedback(G, H); % Retroalimentación con H

% Graficar respuesta al escalón
step(Gs);
grid on;
title('Respuesta al escalón del sistema en lazo cerrado');

% Mostrar función de transferencia
disp('La función de transferencia Gs en lazo cerrado es:');
Gs

% Obtener polos
p = pole(Gs);
disp('Polos del sistema:');
disp(p);

% Evaluar estabilidad
if all(real(p) < 0)
    disp(' El sistema es ESTABLE.');
elseif any(real(p) > 0)
    disp(' El sistema es INESTABLE.');
elseif all(real(p) <= 0) && any(real(p) == 0)
    disp(' El sistema es MARGINALMENTE ESTABLE.');
end

% Clasificar amortiguamiento y oscilación
if all(imag(p) == 0)
    if all(real(p) < 0)
        unique_p = unique(round(p, 4));  % Evitar errores numéricos
        if length(p) ~= length(unique_p)
            disp(' El sistema es CRÍTICAMENTE AMORTIGUADO (raíces reales iguales).');
        else
            disp(' El sistema es SOBREAMORTIGUADO (raíces reales negativas distintas).');
        end
    elseif any(real(p) > 0) 
        disp(' El sistema es NO OSCILANTE (raíces reales positivas).'); %cuando es inestable
    elseif any(real(p) == 0)
        disp(' El sistema es MARGINALMENTE ESTABLE Y NO AMORTIGUADO (raíces reales en el eje imaginario).');
    end
else
    if all(real(p) < 0)
        disp(' El sistema es SUBAMORTIGUADO (raíces complejas con parte real negativa) → OSCILANTE y ESTABLE.');
    elseif any(real(p) > 0)
        disp(' El sistema es OSCILANTE (raíces complejas con parte real +).'); %inestable
    elseif all(real(p) == 0)
        disp(' El sistema es NO AMORTIGUADO (raíces puramente imaginarias) → OSCILACIÓN PERMANENTE.');
    end
end
