# ==============================================================================
# 1. LOAD LIBRARIES
# ==============================================================================
library(readr)
library(dplyr)
library(xts)
library(rugarch)
library(tseries)
library(FinTS)

# ==============================================================================
# 2. LOAD DATA
# ==============================================================================
getwd()
setwd("~/ZSE research/ZSE research")
zse <- read_csv("ZSE All Share Historical Data(1).csv")

# ==============================================================================
# 3. CLEAN DATE
# ==============================================================================
zse$Date <- as.Date(zse$Date, format = "%m/%d/%Y")

# ==============================================================================
# 4. CLEAN PRICE
# ==============================================================================
zse$Price <- as.numeric(gsub(",", "", zse$Price))
zse <- zse %>%
  filter(!is.na(Price) & Price > 0)

# ==============================================================================
# 5. SORT DATA
# ==============================================================================
zse <- zse %>% arrange(Date)

# ==============================================================================
# 6. CREATE RETURNS
# ==============================================================================
zse$Return <- c(NA, diff(log(zse$Price)))

# ==============================================================================
# 7. CLEAN RETURNS
# ==============================================================================
zse_clean <- zse %>%
  filter(!is.na(Return) & is.finite(Return))

# ==============================================================================
# 8. CREATE xts OBJECT
# ==============================================================================
returns_xts <- xts(zse_clean$Return, order.by = zse_clean$Date)

# ==============================================================================
# 9. STATIONARITY TEST
# ==============================================================================
adf_result <- adf.test(zse_clean$Return)
print(adf_result)

# ==============================================================================
# 10. ARCH EFFECT TEST
# ==============================================================================
arch_result <- ArchTest(zse_clean$Return, lags = 12)
print(arch_result)

# ==============================================================================
# 11. GARCH(1,1) MODEL SPECIFICATION & FIT
# ==============================================================================
spec_11 <- ugarchspec(
  variance.model = list(
    model = "sGARCH",
    garchOrder = c(1, 1)
  ),
  mean.model = list(
    armaOrder = c(0, 0)
  ),
  distribution.model = "norm"
)

fit_11 <- ugarchfit(spec_11, data = returns_xts)

# ==============================================================================
# 12. GARCH(1,2) MODEL SPECIFICATION & FIT
# ==============================================================================
spec_12 <- ugarchspec(
  variance.model = list(
    model = "sGARCH",
    garchOrder = c(1, 2)
  ),
  mean.model = list(
    armaOrder = c(0, 0)
  ),
  distribution.model = "norm"
)

fit_12 <- ugarchfit(spec_12, data = returns_xts)

# ==============================================================================
# 13. GARCH(2,1) MODEL SPECIFICATION & FIT
# ==============================================================================
spec_21 <- ugarchspec(
  variance.model = list(
    model = "sGARCH",
    garchOrder = c(2, 1)
  ),
  mean.model = list(
    armaOrder = c(0, 0)
  ),
  distribution.model = "norm"
)

fit_21 <- ugarchfit(spec_21, data = returns_xts)

# ==============================================================================
# 14. MODEL SELECTION VIA INFORMATION CRITERIA
# ==============================================================================
ic_11 <- infocriteria(fit_11)
ic_12 <- infocriteria(fit_12)
ic_21 <- infocriteria(fit_21)

model_selection <- data.frame(
  Model = c("GARCH(1,1)", "GARCH(1,2)", "GARCH(2,1)"),
  AIC   = c(ic_11[1], ic_12[1], ic_21[1]),
  BIC   = c(ic_11[2], ic_12[2], ic_21[2]),
  Shibata = c(ic_11[3], ic_12[3], ic_21[3]),
  Hannan_Quinn = c(ic_11[4], ic_12[4], ic_21[4])
)

print(model_selection)

# ==============================================================================
# 15. PRINT MODEL FIT RESULTS
# ==============================================================================
show(fit_11)

# ==============================================================================
# 16. IN-SAMPLE VOLATILITY PLOT
# ==============================================================================
plot(
  zse_clean$Date,
  sigma(fit_11),
  type = "l",
  col = "blue",
  main = "Estimated Volatility (ZSE)",
  xlab = "Date",
  ylab = "Volatility"
)

# ==============================================================================
# 17. DIAGNOSTIC TESTS ON STANDARDIZED RESIDUALS
# ==============================================================================
residuals_std <- residuals(fit_11, standardize = TRUE)

Box.test(residuals_std, lag = 20, type = "Ljung-Box")
ArchTest(residuals_std, lags = 12)
jarque.bera.test(residuals_std)

# ==============================================================================
# 18. PERSISTENCE CALCULATION
# ==============================================================================
persistence <- coef(fit_11)["alpha1"] + coef(fit_11)["beta1"]
print(persistence)

# ==============================================================================
# 19. TRAIN-TEST SPLIT (80% / 20%)
# ==============================================================================
total_n <- length(returns_xts)
train_size <- floor(0.8 * total_n)
test_size <- total_n - train_size

# ==============================================================================
# 20. ROLLING ONE-STEP-AHEAD FORECASTING
# ==============================================================================
pred_vol <- rep(NA, test_size)

for (i in 1:test_size) {
  fit_roll <- ugarchfit(
    spec_11,
    data = returns_xts[1:(train_size + i - 1)]
  )
  
  forecast_roll <- ugarchforecast(
    fit_roll,
    n.ahead = 1
  )
  
  pred_vol[i] <- as.numeric(sigma(forecast_roll))
}

# ==============================================================================
# 21. EXTRACT ACTUAL VOLATILITY & DATES FOR TEST SET
# ==============================================================================
real_vol <- as.numeric(sigma(fit_11)[(train_size + 1):total_n])
test_dates <- zse_clean$Date[(train_size + 1):total_n]

# ==============================================================================
# 22. FORECAST VS ACTUAL VOLATILITY PLOT
# ==============================================================================
plot(
  test_dates,
  real_vol,
  type = "l",
  col = "blue",
  lwd = 2,
  main = "Actual vs Forecast Volatility",
  xlab = "Date",
  ylab = "Volatility"
)

lines(
  test_dates,
  pred_vol,
  col = "red",
  lwd = 2
)

legend(
  "topright",
  legend = c("Actual", "Forecast"),
  col = c("blue", "red"),
  lty = 1,
  lwd = 2
)

# ==============================================================================
# 23. ROOT MEAN SQUARED ERROR (RMSE)
# ==============================================================================
rmse <- sqrt(mean((real_vol - pred_vol)^2))
print(paste("RMSE:", rmse))
