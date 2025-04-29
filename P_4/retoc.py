import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

# Parámetros del circuito
R = 100          # Resistencia en ohmios
L = 0.1          # Inductancia en henrios
Cap = 1e-6       # Capacitancia en faradios

# Matrices del sistema en espacio de estados
A = np.array([[0, 1], [-1 / (L * Cap), -R / L]])
B = np.array([0, 1 / L])
C = np.array([1 / Cap, 0])  # y = Vc = q / C
D = 0

# Crear segmentos del tiempo
x1 = np.linspace(0, 0.010, 100)
x2 = np.linspace(0.010, 0.020, 100)
x3 = np.linspace(0.020, 0.030, 100)
x4 = np.linspace(0.030, 0.040, 100)
x5 = np.linspace(0.040, 0.050, 100)
x6 = np.linspace(0.050, 0.060, 100)

# Crear la señal por tramos (misma forma que en MATLAB)
y1 = np.zeros(len(x1))
y2 = 500 * x2 - 5
y3 = 10 * np.ones(len(x3))
y4 = -500 * x4 + 25
y5 = 5 * np.ones(len(x5))
y6 = np.zeros(len(x6))

# Unir los segmentos en un solo vector
x_arb = np.concatenate((x1, x2, x3, x4, x5, x6))
y_arb = np.concatenate((y1, y2, y3, y4, y5, y6))

N = len(x_arb)

# Función del sistema RLC
def modelRLC(t, x, A, B, u):
    return A @ x + B * u

# Inicializar los estados y tiempo
x = np.zeros((N, 2))
t = np.zeros(N)

# Resolver el sistema por integración por tramos
for k in range(1, N):
    sol = solve_ivp(lambda t, x: modelRLC(t, x, A, B, y_arb[k]),
                    [x_arb[k-1], x_arb[k]], x[k-1, :], method='RK45')
    t[k] = sol.t[-1]
    x[k, :] = sol.y[:, -1]

# Calcular la salida (voltaje en el capacitor)
y = C @ x.T

# Graficar la entrada arbitraria y la respuesta del sistema
plt.figure(figsize=(10, 5))
plt.plot(x_arb, y_arb, 'b--', linewidth=1.5, label='Entrada arbitraria')
plt.plot(t, y, 'r-', linewidth=1.5, label='Voltaje en el capacitor')
plt.xlabel('Tiempo [s]')
plt.ylabel('Voltaje [V]')
plt.title('Respuesta del sistema RLC a señal arbitraria')
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
