import numpy as np
import matplotlib.pyplot as plt
from control.matlab import tf, lsim

# Sistema original sin retardo
num = [3]
den = [1, 2, 3]
G = tf(num, den)
theta = 2  # segundos de retardo

# Tiempo
t = np.linspace(0, 70, 600)  # paso de 0.1 s

signal = np.piecewise(t, 
                      [t < 5, 
                       (t >= 5) & (t < 10), 
                       (t >= 10) & (t < 20), 
                       (t >= 20) & (t < 30), 
                       (t >= 30) & (t < 50),
                       (t >= 50) & (t < 60),
                       t >= 60], 
                      [lambda x: 0, 
                       lambda x: x - 5, 
                       lambda x: 5, 
                       lambda x: 10, 
                       lambda x: 40 - 0.5 * x,
                       lambda x: 15,
                       lambda x: 0])


signal_retardada = np.zeros_like(signal)
delay_samples = int(theta / (t[1] - t[0]))  # número de muestras a retrasar
signal_retardada[delay_samples:] = signal[:-delay_samples]

# Simular la respuesta
yout, T, _ = lsim(G, U=signal_retardada, T=t)

# Graficar
plt.figure(figsize=(10, 5))
plt.plot(t, signal, 'b--', linewidth=2, label='Señal original (sin retardo)')
plt.plot(T, yout, 'r', linewidth=2, label='Respuesta del Sistema (con retardo)')
plt.xlabel('Tiempo (s)')
plt.ylabel('Amplitud')
plt.title('Respuesta del sistema con retardo aplicado manualmente')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
