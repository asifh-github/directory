library(tidyverse)
library(stringr)

# 1
# ready API_ILO_country_YU.csv to tibb youthID
youthUI <- read_csv("API_ILO_country_YU.csv")
youthUI

# 2
# pivot to reshape youthUI into longer tibb 
#   w/ cols Country Name, Country Code, year, & Unemployment Rate
# when reshaping, covert newly created year col to be int
# after, arrange rows by increasing year, f/b Country Name in each year
youthUI <- youthUI %>%
  pivot_longer(c(`2010`:`2014`), names_to="year", 
               values_to="Unemployment Rate", values_drop_na=TRUE,
               names_transform=list("year"=as.integer)) %>%
  arrange(year, `Country Name`)
youthUI

# 3
# plot unemployment rates by year for each "country" in youthUI
#   represent each time series by a line
# use appropriate alpha level to handle overplotting
youthUI_plot <- ggplot(youthUI, mapping=aes(
  x=year, y=`Unemployment Rate`, group=`Country Name`)) +
  geom_line(alpha=0.18, color="dark green")
youthUI_plot

# 4 
# use regular exp to extract subset of "countries"
#   w/ Country Name containing str- "(IDA & IBRD)" OR "(IDA & IBRD countries)" 
#   and save in a new tibb- youthDevel- can not use fixed()
# then, use regular expression to remove Country Names w/ ("IDA & IBRD"...)
#   from youthUI
pattern_find <- "^.*\\(IDA\\s\\&\\sIBRD(\\scountries\\)|\\)).*$" 
youthDevel <- youthUI %>%
  filter(youthUI$`Country Name`==str_extract(youthUI$`Country Name`, pattern_find))
youthDevel
## str_extract(youthUI$`Country Name`, pattern_find)

youthUI <-youthUI %>%
  filter(youthUI$`Country Name`==str_replace(
    youthUI$`Country Name`, pattern_find, "\\NA"))
youthUI
## str_replace(youthUI$`Country Name`, pattern_find, "\\NA")

# 5 
# plot unemployment rates by year for each region in youthDevel
#   w/ different colors for each region
#   include both points and lines for each region
# then, add layer that plots the ww unemployment data
#   from youthUI w/ Country.Name==World
youthDevel_plot <- ggplot(mapping=aes(
  x=year, y=`Unemployment Rate`, group=`Country Name`)) +
  geom_point(data=youthDevel, aes(color=`Country Name`)) + 
  geom_line(data=youthDevel, aes(color=`Country Name`))
youthDevel_plot

dat <- filter(youthUI, youthUI$`Country Name`=="World")
wVsDevel_plot <- youthDevel_plot + 
  geom_smooth(data=dat, color="black", size=1, se=FALSE)
wVsDevel_plot  
