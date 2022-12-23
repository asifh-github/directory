library(twitteR)
library(lubridate)
library(stringr)

source('access1.r')
data = userTimeline(
  'Translink',
  n = 3200,
  includeRts = FALSE,
  excludeReplies = TRUE
)
save(file='translink1.data', data)

load("~/Documents/stat240/asn5/translink.RData")

translink = function(year, month, day, hour) {
  result = list("start"=vector(mode='character'), "stop"=vector(mode='character'))
  date = ymd(paste(year, month, day, sep='-'))
  if(hour<10) {
    date_time = paste(date, hour, sep=' 0')  
  }
  else {
    date_time = paste(date, hour, sep=' ')
  }
  for(i in 1:length(data)) {
    if(date_time == substr(data[[i]]$created, 1, 13)) {
      if(str_detect(data[[i]]$text, "#RiderAlert")) {
        if(str_detect(data[[i]]$text, "CLEAR|(C|c)lear|ended|over|returned")) {
            result$stop[length(result$stop)+1] = 
            str_extract(data[[i]]$text, "[A-Z]?\\d+\\b")
        }
        else if(str_detect(data[[i]]$text, "detour|delays")) {
            result$start[length(result$start)+1] = 
            str_extract(data[[i]]$text, "[A-Z]?\\d+\\b")
        }
        print(data[[i]])
      }
    }
  }
  return(result)
}

x1 = "\\b(?<!\\:)[A-Z]?\\d+\\b(?!\\:)"
