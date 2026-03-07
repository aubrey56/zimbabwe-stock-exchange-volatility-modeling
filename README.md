# zimbabwe-stock-exchange-volatility-modeling
Time series analysis of the Zimbabwe Stock Exchange (ZSE) All Share Index using R. The project computes log returns, performs ADF and ARCH tests, and estimates a GARCH(1,1) model to analyze volatility clustering and conditional variance in financial market data.


## Project Overview
This project analyzes volatility in the Zimbabwe Stock Exchange (ZSE) All Share Index using ARCH and GARCH models in R.

The goal is to model financial market volatility and detect volatility clustering using econometric time series methods.

## Methods Used
- Log Return Calculation
- Augmented Dickey-Fuller Stationarity Test
- ARCH Effect Test
- GARCH(1,1) Volatility Model

## Technologies
- R
- dplyr
- tseries
- rugarch
- FinTS

## Key Findings
- The return series is stationary (ADF test).
- ARCH effects are present, indicating volatility clustering.
- The GARCH(1,1) model shows strong volatility persistence.

## Model
Variance equation:

σ²ₜ = ω + αε²ₜ₋₁ + βσ²ₜ₋₁

## Visualizations
### Returns
![Returns Plot](output/returns_plot.png)

### Conditional Volatility
![Volatility Plot](output/conditional_volatility.png)

## Author
Applied Statistics Student | Data Analytics Enthusiast
