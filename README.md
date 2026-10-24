# Econometric Volatility Modelling & Value at Risk (VaR) Engine for the ZSE

An institutional-grade, out-of-sample quantitative risk framework built for the Zimbabwe Stock Exchange (ZSE) All-Share Index (2019–2023). This project demonstrates time-series preprocessing, GARCH model calibration, out-of-sample volatility forecasting, and Value at Risk (VaR) Kupiec backtesting.

## Executive Summary
- **Data Scope:** 1,207 daily observations (January 2019 – December 2023)
- **Primary Finding:** Standard Gaussian models severely under-estimate downside risk. A **Student-$t$ $\text{sGARCH}(1,1)$ framework** reduces out-of-sample forecast error (RMSE) by **55%** relative to rolling historical volatility benchmarks.
- **Volatility Persistence:** Near-unity persistence ($\alpha_1 + \beta_1 = 0.9500$), confirming long memory in ZSE market shocks.
- **VaR Backtest Validation:** Passed the **Kupiec Proportion of Failures Test** at both 95% ($p = 0.3391$) and 99% ($p = 0.2985$) confidence levels.

## Key Statistical Diagnostics
| Diagnostic Test | Test Statistic | p-value | Conclusion |
| :--- | :--- | :--- | :--- |
| **Augmented Dickey-Fuller (ADF)** | -13.201371 | < 0.0001 | Log returns are covariance stationary $I(0)$ |
| **Jarque-Bera Normality** | 7,316,376.39 | < 0.0001 | Decisively rejects Gaussian normality (Kurtosis = 384.41) |
| **Ljung-Box $LB(12)$ on $R_t^2$** | 300.828 | < 0.0001 | Strong ARCH effects & volatility clustering |

## Out-of-Sample Performance (2023 Holdout Set)
| Model Specification | Out-of-Sample RMSE | Out-of-Sample MAE | Ranking |
| :--- | :---: | :---: | :---: |
| Historical Volatility Benchmark | 0.045361 | 0.043024 | 3 |
| $\text{sGARCH}(1,1)$ - Gaussian Normal | 0.033366 | 0.031292 | 2 |
| **$\text{sGARCH}(1,1)$ - Student-$t$ ($\nu = 5.0$)** | **0.020441** | **0.016069** | **1 (Optimal)** |

## Value at Risk (VaR) Backtest Results
| Risk Horizon | Confidence ($\alpha$) | Expected Breaches | Observed Breaches | Kupiec LR Stat | p-value | Decision |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **1-Day VaR** | 95% | 12 | **9** | 0.9140 | **0.3391** | **PASS** |
| **1-Day VaR** | 99% | 2 | **1** | 1.0809 | **0.2985** | **PASS** |

## How to Reproduce
1. Clone the repository: `git clone https://github.com/your-username/zse-volatility-garch.git`
2. Install dependencies: `pip install -r requirements.txt`
3. Run data pipeline:
   ```bash
   python src/01_data_preprocessing.py
   python src/02_exploratory_analysis.py
   python src/03_model_comparison.py
   python src/04_var_backtesting.py
