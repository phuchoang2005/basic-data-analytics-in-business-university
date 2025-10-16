setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

df <- read.csv("lab2.csv")

library(reshape2)
data_long <- melt(df, variable.name = "Group", value.name = "Value", na.rm = TRUE)

data_long$Group <- as.factor(data_long$Group)

summary_table <- aggregate(Value ~ Group, data = data_long, function(x) c(Count=length(x),
                                                                          Sum=sum(x),
                                                                          Mean=mean(x),
                                                                          Variance=var(x)))
print(do.call(data.frame, summary_table))

anova_model <- aov(Value ~ Group, data = data_long)
anova_result <- summary(anova_model)

print("ANOVA table:")
print(anova_result)

tukey_result <- TukeyHSD(anova_model)

print("Tukey's HSD results:")
print(tukey_result)

plot(tukey_result, las=1)
