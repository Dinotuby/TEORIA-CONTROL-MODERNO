import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import StateSpace, step, impulse

# Parámetros del circuito
R = 100            # Resistencia (ohmios)
L = 0.1            # Inductancia (henrios)
Cap = 1e-6         # Capacitancia (faradios)

# Matrices del sistema en espacio de estados
A = np.array([[0, 1], [-1/(L*Cap), -R/L]])
B = np.array([[0], [1/L]])
C = np.array([[0, 1]])
D = np.array([[0]])

# Crear sistema en espacio de estados
sys = StateSpace(A, B, C, D)

# Tiempo de simulación
t = np.linspace(0, 0.01, 1000)

# Respuesta al escalón
t1, y1 = step(sys, T=t)

# Respuesta al impulso
t2, y2 = impulse(sys, T=t)

# Graficar respuestas
plt.figure(figsize=(8, 6))

plt.subplot(2, 1, 1)
plt.plot(t1, y1)
plt.title('Respuesta al Escalón')
plt.xlabel('Time [s]')
plt.ylabel('Vc [V]')

plt.subplot(2, 1, 2)
plt.plot(t2, y2)
plt.title('Respuesta al Impulso')
plt.xlabel('Time [s]')
plt.ylabel('Vc [V]')

plt.tight_layout()
plt.show()
