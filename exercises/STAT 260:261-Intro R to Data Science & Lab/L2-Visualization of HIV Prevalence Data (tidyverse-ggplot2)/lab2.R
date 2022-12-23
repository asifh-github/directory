library(tidyverse)

hiv <- read.csv("HIVprev.csv", stringsAsFactors = FALSE)
hiv <- select(hiv, Country, year, prevelence)

head(hiv)
tail(hiv)

summary(hiv)

# 1
p <- ggplot(data=hiv, mapping=(aes(x=year, y=prevalence, group=Country))) + 
  geom_line()
p
# 2
p <- ggplot(data=hiv, mapping=(aes(x=year, y=prevalence, group=Country))) + 
  geom_line(alpha=0.2)
p
## -> (using lower value for alpha reveals majority of the countries have a low prevalence) 
## -> (overcomes overplotting/lines density cab be observed using alpha)
# 3
cc <- c("Botswana","Central African Republic","Congo","Kenya","Lesotho","Malawi",
        "Namibia","South Africa","Swaziland","Uganda","Zambia","Zimbabwe")
hihiv <- filter(hiv,Country %in% cc)
p <- ggplot(data=hihiv, mapping=(aes(x=year, y=prevalence, group=Country))) +
  geom_line(alpha=0.8, color="red")
p
