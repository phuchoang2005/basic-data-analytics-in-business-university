import pandas as pd
import numpy as np
import statsmodels.api as sm
from sklearn.metrics import mean_absolute_error, mean_squared_error

data = pd.read_csv("Home_Market_Value.csv")

X1 = sm.add_constant(data["House Age"])
y = data["Market Value"]

model1 = sm.OLS(y, X1).fit()
y_pred1 = model1.predict(X1)


X2 = sm.add_constant(data[["House Age", "Square Feet"]])
model2 = sm.OLS(y, X2).fit()
y_pred2 = model2.predict(X2)

def regression_metrics(y_true, y_pred, model):
    mae = mean_absolute_error(y_true, y_pred)
    mape = np.mean(np.abs((y_true - y_pred) / y_true)) * 100
    mse = mean_squared_error(y_true, y_pred)
    rmse = np.sqrt(mse)
    r2 = model.rsquared
    adj_r2 = model.rsquared_adj
    return [mae, mape, mse, rmse, r2, adj_r2]

metrics = pd.DataFrame(
    {
        "Model 1: House Age": regression_metrics(y, y_pred1, model1),
        "Model 2: House Age + Square Feet": regression_metrics(y, y_pred2, model2)
    },
    index=["MAE", "MAPE (%)", "MSE", "RMSE", "R²", "Adj R²"]
)

print("\n Regression Comparison:")
print(metrics)
