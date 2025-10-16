import pandas as pd
import statsmodels.api as sm
import matplotlib.pyplot as plt

data = pd.read_csv("Home_Market_Value.csv")

X = data["House Age"]
y = data["Market Value"]

X = sm.add_constant(X)

model = sm.OLS(y, X).fit()

print(model.summary())
