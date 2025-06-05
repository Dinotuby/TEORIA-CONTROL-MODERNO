# -*- coding: utf-8 -*-
"""
Taller 7 - Lugar Geométrico de las Raíces
Implementación completa en Python
"""

import numpy as np
import matplotlib.pyplot as plt
import control as ctrl
from sympy import symbols, simplify, solve

# -----------------------------
# 1. Función de transferencia
# -----------------------------
num = [1, 3]
den = [1, 5, 20, 16, 0]
sys = ctrl.tf(num, den) #obtengo la ft

# -----------------------------
# 2. Polos y ceros
# -----------------------------
zeros = ctrl.zeros(sys)         #extraigo ceros 
poles = ctrl.poles(sys)         #extraigo polos

plt.figure()                    #eje real (x) eje imaginario (y)
plt.plot(np.real(zeros), np.imag(zeros), 'bo', label='Ceros', markersize=8) 
plt.plot(np.real(poles), np.imag(poles), 'rx', label='Polos', markersize=8)
plt.axhline(0, color='gray', lw=0.5)
plt.axvline(0, color='gray', lw=0.5)
plt.grid(True)
plt.axis('equal')
plt.xlim([-6, 6])   #limite eje x
plt.ylim([-6, 6])   #limite eje y
plt.legend()
plt.title("Polos y Ceros del Sistema")
plt.show()

# -----------------------------
# 3. Asíntotas manuales
# -----------------------------
n = len(poles)              #polos 
m = len(zeros)              #ceros
sigma0 = (-2) / (n - m)     #centro de las asintotas

x = np.linspace(sigma0, 6, 100)    #vector x 
y_pos = np.tan(np.radians(60)) * (x - sigma0)  #formula de asintotas
y_neg = -y_pos          

plt.figure()
plt.plot(x, y_pos, 'k--', label='Asíntota +60°')
plt.plot(x, y_neg, 'k--', label='Asíntota -60°')
plt.axhline(0, color='k', linestyle='--', label='Asíntota 180°')
plt.axvline(0, color='gray', lw=0.5)
plt.plot(np.real(poles), np.imag(poles), 'rx', label='Polos', markersize=8) #graf pol
plt.plot(np.real(zeros), np.imag(zeros), 'bo', label='Ceros', markersize=8) #graf 0
plt.title("Asíntotas del LGR")
plt.grid(True)
plt.axis('equal')
plt.xlim([-6, 6])
plt.ylim([-6, 6])
plt.legend()
plt.show()

# -----------------------------
# 4. Esbozo con root_locus
# -----------------------------
ctrl.root_locus(sys, grid=True)  #graifco LG
plt.title("Lugar Geométrico de las Raíces (Python)")
plt.show()


# -----------------------------
# 5. Derivada de K para puntos de llegada

# -----------------------------
coef_deriv = [3, 22, 65, 120, 48]
roots_llegada = np.roots(coef_deriv)

print("\n[Puntos de llegada - raíces reales]")
for r in roots_llegada:
    if np.isreal(r):
        print(f"  Real: {np.real(r):.4f}")
    else:
        print(f"  Complejo: {r:.4f}")

# -----------------------------
# 6. Criterio de Routh-Hurwitz (simbólico)
# -----------------------------
K = symbols('K', real=True, positive=True)

# Ecuación característica simbólica: s^4 + 5s^3 + 20s^2 + (16+K)s + 3K
r0 = [1, 20, 3*K]
r1 = [5, 16+K, 0]

r2_1 = simplify((r1[1]*r0[0] - r1[0]*r0[1]) / r1[0])
r2_2 = 3*K
r3_1 = simplify((r2_1*r1[1] - r1[0]*r2_2) / r2_1)

print("\n[Elemento crítico de Routh-Hurwitz]")
print("Ecuación: K^2 + 7K - 1344 = 0")
K_vals = solve(r3_1, K)
print("Valores de K que causan cruce en eje jω:", K_vals)

# -----------------------------
# 7. Verificación con K = 33.3273
# -----------------------------
Kval = 33.3273
a3 = 16 + Kval
a4 = 3 * Kval
den_critico = [1, 5, 20, a3, a4]
roots_critico = np.roots(den_critico)

print("\n[Raíces para K = 33.3273 (intersección eje jω)]")
print(roots_critico)
