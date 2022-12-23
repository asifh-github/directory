library(tidyverse)

# read csv
hiv <- read.csv("HIVprevRaw.csv", stringsAsFactors=FALSE)
head(hiv)
# make a copy of data set
hivcopy <- hiv
view(hivcopy)

# 1- rename first column to "Country"
?hiv
hiv <- rename(hiv, Country=Estimated.HIV.Prevalence.....Ages.15.49.)
view(hiv)

# 2- remove cols of 1997- 1989
hiv <- select(hiv, -(X1979:X1989))
view(hiv)

# 3- sort data in descending order of prevalence in 2011, print first six rows
hiv <- tibble(hiv, x=c(Country), y=c(X2011))
hiv <- (arrange(hiv, desc(y)))
head(hiv)
view(hiv)

# 4- use pipe to do task 1-3
hivcopy <- rename(hivcopy, Country=Estimated.HIV.Prevalence.....Ages.15.49.) %>%
  select(-(X1979:X1989)) %>%
  tibble(x=c(Country), y=c(X2011)) %>%
  arrange(desc(y))
head(hivcopy)
view(hivcopy)
