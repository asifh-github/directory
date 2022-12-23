library(tidyverse)

spec_csv("HIVprevRaw.csv")
# #1 rename first col to Country
# #2 remove col `1988` & `1989`
# #3 pivot Y/ prevalence into longer tibble of 3 cols:
#     Country, year, & prevalence,
#     also remove explicitly missing vals
#    Next, sort tibb by Country
hiv <- read_csv("HIVprevRaw.csv") %>% 
  rename(Country=`Estimated HIV Prevalence% - (Ages 15-49)`) %>%
  select(-`1988`:`1989`) %>%
  pivot_longer(c(`1979`:`2011`),
               names_to="year",
               values_to="prevalance",
               values_drop_na=TRUE) %>%
  arrange(Country)
view(hiv)

