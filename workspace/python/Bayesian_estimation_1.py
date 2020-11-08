#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov  5 15:19:19 2020

@author: ppolcz
"""

"""
source: https://www.analyticsvidhya.com/blog/2016/06/bayesian-statistics-beginners-simple-english/
"""

import numpy as np
import matplotlib.pyplot as plt

theta = np.linspace(0.001,0.999,200)

N = 10.0
z = 3.0

normalizer = 1.0
alpha = z / normalizer
beta = (N - z) / normalizer
alpha = 5
beta = 5

f_aprior = theta**(alpha - 1) * (1 - theta)**(beta - 1)
f_aprior = f_aprior / np.trapz(f_aprior,theta)

P_z = theta**z * (1 - theta)**(N - z)
P_z = P_z / np.trapz(P_z,theta)

f_aposteriori = P_z * f_aprior
f_aposteriori = f_aposteriori / np.trapz(f_aposteriori,theta)

plt.plot(theta,f_aprior)
plt.plot(theta,P_z)
plt.plot(theta,f_aposteriori)

plt.show()