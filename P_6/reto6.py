import numpy as np
import matplotlib.pyplot as plt
import control as ctrl
from sympy import symbols, simplify

# Parámetros del circuito RLC
R = 5
L = 0.1
C = 220e-6

# PID: C(s) = Kp + Ki/s + Kd*s
Kp = 10
Ki = 1000
Kd = 0.01

# Función de transferencia de la planta RLC
num_rlc = [1]
den_rlc = [L*C, R*C, 1]
H_rlc = ctrl.TransferFunction(num_rlc, den_rlc)

# Función de transferencia del PID
num_pid = [Kd, Kp, Ki]
den_pid = [1, 0]
PID = ctrl.TransferFunction(num_pid, den_pid)

# Sistema en lazo abierto
open_loop = ctrl.series(PID, H_rlc)

# Sistema en lazo cerrado con retroalimentación unitaria
closed_loop = ctrl.feedback(open_loop, 1)

# Coeficientes del denominador para Routh-Hurwitz
den_coeffs = closed_loop.den[0][0]
print("Coeficientes del denominador (Routh-Hurwitz):")
print(den_coeffs)

# Mostrar polinomio simbólico del denominador
s = symbols('s')
poly_expr = sum(c * s**i for i, c in enumerate(reversed(den_coeffs)))
print("\nPolinomio característico simbólico:")
print(simplify(poly_expr))

# Polos del sistema
poles = ctrl.poles(closed_loop)
print("\nPolos del sistema:")
print(poles)

# Gráficas
t, y = ctrl.step_response(closed_loop)

plt.figure(figsize=(10, 6))

plt.subplot(2, 1, 1)
plt.plot(t, y)
plt.title('Respuesta al escalón (Python)')
plt.xlabel('Tiempo [s]')
plt.ylabel('Salida')
plt.grid(True)

plt.subplot(2, 1, 2)
ctrl.pzmap(closed_loop)
plt.title('Mapa de Polos y Ceros (Python)')
plt.grid(True)

plt.tight_layout()
plt.show()
