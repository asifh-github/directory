## 1
# a1
counts = function(x, n) {
  x_max = max(x) 
  x_min = min(x)
  n_diff = (x_max-x_min) / n
  result = vector(mode='numeric', length=n)
  for(i in 1:length(x)) {
    for(j in 1:n) {
      if(j == 1) {
        if (x[i]>=x_min & x[i]<=x_min+n_diff) {
          result[j] = result[j] + 1
          break
        }
      }
      if (x[i]>x_min+(n_diff*(j-1)) & x[i]<=x_min+(n_diff*(j))) {
        result[j] = result[j] + 1
        break
      }
    }
  }
  return(result)
}
counts(c(1, 1, 3, 2, 5, 6), 3)

# b
histo = function(x, n) {
  x_max = max(x) 
  x_min = min(x)
  n_diff = (x_max-x_min) / n
  counts = vector(mode='numeric', length=n)
  for(i in 1:length(x)) {
    for(j in 1:n) {
      if(j == 1){
        if(x[i]>=x_min & x[i]<=x_min+n_diff) {
          counts[j] = counts[j] + 1
          break
        }
      }
      if(x[i]>x_min+(n_diff*(j-1)) & x[i]<=x_min+(n_diff*j)) {
        counts[j] = counts[j] + 1
        break
      }
    }
  }
  plot(1, type='n', xlab='x', ylab='counts',
       xlim=c(x_min, x_max), ylim=c(0, max(counts))
       )
  for(i in 1:n) {
    lines(c(x_min+(n_diff*(i-1)), x_min+(n_diff*(i-1))), c(0, counts[i]))
    lines(c(x_min+(n_diff*i), x_min+(n_diff*i)), c(0, counts[i]))
    lines(c(x_min+(n_diff*(i-1)), x_min+(n_diff*i)), c(counts[i], counts[i]))
  }
  lines(c(x_min, x_max), c(0, 0))
}
histo(c(1, 1, 3, 2, 5, 6), 3)

## c
vec = c(rnorm(100, mean=-1, sd=1), rnorm(100, mean=1, sd=1))
histo(vec, 10)

## d
x = c(0, 0, 0, 1, 1, 2)
histo(x, 3)

## 2
library(RSQLite)
con = dbConnect(SQLite(), dbname="lab03.sqlite")
dbListTables(con)

mov_avg1 = "SELECT Edition, COUNT(Edition) AS TotalNumber
  FROM Olymp_meds 
  GROUP BY Edition"
out = dbGetQuery(con, mov_avg1)
out

plot(out$Edition, out$TotalNumber,
     main='Total number of athletes who obtained Olympic medals',
     xlab='year', ylab='Count', 
     type='p', col='red', lwd=2, las=2)

mov_avg2 = "CREATE VIEW tot_meds AS SELECT Edition, Count(Edition) AS TotalNumber
  FROM Olymp_meds
  GROUP BY Edition"
dbSendQuery(con, mov_avg2)
dbListTables(con)
dbGetQuery(con, "SELECT * FROM tot_meds")

# delete temp_table
# dbSendQuery(con, "DROP VIEW tot_meds")

mov_avg3 = "SELECT Edition, TotalNumber
  FROM tot_meds"
out = dbGetQuery(con, mov_avg3)
out

plot(out$Edition, out$TotalNumber,
     main='Total number of athletes who obtained Olympic medals',
     xlab='year', ylab='Count', 
     type='p', col='red', lwd=2, las=2)
lines(out$Edition, out$TotalNumber, col=1, lwd=2)

check = "SELECT * FROM tot_meds AS t,
  (SELECT t1.Edition, AVG(t2.TotalNumber) AS mavg
    FROM tot_meds AS t1, tot_meds AS t2
    WHERE t2.Edition BETWEEN (t1.Edition-4) AND (t1.Edition+4) 
    GROUP BY t1.Edition) AS sq
  WHERE (t.Edition=sq.Edition)"
movingAvg = dbGetQuery(con, check)
movingAvg

plot(out$Edition, out$TotalNumber,
     main='Total number of athletes who obtained Olympic medals',
     xlab='year', ylab='Count', 
     type='p', col='red', lwd=2, las=2)
lines(out$Edition, out$TotalNumber, col=1, lwd=2)
lines(movingAvg$Edition, movingAvg$mavg, type='l', col=3, lwd=2)
legend("topleft",lwd=2,lty=c(NA,1,1),pch=c(1,NA,NA),
       col=c(2,1,3),
       c("medals per year points",
         "medals per year line",
         "moving average"))

dbSendQuery(con, "DROP VIEW tot_meds")
dbListTables(con)

# a
library(rworldmap)
library(rworldxtra)
worldmap = getMap(resolution='high')
NrthAm = worldmap[which(worldmap$REGION == 'North America'), ]
plot(NrthAm, main='Pokemon in Vancouver', 
     xlim=c(-123.35, -122.65), ylim=c(49, 49.35))
dbGetQuery(con, "PRAGMA table_info('Vanpoke')")
query = "SELECT latitude, longitude
  FROM Vanpoke"
output = dbGetQuery(con, query)
points(output$longitude, output$latitude, col='orange', lwd=.5, cex=0.3)

# b
library(MASS)
library(sp)
plot(NrthAm, main='Pokemon in Vancouver', 
     xlim=c(-123.35, -122.65), ylim=c(49, 49.35))
# 2d kernel density estimation- kde2d
density = kde2d(output$longitude, output$latitude)
contour(kde, col='orange', labcex=0.7, add=TRUE)

# c
dbGetQuery(con, "PRAGMA table_info('Vanpoke')")
# (The peaks of the plot are in Stanley Park, North Vancouver, East Vancouver, and Burnaby. This is because the game is based on augmented reality and objectives of the game will largely available in places with higher player (population) density.)

# d
plot(NrthAm, main='Pokemon in Vancouver', 
     xlim=c(-123.35, -122.65), ylim=c(49, 49.35))
contour(kde, col=69, labcex=0.7, add=TRUE)
# stanley
points(-123.13999, 49.299999, col='red', lwd=1, cex=0.2)
text(-123.139999, 49.299999, labels='Stanley Park', cex=0.4)
# n.van
points(-123.066666, 49.316666, col='red', lwd=1, cex=0.2)
text(-123.066666, 49.316666, labels='North Vancouver', cex=0.4)
# ubc
points(-123.2460, 49.2606, col='red', lwd=1, cex=0.2)
text(-123.2460, 49.2606, labels='UBC', cex=0.4)
# sfu
points(-122.9199, 49.2781, col='red', lwd=1, cex=0.2)
text(-122.9199, 49.2781, labels='SFU', cex=0.4)
# burnaby
points(-122.994560, 49.246445, col='red', lwd=1, cex=0.2)
text(-122.994560, 49.246445, labels='Burnaby', cex=0.4)
# richmonds
points(-123.133568, 49.166592, col='red', lwd=1, cex=0.2)
text(-123.133568, 49.166592, labels='Richmond', cex=0.4)
# coquitlam
points(-122.793205, 49.283764, col='red', lwd=1, cex=0.2)
text(-122.793205, 49.283764, labels='Coquitlam', cex=0.4)
# vancouver
points(-123.116226, 49.246292, col='red', lwd=1, cex=0.2)
text(-123.116226, 49.246292, labels='Vancouver', cex=0.4)
# sea & land
text(-123.456136, 49.231787, col=4, labels='Sea', cex=1)
text(-122.927722, 49.201812, col=2, labels='Land', cex=1)
