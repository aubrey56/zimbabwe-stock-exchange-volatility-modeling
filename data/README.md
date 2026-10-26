# ZSE All-Share Index Dataset Specification

## Dataset Overview
- **Asset Name:** Zimbabwe Stock Exchange (ZSE) All-Share Index
- **Time Period:** January 14, 2019 – December 21, 2023
- **Frequency:** Daily trading days
- **Total Observations:** 1,208 raw price entries | 1,207 daily log returns
- **Data Source:** Zimbabwe Stock Exchange / Reserve Bank of Zimbabwe

---

## Data Schema

### 1. `data/raw/ZSE All Share Historical Data.csv`
- `Date`: Trading date (`MM/DD/YYYY` format)
- `Price`: Daily closing index price
- `Open`: Opening index price
- `High`: Intra-day high price
- `Low`: Intra-day low price
- `Change %`: Daily percentage price movement

### 2. `data/processed/zse_clean_returns.csv`
- `Date`: Chronological date index (`YYYY-MM-DD` format)
- `Price`: Cleaned numerical closing index price
- `Log_Return`: Continuous daily logarithmic return computed as:
  $$R_t = \ln\left(\frac{P_t}{P_{t-1}}\right)$$

---

## Data Quality & Preprocessing Protocol
1. **Trading Suspensions & Off-Days:** Weekend gaps and non-trading market closures were removed using explicit missing-value filtering (`filter(!is.na(Price) & Price > 0)`).
2. **Stationarity Transformation:** Raw index price levels $P_t$ exhibit integrated order $I(1)$ trends. Log transformation yields a covariance stationary series $I(0)$ validated via Augmented Dickey-Fuller ($DF = -13.2014, p < 0.0001$).
