setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

data <- read.csv("data.csv")

data$inv_X1 <- 1 / data$Produced.Cost
data$inv_X1X2 <- 1 / (data$Produced.Cost * data$Output.of.Product)

model2 <- lm(Productivity ~ Produced.Cost + Output.of.Product + inv_X1 + inv_X1X2, data = data)

summary(model2)

multiple_r <- sqrt(summary(model2)$r.squared)
r_squared <- summary(model2)$r.squared
adj_r_squared <- summary(model2)$adj.r.squared

f_stat <- summary(model2)$fstatistic
significance_f <- pf(f_stat[1], f_stat[2], f_stat[3], lower.tail = FALSE)

coefficients <- summary(model2)$coefficients[, "Estimate"]
p_values <- summary(model2)$coefficients[, "Pr(>|t|)"]

cat("Multiple R:", multiple_r, "\n")
cat("R-squared:", r_squared, "\n")
cat("Adjusted R-squared:", adj_r_squared, "\n")
cat("Significance F:", significance_f, "\n\n")
cat("Coefficients:\n")
print(coefficients)
cat("\nP-values:\n")
print(p_values)
