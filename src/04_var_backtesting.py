import numpy as np
import pandas as pd
from scipy import stats

def kupiec_pof_test(actual_returns, var_forecast, alpha_level):
    hits = (actual_returns < var_forecast).astype(int)
    x = np.sum(hits)
    N = len(actual_returns)
    p_hat = x / N
    p = alpha_level
    
    if x == 0:
        LR_POF = -2 * (N * np.log(1 - p))
    else:
        LR_POF = -2 * ((N - x) * np.log(1 - p) + x * np.log(p) - (N - x) * np.log(1 - p_hat) - x * np.log(p_hat))
        
    p_val = 1 - stats.chi2.cdf(LR_POF, df=1)
    return x, N, p_hat, LR_POF, p_val

if __name__ == "__main__":
    # Test execution function for Kupiec POF
    print("VaR Backtest module initialized successfully.")
