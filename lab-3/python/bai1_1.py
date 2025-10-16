import pandas as pd
import statsmodels.api as sm

data = pd.read_csv("data.csv")

X = data[["Productivity", "Produced Cost"]]
y = data["Output of Product"]

X = sm.add_constant(X)

model = sm.OLS(y, X).fit()

print(model.summary())
