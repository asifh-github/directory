library(tidyverse)
library(nycflights13)

# 1 add lat & lon of each airport dest to the flights table u/ join()
?airports
?flights

airports2 <- select(airports, faa, lat, lon)

flights <- flights %>%
  left_join(airports2, by=c("dest"="faa"))
flights

# 2 create a table w/ year, month, day, flight, tailnum combo
#     that have MORE THAN 1 flight...careful w/ tailnum NA 
#   then, use this table to filter the flights table 
#     after, select() carrier, flight, origin, dest
#   finally, detect airline used same flight number for trip from:
#     La Guardia to St. Louis in morning
#     Newark to Denver in afternoon
flights2 <- flights %>%
  count(year, month, day, tailnum, flight, sort=TRUE)%>%
  filter(n>1 & is.na(tailnum)==FALSE)
flights2 

flights %>% 
  semi_join(flights2) %>%
  group_by(year, month, day) %>%
  select(carrier, flight, origin, dest)
## (-> WN = Southwest Airlines Co.)

# 3 recreate top_dep_delay from lec_7 
#     for each 3 top-delay days report:
#     median, 3rd quartile, & max of dep_deley var in flights
top_dep_delay_total <- flights %>% 
  group_by(year, month, day) %>%
  summarize(total_delay=sum(dep_delay, na.rm=TRUE)) 

top_dep_delay_mid <- flights %>% 
  group_by(year, month, day) %>%
  summarize(mid=median(dep_delay, na.rm=TRUE)) 

top_dep_delay_3rd_quantile <- flights %>% 
  group_by(year, month, day) %>%
  summarize(quater_3_4=quantile(dep_delay, na.rm=TRUE, 0.75)) 

top_dep_delay_max <- flights %>% 
  group_by(year, month, day) %>%
  summarize(maximum=max(dep_delay, na.rm=TRUE)) 

top_dep_delay <- top_dep_delay_total %>%
  left_join(top_dep_delay_mid) %>%
  left_join(top_dep_delay_3rd_quantile) %>%
  left_join(top_dep_delay_max) %>%
  arrange(desc(total_delay)) %>%
  head(3)

flights %>% semi_join(top_dep_delay) 
