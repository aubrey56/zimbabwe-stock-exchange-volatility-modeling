import numpy as np
import pandas as pd
from scipy.optimize import minimize
from scipy.special import gammaln

def garch_likelihood_t(params, r):
    omega, alpha, beta, nu = params
    if omega <= 1e-6 or alpha < 0 or beta < 0 or (alpha + beta) >= 1.0 or nu <= 2.01:
        return 1e10
    T = len(r)
    sigma2 = np.zeros(T)
    sigma2[0] = np.var(r)
    for t in range(1, T):
        sigma2[t] = omega + alpha * (r[t-1]**2) + beta * sigma2[t-1]
    term1 = gammaln((nu + 1) / 2) - gammaln(nu / 2) - 0.5 * np.log(np.pi * (nu - 2))
    loglik = np.sum(term1 - 0.5 * np.log(sigma2) - ((nu + 1) / 2) * np.log(1 + (r**2) / ((nu - 2) * sigma2)))
    return -loglik

def fit_garch_student_t(train_returns):
    res = minimize(
        garch_likelihood_t, 
        [1e-5, 0.1, 0.85, 5.0], 
        args=(train_returns,), 
        bounds=[(1e-8, None), (0, 1), (0, 1), (2.01, 30)], 
        method='L-BFGS-B'
    )
    return res.x

if __name__ == "__main__":
    df = pd.read_csv('data/processed/zse_clean_returns.csv')
    returns = df['Log_Return'].values
    train_size = int(0.8 * len(returns))
    
    r_train = returns[:train_size]
    r_test = returns[train_size:]
    
    omega, alpha, beta, nu = fit_garch_student_t(r_train)
    print(f"Optimal Parameters -> Omega: {omega:.8f}, Alpha: {alpha:.4f}, Beta: {beta:.4f}, Nu: {nu:.2f}")
    print(f"Persistence (Alpha + Beta): {alpha + beta:.4f}")
