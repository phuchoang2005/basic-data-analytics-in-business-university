setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(moments)


csv_file <- "VNZ_STOCK_DATA_AUGUST.csv"
df <- read.csv(csv_file)

column <- "Total_Value"
data <- na.omit(df[[column]])
#CENTRAL TENDENCY
mean_value <- mean(data)
median_value <- median(data)
mode_value <- as.numeric(names(sort(table(data), decreasing = TRUE)[table(data) == max(table(data))]))
quartiles <- quantile(data, probs = c(0.25, 0.5, 0.75))

#DISPERSION
variance_value <- var(data)
std_dev <- sd(data)
range_value <- diff(range(data))
sem_value <- sd(data) / sqrt(length(data))

#SHAPE
skewness_value <- skewness(data)
kurtosis_value <- kurtosis(data)

#PRINT RESULTS

cat("Descriptive Statistics for", column, "\n")
cat("\n")
cat("Mean:", mean_value, "\n")
cat("Median:", median_value, "\n")
cat("Mode:", paste(mode_value, collapse = ", "), "\n")
cat("Quartiles:\n"); print(quartiles)

cat("Variance:", variance_value, "\n")
cat("Standard Deviation:", std_dev, "\n")
cat("Range:", range_value, "\n")
cat("Standard Error of Mean:", sem_value, "\n")

cat("Skewness:", skewness_value, "\n")
cat("Kurtosis:", kurtosis_value, "\n")

# Histogram
hist(data, main = paste("Histogram of", column),
     xlab = column, col = "lightblue", border = "black", breaks = 10)
abline(v = mean_value, col = "red", lwd = 2, lty = 2)
abline(v = median_value, col = "green", lwd = 2, lty = 3)
legend("topright", legend = c(paste("Mean =", round(mean_value, 2)),
                              paste("Median =", round(median_value, 2))),
       col = c("red", "green"), lty = c(2, 3), lwd = 2)

# Box Plot
boxplot(data, main = paste("Box Plot of", column),
        ylab = column, col = "lightgreen", border = "darkgreen")
grid(nx = NA, ny = NULL)
