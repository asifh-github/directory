library(tidyverse)

# csv files w vars- ID & res
dfiles <- dir("Lab10Data", full.names=TRUE)
dfiles

# 1
# read 1st datafile into tibb ex_data
# rename col res ro experiment1 
#  u/ names(ex_data)[2] <- "experiment1"
ex_data <- read_csv(dfiles[1])
names(ex_data)[2] <- "experiment1"
ex_data

# 2
# write a func read_ex() that takes dfiles 
#  & experiment number i as args 
#  & returns a tibb w/ col name res change to experiment number
#  eg. read_ex(dfiles, 1) returns same tibb in q1
read_ex <- function(x, n, na.rm=TRUE) {
  tibb <- read_csv(x[n])
  names(tibb)[2] <- paste("experiment", n, sep="")
  return(tibb)
}

# 3
# use func from q2 & read 2nd datafile
# join 2nd file to ex_data by ID
tibb <- read_ex(dfiles, 2)
ex_data <- ex_data %>% left_join(tibb, by="ID")
ex_data

# 4 
# write func read_ex_data() that takes folder name as arg
# & reads all datafiles names from the folder
# call read_ex() to read first datafile into ex_data
# loop through remaining data files, 
#  successively joining them to ex_data
# & return ex_data
read_ex_data <- function(f_name) {
  dfiles <- dir(f_name, full.names=TRUE)
  ex_data <- read_ex(dfiles, 1)
  for(i in 2:length(dfiles)) {
    tibb <- read_ex(dfiles, i)
    ex_data <- ex_data %>% left_join(tibb, by="ID")
  }
  return(ex_data)
}
ex_data <- read_ex_data("Lab10Data")
ex_data
