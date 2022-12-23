library(tidyverse)

dfiles <- dir("Lab11Data", full.names=TRUE)
dfiles

# 1
# read the first file and print it 
# then, rename cols to x & y 
# repeat for 2nd file
# how many obs?
study_data <- read_csv(dfiles[1]) 
names(study_data)[1] = "x" 
names(study_data)[2] = "y"
study_data
## (-> 100 obs)
study_data <- read_csv(dfiles[2]) 
names(study_data)[1] = "x" 
names(study_data)[2] = "y"
study_data
## (-> 150 obs)

# 2
# use vector() to create empty vec- ff t/ mode=list & len=9
# now, write a for() to loop over 9 files in d files
#   for each, read file into tib & rename cols to x & y
#   and, copy tib to a ele of list- ff 
ff <- vector(mode="list", length=9)
for( i in 1:length(dfiles)) {
  study_data <- read_csv(dfiles[i])
  names(study_data)[1] = "x"
  names(study_data)[2] = "y"
  ff[[i]] = study_data
}
ff

# 3
# write func- read.study_data t/ take dfiles as input
# reads data files into list
# asssigns class 'study_data' to list & returns list
# u/ length(dfiles)
read.study_data <- function(dfiles, len=length(dfiles)) {
  ff <- vector(mode="list", length=len)
  for(i in 1:len){
    study_data <- read_csv(dfiles[i])
    names(study_data) = c("x", "y")
    ff[[i]] = study_data
  }
  class(ff) <- "study_data"
  return(ff)
}
read.study_data(dfiles, 2)

# 4 
# write func- plot.study_data() t/ takes obj of class 'study_data' as input
# First 5 lines of code are following:
##  dat <- NULL
##  for(i in seq_along(ff)) {
##    d <- ff[[i]]
##    dat <- rbind(dat, tibble(study=i, x=d$x, y=d$y))
##  }
# then, coerce study to a factor
# make ggplot() of y vs. x w/ diff color studies
# add points and smoothers to the plot
plot.study_data <- function(study_data) {
  dat <- NULL
  for(i in seq_along(study_data)) {
    d <- study_data[[i]]
    dat <- rbind(dat, tibble(study=i, x=d$x, y=d$y))
  }
  dat[["study"]] <- factor(dat[["study"]])
  p <- ggplot(dat, aes(x=x, y=y, color=study)) + 
    geom_smooth(se=FALSE) + geom_point(alpha=0.5)
  return(p)
}
study_data_plot <- plot(read.study_data(dfiles))
study_data_plot
