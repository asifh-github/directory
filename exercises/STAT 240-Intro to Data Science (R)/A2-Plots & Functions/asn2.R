getwd()
setwd("/Users/asifh/Documents/stat240/asn2/lab02/")

2+2
answer = 4-3*5+3*(1+2)
answer
# alt
(answer = 4-3*5+3*(1+2))
# same line 
2+2; answer = 4-3*5+3*(1+2); answer<2

# pref is '='
w <- 2
w = 1; (w <- 2)
w = 1; (w < -2)  

# find volume 
radius = 4
volume = 4/3*pi*radius^3
radius; volume

# complex 
radius = c(1, 3, 5, 7)
volume = 4/3*pi*radius^3
radius; volume
plot(radius, volume, main="volume vs. radius",
     xlab="radius", ylab="volume", 
     ylim=c(0, 1500), xlim=c(-1, 9))

## problem 1
par(mfrow=c(2, 2))
plot(radius, volume, main="Line-plot of volume vs. radius (type='l')",
     xlab="radius", ylab="volume", 
     ylim=c(0, 1500), xlim=c(-1, 9), 
     type='l', col="red", lwd=3)
plot(radius, volume, main="Point-plot of volume vs. radius (type='p')",
     xlab="radius", ylab="volume", 
     ylim=c(0, 1500), xlim=c(-1, 9), 
     type='p', col="purple", lwd=4)
plot(radius, volume, main="Line + Point plot of volume vs. radius (type='b')",
     xlab="radius", ylab="volume", 
     ylim=c(0, 1500), xlim=c(-1, 9), 
     type='b', col="blue", lwd=2)
plot(radius, volume, main="Empty plot of volume vs. radius (type='n')",
     xlab="radius", ylab="volume", 
     ylim=c(0, 1500), xlim=c(-1, 9), 
     type='n', col="black", lwd=3.5)


## problem 2
par(mfrow=c(1, 1))
radius = c(1:10000)
volume = 4/3*pi*radius^3
plot(radius, volume, main="Line + Point plot of volume vs. radius (using type='l')",
     xlab="radius", ylab="volume", 
     ylim=c(0, 1500000), xlim=c(0, 80), 
     type='l', col="green", lwd=2)

library(ggplot2)
dat = data.frame(raduis=radius, volume=volume)
dat
ggplot(dat, aes(x=radius, y=volume)) + geom_line(color="blue") +
  labs(x="radius", y="volume", title="Line + Point plot of volume vs. radius (ggplot)") +
  coord_cartesian(ylim=c(0, 1500000), xlim=c(0, 80))


## problem 3
x = 1:10
plot(x, x^2, main="Growth rate comparison of x^2 & 2^x",
     xlab="x", ylab="rate",
     type='l', col=1, lwd=3)
lines(x, 2^x, lty=2, col=2, lwd=3)
legend(x="topleft", col=1:2, lty=c(1, 2),
       c("x^2", "2^x"), bty='n')


## problem 4
poke = read.csv("pokemon_2019.csv")
head(poke)
plot(poke[, "Type_1"], horiz=TRUE, las=2)
poke[, "HP"]>200
poke[poke[, "HP"]>200, "HP"]
which(poke[, "HP"]>200)
poke[poke[, "HP"]>200, ]
poke_dat <- poke[c("Name", "Height_m", "isLegendary")]
poke_dat[, "Height_m"]>2
poke_dat[, "isLegendary"]=="True"
poke_dat = poke_dat[poke_dat[, "Height_m"]>2 & poke_dat[, "isLegendary"]=="True", "Name"]
cat(poke_dat, sep='\n')

poke_dat2 = poke[c("Attack", "Defense", "Body_Style")]
poke_dat2 = poke_dat2[poke_dat2[, "Body_Style"]=="head_arms" | poke_dat2[, "Body_Style"]=="serpentine_body", ]
plot(poke_dat2[["Attack"]], poke_dat2[, "Defense"], 
     main="Attack vs. Defense", xlab="attack", ylab="defense",
     type='p', col="pink", lwd=3)


## problem 5
pokenew = poke[1, ]
pokenew[1, ] = NA
pokenew$Name = "Hasan"
pokenew$Type_1 = "student"
pokenew
pokemonextra = rbind(pokenew, poke)
dim(poke)
dim(pokemonextra)
summary(poke)
summary(pokemonextra)
head(poke)
head(pokemonextra)
plot(pokemonextra[, "Type_1"], las=2)


## problem 6
library(RSQLite)
A = function(B) { C = B + 7; return(C) }
A(22)
fib_sum = function(n) {
  if(n == 0) {
    return(0)
  } 
  if(n == 1) {
    return(1)
  }
  return(fib_sum(n-1) + fib_sum(n-2) + 1)
}
fib_sum(20)
fib_sum(15)