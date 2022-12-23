library(twitteR)
library(lubridate)
library(stringr)

# access twitter data
source('access1.r')
data = userTimeline(
  'Translink',
  n = 3200,
  includeRts = FALSE,
  excludeReplies = TRUE
)
save(file='translink1.data', data)

# loads given data from folder
load("~/Documents/stat240/asn5/translink.RData")

## a
translink = function(year, month, day, hour) {
  # creates list with two vectors- start & stop
  result = list("start"=vector(mode='character'), "stop"=vector(mode='character'))
  # creates data-time with function paras (assuming all paras are int)
  date = ymd(paste(year, month, day, sep='-'))
  # hour [0, 24)
  if(hour<10) {
    date_time = paste(date, hour, sep=' 0')  
  }
  else {
    date_time = paste(date, hour, sep=' ')
  }
  # loops through entire data
  for(i in 1:length(data)) {
    # picks element with/matching date-time 
    if(date_time == substr(data[[i]]$created, 1, 13)) {
      # picks element with/containing bus route disruptions 
      if(str_detect(data[[i]]$text, "#RiderAlert")) {
        # checks if disruptions have STOPED
        if(str_detect(data[[i]]$text, "CLEAR|(C|c)lear|ended|over|returned")) {
          # gets rid of date/time/street no. from string element
          vec_str = str_extract(data[[i]]$text, ".+detour")
          # extracts all bus no. t/ stopped having disruptions
          vec_temp = str_extract_all(vec_str, "(?<!\\:)[A-Z]?\\d+\\b(?!\\:)")
          # loops to insert disruptions into vector 'stop'
          for(j in 1:length(vec_temp[[1]])) {
            result$stop[length(result$stop)+1] = vec_temp[[1]][j]
          }
        }
        # checks if disruption has STARTED
        else if(str_detect(data[[i]]$text, "detour|delays")) {
          # gets rid of date/time/street no. from string element
          vec_str = str_extract(data[[i]]$text, ".+detour")
          # extracts all bus no. t/ started having disruptions
          vec_temp = str_extract_all(vec_str, "(?<!\\:)[A-Z]?\\d+\\b(?!\\:)")
          # loops to insert disruptions into vector 'start'
          for(j in 1:length(vec_temp[[1]])) {
            result$start[length(result$start)+1] = vec_temp[[1]][j]
          }
        }
        print(data[[i]])
      }
    }
  }
  return(result)
}

## b
translink(2020, 1, 26, 3)
#-> 
translink(2020, 1, 28, 1)
#->
translink(2020, 1, 28, 4)
#->
translink(2020, 2, 12, 19)
#->