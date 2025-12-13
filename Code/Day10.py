import ast
import numpy as np
from scipy.optimize import milp, LinearConstraint, Bounds

filename = './Day10.out'

ans = 0

with open(filename, 'r') as f:
    lines = [line.strip() for line in f if line.strip()]

    for i in range(0, len(lines), 2):
        matrix_A = ast.literal_eval(lines[i])
        vector_b = ast.literal_eval(lines[i+1])

        A = np.array(matrix_A)
        b = np.array(vector_b)
        n, m = A.shape
        c = np.ones(m)
        bounds = Bounds(0, np.inf)
        constraint = LinearConstraint(A, b, b)

        res = milp(c, constraints=[constraint], bounds=bounds, integrality=np.ones(m, dtype=int))

        ans += int(res.fun)
print(ans)