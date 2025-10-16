import pandas as pd
import statsmodels.api as sm

data = pd.read_csv("data.csv")

data["inv_X1"] = 1 / data["Productivity"]
data["inv_X1X2"] = 1 / (data["Productivity"] * data["Produced Cost"])

X = data[["Productivity", "Produced Cost", "inv_X1", "inv_X1X2"]]
y = data["Output of Product"]

X = sm.add_constant(X)

model = sm.OLS(y, X).fit()

print(model.summary())
