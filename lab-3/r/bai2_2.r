setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

data <- read.csv("Home_Market_Value.csv")

head(data)

model_multiple <- lm(Market.Value ~ House.Age + Square.Feet, data = data)

summary(model_multiple)

multiple_r <- sqrt(summary(model_multiple)$r.squared)

r_squared <- summary(model_multiple)$r.squared

adj_r_squared <- summary(model_multiple)$adj.r.squared

f_stat <- summary(model_multiple)$fstatistic
significance_f <- pf(f_stat[1], f_stat[2], f_stat[3], lower.tail = FALSE)

coefficients <- summary(model_multiple)$coefficients[, "Estimate"]
p_values <- summary(model_multiple)$coefficients[, "Pr(>|t|)"]

# In kết quả
cat("Multiple R:", multiple_r, "\n")
cat("R-squared:", r_squared, "\n")
cat("Adjusted R-squared:", adj_r_squared, "\n")
cat("Significance F:", significance_f, "\n\n")
cat("Coefficients:\n")
print(coefficients)
cat("\nP-values:\n")
print(p_values)
