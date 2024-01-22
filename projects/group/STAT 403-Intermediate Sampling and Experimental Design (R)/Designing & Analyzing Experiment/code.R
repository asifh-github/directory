library(tidyverse)

data = read.csv("/Users/asifh/Downloads/403-project(w)/full_exp_data.csv", header=TRUE, sep=',') 
data$humidity = factor(data$humidity)
data$plant = factor(data$plant)
data$position =  rep(c(1,2), times=40)
data
#check for outliers
boxplot(data$yield ~ data$humidity*data$plant, main="Boxplot of Yield", xlab="Treatment", ylab="Yield")
## one potential outlier 

model = lm(yield~ humidity*plant + greenhouse:humidity + position, data=data)
plot(model)

plot(data)
interaction.plot(data$humidity, data$plant, data$yield)
ggplot(data, aes(x=humidity, y=yield, color=plant)) +
       geom_point(position=position_jitter(width=0.1)) +
       stat_summary(fun.y=mean, geom="line", aes(group=plant)) +
       stat_summary(fun.y=mean, geom="point", shape=21, fill="white", size=3, aes(group=plant)) +
       labs(x="humidity", y="yield") +
       scale_color_discrete(name="plant") +
       theme_bw()

result = aov(yield~humidity * plant + 
               Error(greenhouse:humidity + position), data=data)
summary(result)

summary_data <- aggregate(yield ~ humidity + plant, data = data, FUN = mean)
summary_data$se <- aggregate(yield ~ humidity + plant, data = data, FUN = sd)$yield / sqrt(4)

ggplot(summary_data, aes(x = plant, y = yield, fill= humidity)) +
  geom_bar(position = position_dodge(), stat = "identity", width = 0.6) +
  geom_errorbar(aes(ymin = yield - se, ymax = yield + se), width = 0.2,
                position = position_dodge(0.6)) +
  labs(x = "plant", y = "Mean yeild", fill = "humidity") +
  theme_bw()

ggplot(data, aes(x=humidity, y=yield, color=plant)) +
  stat_summary(fun.y=mean, geom="line", aes(group=plant)) +
  stat_summary(fun.y=mean, geom="point", shape=21, fill="white", size=3, aes(group=plant)) +
  labs(x="humidity", y="yield") +
  scale_color_discrete(name="plant") +
  theme_bw()

aggregate(yield ~ humidity, data = data, FUN = mean)

aggregate(yield ~ plant, data = data, FUN = mean)


