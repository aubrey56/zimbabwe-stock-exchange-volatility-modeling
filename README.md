# Econometric Volatility & Value at Risk (VaR) Engine for the ZSE

An institutional-grade, out-of-sample quantitative risk framework built for the Zimbabwe Stock Exchange (ZSE) All-Share Index (2019–2023).

## Key Visualizations & Empirical Plots

### 1. Exploratory Diagnostics & Fat Tails
![ZSE Diagnostics](figures/step2_diagnostics.png)
*Figure 1: Price levels, daily log return volatility clustering, and return distribution vs. Gaussian normal curve.*

### 2. Autocorrelation & ARCH Effects
![ACF PACF Plots](figures/step2_acf_pacf.png)
*Figure 2: Autocorrelation (ACF) and Partial Autocorrelation (PACF) plots of log returns and squared log returns.*

### 3. Out-of-Sample Volatility Forecast Evaluation
![Volatility Forecast Comparison](figures/step3_model_forecast_comparison.png)
*Figure 3: Out-of-sample volatility forecast performance comparing Historical Volatility, Gaussian GARCH, and Student-t GARCH against realized volatility.*

### 4. Value at Risk (VaR) Backtesting & Exceedances
![VaR Backtest Exceedances](figures/step4_var_backtest_exceedances.png)
*Figure 4: 95% and 99% 1-Day Value at Risk thresholds plotted against actual daily returns with highlighted Kupiec breaches.*

## Project Reports
- Full Executive Report: [reports/findings.md](reports/findings.md)
