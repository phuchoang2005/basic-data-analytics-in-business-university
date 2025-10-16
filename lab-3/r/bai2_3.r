setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

data <- read.csv("Home_Market_Value.csv")

model_single <- lm(Market.Value ~ House.Age, data = data)

model_multiple <- lm(Market.Value ~ House.Age + Square.Feet, data = data)


if(!require(Metrics)) install.packages("Metrics")
library(Metrics)

pred_single <- predict(model_single, data)
pred_multiple <- predict(model_multiple, data)

actual <- data$Market.Value

MAE_single  <- mae(actual, pred_single)
MAPE_single <- mean(abs((actual - pred_single) / actual)) * 100
MSE_single  <- mse(actual, pred_single)
RMSE_single <- rmse(actual, pred_single)
R2_single   <- summary(model_single)$r.squared
AdjR2_single <- summary(model_single)$adj.r.squared

MAE_multi  <- mae(actual, pred_multiple)
MAPE_multi <- mean(abs((actual - pred_multiple) / actual)) * 100
MSE_multi  <- mse(actual, pred_multiple)
RMSE_multi <- rmse(actual, pred_multiple)
R2_multi   <- summary(model_multiple)$r.squared
AdjR2_multi <- summary(model_multiple)$adj.r.squared

compare_models <- data.frame(
  Metric = c("MAE", "MAPE (%)", "MSE", "RMSE", "R-squared", "Adjusted R-squared"),
  Single_Model = c(MAE_single, MAPE_single, MSE_single, RMSE_single, R2_single, AdjR2_single),
  Multiple_Model = c(MAE_multi, MAPE_multi, MSE_multi, RMSE_multi, R2_multi, AdjR2_multi)
)

print(compare_models)
