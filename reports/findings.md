# Econometric Volatility Analysis & Value at Risk (VaR) Backtesting on the ZSE

**Author:** Aubrey McJohn Moyo  
**Target Asset:** Zimbabwe Stock Exchange (ZSE) All-Share Index  
**Sample Horizon:** January 2019 – December 2023 ($N = 1,207$ daily observations)  

---

## 1. Executive Summary
This report presents an out-of-sample quantitative risk evaluation of the Zimbabwe Stock Exchange (ZSE) All-Share Index. Traditional static risk metrics assume homoskedasticity and normal distributions, which systematically under-estimate tail risk in volatile frontier markets. By implementing a **Student-$t$ $\text{sGARCH}(1,1)$ framework**, we achieve a **55% reduction in out-of-sample volatility forecast error (RMSE)** compared to historical rolling volatility models and statistically validate a 1-day Value at Risk ($\text{VaR}$) model against actual market shocks.

---

## 2. Statistical Pre-Modelling Diagnostics
- **Covariance Stationarity:** The Augmented Dickey-Fuller (ADF) test statistic of **$-13.2014$** ($p < 0.0001$) confirms that while price levels exhibit non-stationary trends, logarithmic returns $R_t = \ln(P_t / P_{t-1})$ are strictly stationary.
- **Non-Normality & Heavy Tails:** The return series exhibits severe leptokurtosis ($K = 384.41$) and a Jarque-Bera metric of **$7,316,376.39$** ($p < 0.0001$), decisively rejecting Gaussian normality assumptions.
- **ARCH Effects:** Ljung-Box tests on squared log returns ($LB(12) = 300.83, p < 0.0001$) verify time-varying conditional variance and strong volatility clustering.

---

## 3. Model Specification & Out-of-Sample Evaluation
Model evaluation was conducted using an 80/20 chronological train/test split (965 training days, 242 holdout test days in 2023).

| Model Specification | Log-Likelihood | AIC | Out-of-Sample RMSE | Out-of-Sample MAE | Forecast Rank |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Historical Volatility Benchmark | *N/A* | *N/A* | 0.045361 | 0.043024 | 3 |
| $\text{sGARCH}(1,1)$ - Gaussian Normal | 1,602.84 | -3,199.68 | 0.033366 | 0.031292 | 2 |
| **$\text{sGARCH}(1,1)$ - Student-$t$ ($\nu = 5.0$)** | **2,393.06** | **-4,778.13** | **0.020441** | **0.016069** | **1 (Optimal)** |

---

## 4. Value at Risk (VaR) Kupiec POF Backtesting
Out-of-sample 1-day $\text{VaR}$ thresholds were backtested across the 2023 holdout period using the Kupiec Proportion of Failures (POF) test:

- **95% 1-Day VaR:** 9 actual breaches vs. 12 expected ($LR = 0.9140, p = 0.3391$). **Decision: PASS**
- **99% 1-Day VaR:** 1 actual breach vs. 2 expected ($LR = 1.0809, p = 0.2985$). **Decision: PASS**

---

## 5. Commercial Application
These findings provide the mathematical foundation for **ZSE RiskSense Enterprise**, replacing manual spreadsheet risk calculations with automated, localized quantitative models for asset managers, stockbrokers, and pension funds.
