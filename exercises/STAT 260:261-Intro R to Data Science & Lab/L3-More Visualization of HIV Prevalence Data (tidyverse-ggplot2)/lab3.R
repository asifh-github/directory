library(tidyverse)

hiv <- read.csv("HIVprev.csv", stringsAsFactors = FALSE)
hiv <- select(hiv, Country, year, prevelence)

head(hiv)
tail(hiv)

summary(hiv)

# 1
p <- ggplot(data=hiv, mapping=(aes(x=year, y=prevalence, group=Country))) +
  geom_line(alpha=0.5, mapping=(aes(color=prevalence))) +
  labs(y="estimated prevalence", title="Estimated HIV Prevalence 1990-2000")
p
# 2
p <- ggplot(data=hiv, mapping=(aes(x=year, y=prevalence)), color="blue") +
  geom_smooth(mapping=aes(group=Country), se=FALSE)
p
# 3
cc <- c("Botswana","Central African Republic","Congo","Kenya","Lesotho","Malawi",
        "Namibia","South Africa","Swaziland","Uganda","Zambia","Zimbabwe")
hihiv <- filter(hiv,Country %in% cc)
p <- ggplot(mapping=(aes(x=year, y=prevalence))) +
  labs(y="estimated prevalence", title="Estimated HIV Prevalence 1990-2000")
p_new <- p + geom_line(data=hiv, mapping=aes(group=Country), alpha=0.3, color="grey") +
  geom_line(data=hihiv, mapping=aes(group=Country), alpha=0.3, color="red")
p_newf <- p_new + geom_smooth(data=hiv, color="black") + geom_smooth(data=hihiv, color="red")
p_newf


# quiz 2
p <- ggplot(data=hiv, mapping=(aes(x=year, y=prevalence, group=Country))) +
  geom_smooth(color="green", se=FALSE) + labs(y="estimated prevalence (%)")
p

p_hi <- ggplot(data=hihiv, mapping=(aes(x=year, y=prevalence))) +
  geom_line(mapping=aes(group=Country), alpha=0.3, color="orange") + geom_smooth(color="blue")
p_hi