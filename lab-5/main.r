
# Cài thư viện cần thiết
install.packages(c("ggplot2", "tseries", "forecast"))
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(ggplot2)
library(tseries)
library(forecast)

# Đọc dữ liệu
data <- read.csv("MSFT_prices_2013_present.csv")

# Đổi kiểu dữ liệu
data$date <- as.Date(data$date)

# Xem vài dòng đầu
head(data)

ggplot(data, aes(x = date, y = close)) +
  geom_line(color = "blue") +
  labs(title = "MSFT Closing Prices (2013 - Present)",
       x = "Date", y = "Closing Price (USD)") +
  theme_minimal()

adf_test <- adf.test(data$close)
adf_test

data$diff_close <- c(NA, diff(data$close))

# Vẽ lại sai phân
ggplot(data[-1,], aes(x = date, y = diff_close)) +
  geom_line(color = "darkgreen") +
  labs(title = "Differenced MSFT Closing Prices",
       x = "Date", y = "Differenced Close") +
  theme_minimal()

# Kiểm tra lại tính dừng
adf.test(na.omit(data$diff_close))

# Cài và nạp gói forecast nếu chưa có
library(forecast)

# Vẽ ACF và PACF cho chuỗi sai phân (đã có tính dừng)
par(mfrow = c(1, 2))   # chia đồ thị ra 2 ô ngang
acf(na.omit(data$diff_close), main = "ACF - Differenced MSFT Close")
pacf(na.omit(data$diff_close), main = "PACF - Differenced MSFT Close")
par(mfrow = c(1, 1))   # reset lại layout

library(forecast)
library(ggplot2)

# --- 1️⃣ Chia dữ liệu train / test ---
n <- nrow(data)
train_size <- round(n * 0.8)
train <- data$close[1:train_size]
test <- data$close[(train_size + 1):n]

# --- 2️⃣ Chuyển sang dạng chuỗi thời gian ---
train_ts <- ts(train, frequency = 1)
test_ts <- ts(test, frequency = 1, start = end(train_ts)[1] + 1)

# --- 3️⃣ Huấn luyện mô hình ARIMA ---
model <- Arima(train_ts, order = c(1,1,1))
summary(model)

# --- 4️⃣ Dự báo ---
forecast_horizon <- length(test_ts)
forecast_result <- forecast(model, h = forecast_horizon)

# --- 5️⃣ Plot kết quả ---
autoplot(forecast_result) +
  autolayer(test_ts, series = "Actual", color = "red") +  # đổi colour -> color
  labs(title = "ARIMA Forecast vs Actual MSFT Prices",
       x = "Time", y = "Closing Price (USD)") +
  theme_minimal()


# --- Đánh giá mô hình ---

# Lấy giá trị dự báo và giá trị thực tế
predicted <- as.numeric(forecast_result$mean)
actual <- as.numeric(test_ts)

# Tính các chỉ số đánh giá
MAE  <- mean(abs(predicted - actual))
MSE  <- mean((predicted - actual)^2)
RMSE <- sqrt(MSE)
MAPE <- mean(abs((predicted - actual) / actual)) * 100

# In kết quả
cat("Model Evaluation Metrics:\n")
cat("MAE  =", round(MAE, 4), "\n")
cat("MSE  =", round(MSE, 4), "\n")
cat("RMSE =", round(RMSE, 4), "\n")
cat("MAPE =", round(MAPE, 2), "%\n")


library(forecast)

# --- 1️⃣ Tự động xác định mô hình tốt nhất ---
auto_model <- auto.arima(train_ts, stepwise = FALSE, approximation = FALSE)
summary(auto_model)

# In ra các chỉ số AIC và BIC để so sánh
cat("Comparison of AIC and BIC:\n")
cat("Manual ARIMA(1,1,1):  AIC =", round(AIC(model), 2), " | BIC =", round(BIC(model), 2), "\n")
cat("Auto ARIMA:", auto_model$arma[1], auto_model$arma[6], auto_model$arma[2],
    " -> AIC =", round(AIC(auto_model), 2), " | BIC =", round(BIC(auto_model), 2), "\n\n")

# --- 2️⃣ Dự báo bằng mô hình auto.arima ---
forecast_auto <- forecast(auto_model, h = length(test_ts))

# --- 3️⃣ So sánh trực quan ---
autoplot(forecast_auto) +
  autolayer(test_ts, series = "Actual", color = "red") +
  labs(title = "Auto ARIMA Forecast vs Actual MSFT Prices",
       x = "Time", y = "Closing Price (USD)") +
  theme_minimal()

# --- 4️⃣ Đánh giá sai số mô hình auto ---
pred_auto <- as.numeric(forecast_auto$mean)
actual <- as.numeric(test_ts)

MAE_auto  <- mean(abs(pred_auto - actual))
MSE_auto  <- mean((pred_auto - actual)^2)
RMSE_auto <- sqrt(MSE_auto)
MAPE_auto <- mean(abs((pred_auto - actual) / actual)) * 100

cat("Auto ARIMA Model Evaluation:\n")
cat("MAE  =", round(MAE_auto, 4), "\n")
cat("MSE  =", round(MSE_auto, 4), "\n")
cat("RMSE =", round(RMSE_auto, 4), "\n")
cat("MAPE =", round(MAPE_auto, 2), "%\n\n")

# --- 5️⃣ So sánh với mô hình thủ công ---
cat("🔹 Comparison Summary:\n")
cat("Manual ARIMA(1,1,1):  MAE =", round(MAE, 4), " | RMSE =", round(RMSE, 4), " | MAPE =", round(MAPE, 2), "%\n")
cat("Auto ARIMA(", auto_model$arma[1], ",", auto_model$arma[6], ",", auto_model$arma[2], "): ",
    "MAE =", round(MAE_auto, 4), " | RMSE =", round(RMSE_auto, 4), " | MAPE =", round(MAPE_auto, 2), "%\n")
