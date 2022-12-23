library(tidyverse)
library(forcats)
library(lubridate)

yvr <- read_csv("weatherYVR.csv")
yvr

# 1
# coerce `Data/Time` var to date obj & rename it Date
yvr <- yvr %>%
  mutate(`Date/Time` = ymd(`Date/Time`)) %>%
  rename("Date"=`Date/Time`)
yvr

# 2
# make time series plot w/ lines of maximum temp by day
dailyTempYvrPlot <- ggplot(yvr, aes(x=Date, y=`Max Temp`)) + geom_line(color="light pink")
dailyTempYvrPlot

# 3 
# change Month var to factor
# hint: month(label=TRUE), will extract month from date-time obj 
yvr <- yvr %>%
  mutate(Month=month(Date, label=TRUE))
yvr

# 4
# plot avg max temp vs. month 
# then, re-do this plot with months ordered by average maximum
mothlyTempP1 <- yvr %>% group_by(Month) %>%
  summarize(average_max_temp=mean(`Max Temp`, na.rm=TRUE)) %>%
  ggplot(aes(x=Month, y=average_max_temp)) + geom_point()
mothlyTempP1

mothlyTempP2 <- yvr %>% group_by(Month) %>%
  summarize(average_max_temp=mean(`Max Temp`, na.rm=TRUE)) %>%
  ggplot(aes(x=fct_reorder(Month, average_max_temp), y=average_max_temp)) + 
  geom_point(color="gold")
mothlyTempP2
