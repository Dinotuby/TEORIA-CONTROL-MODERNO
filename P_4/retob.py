import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

# Parámetros del circuito
R = 100           # Resistencia (ohmios)
L = 0.1           # Inductancia (henrios)
Cap = 1e-6        # Capacitancia (faradios)

# Matrices del sistema en espacio de estados
A = np.array([[0, 1], [-1/(L*Cap), -R/L]])
B = np.array([[0], [1/L]])
C = np.array([[1/Cap, 0]])
D = np.array([[0]])

# Tiempo de simulación
ts = 0.015
tspan = (0, ts)

# Entrada constante
u = 1

# Condiciones iniciales
x0 = [0, 0]

# Definir la función del modelo
def modelRLC(t, x):
    dxdt = A @ x + B.flatten() * u
    return dxdt

# Resolver la ecuación diferencial
sol = solve_ivp(modelRLC, tspan, x0, t_eval=np.linspace(tspan[0], tspan[1], 1000))

# Salida del sistema
y = (C @ sol.y + D * u).flatten()

# Graficar resultado
plt.figure()
plt.plot(sol.t, y)
plt.xlabel('Tiempo [s]')
plt.ylabel('Voltaje de salida [V]')
plt.title('Respuesta del circuito RLC usando solve_ivp (ode45 equivalente)')
plt.grid(True)
plt.show()
