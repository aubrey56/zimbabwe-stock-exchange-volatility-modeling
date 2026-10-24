import numpy as np
import pandas as pd
from scipy.stats import jarque_bera, kurtosis, skew
from statsmodels.stats.diagnostic import acorr_ljungbox
from statsmodels.tsa.stattools import adfuller

def run_diagnostics(returns):
    print("--- Summary Statistics ---")
    print(f"Mean Return: {returns.mean():.6f}")
    print(f"Std Deviation: {returns.std():.6f}")
    print(f"Skewness: {skew(returns):.6f}")
    print(f"Kurtosis: {kurtosis(returns, fisher=False):.6f}")
    
    jb_stat, jb_p = jarque_bera(returns)
    print(f"Jarque-Bera: {jb_stat:.2f} (p-value: {jb_p:.4e})")
    
    print("\n--- Stationarity Test (ADF) ---")
    adf_stat, adf_p, _, _, crits, _ = adfuller(returns)
    print(f"ADF Statistic: {adf_stat:.6f} (p-value: {adf_p:.6f})")
    
    print("\n--- ARCH Effects (Ljung-Box on Squared Returns) ---")
    lb_test = acorr_ljungbox(returns**2, lags=[5, 12, 20], return_df=True)
    print(lb_test)

if __name__ == "__main__":
    df = pd.read_csv('data/processed/zse_clean_returns.csv')
    run_diagnostics(df['Log_Return'].values)
