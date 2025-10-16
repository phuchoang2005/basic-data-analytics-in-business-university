setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

data <- read.csv("Home_Market_Value.csv")

head(data)

model_single <- lm(Market.Value ~ House.Age, data = data)

summary(model_single)


multiple_r <- sqrt(summary(model_single)$r.squared)

r_squared <- summary(model_single)$r.squared

adj_r_squared <- summary(model_single)$adj.r.squared

f_stat <- summary(model_single)$fstatistic
significance_f <- pf(f_stat[1], f_stat[2], f_stat[3], lower.tail = FALSE)

coefficients <- summary(model_single)$coefficients[, "Estimate"]
p_values <- summary(model_single)$coefficients[, "Pr(>|t|)"]

cat("Multiple R:", multiple_r, "\n")
cat("R-squared:", r_squared, "\n")
cat("Adjusted R-squared:", adj_r_squared, "\n")
cat("Significance F:", significance_f, "\n\n")
cat("Coefficients:\n")
print(coefficients)
cat("\nP-values:\n")
print(p_values)

