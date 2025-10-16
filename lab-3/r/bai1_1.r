setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
data <- read.csv("data.csv")

model <- lm(Productivity ~ Produced.Cost + Output.of.Product, data = data)


summary(model)

multiple_r <- sqrt(summary(model)$r.squared)

r_squared <- summary(model)$r.squared

adj_r_squared <- summary(model)$adj.r.squared

f_statistic <- summary(model)$fstatistic
significance_f <- pf(f_statistic[1], f_statistic[2], f_statistic[3], lower.tail = FALSE)

coefficients <- summary(model)$coefficients[, "Estimate"]
p_values <- summary(model)$coefficients[, "Pr(>|t|)"]

cat("Multiple R:", multiple_r, "\n")
cat("R-squared:", r_squared, "\n")
cat("Adjusted R-squared:", adj_r_squared, "\n")
cat("Significance F:", significance_f, "\n\n")
cat("Coefficients:\n")
print(coefficients)
cat("\nP-values:\n")
print(p_values)
