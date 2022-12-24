library(stringr)
library(lubridate)

dates = c()
titles = c()
synopses = c()
ratings = c()
count = 0
total = 1014

# loop over the years
for(year in 1999:2022) {
  # download year webpage 
  f = sprintf('downloads/years/y%04d.html', year)
  if (!file.exists(f)) {
    download.file(sprintf('https://www.imdb.com/title/tt0388629/episodes?year=%d', year), f)
  }
  
  # read file 
  s = readChar(f, file.info(f)$size)
  # get rid of new-line chars
  s = gsub("[\r\n]", "", s)
  
  # match all airdates 
  # (for check b/c episode no. not consistent on website, need dates)
  m1 = str_match_all(s, "<div class=\"airdate\">(.*?)</div>")
  m1 = m1[[1]]
  l1 = dim(m1)[1]
  # match all episode links
  m2 = str_match_all(s, "<strong><a href=\"/title/tt(.*?)\"")
  m2 = m2[[1]]
  l2 = dim(m2)[1]
  
  # simple check for consistency
  if(l1 == l2) {
    # loop over the episodes
    for(episode in 1:l2) {
      # programmer progress ui
      count = count + 1
      print(paste0(count, ' \ ', total, ' Completed..'))
      # get rid of white-space(s)
      d = trimws(m1[episode,2])
      u = trimws(m2[episode,2])
      
      # get date
      #d = dmy(d)
      dates = c(dates, d)
      
      # download episode info.
      token = sprintf('y%04de%02d', year, episode)
      url = paste0('https://www.imdb.com/title/tt', u)
      f = paste0('downloads/episodes/', token, '.html')
      if (!file.exists(f)) {
        download.file(url, f)
      }
      
      # read file 
      s = readChar(f, file.info(f)$size)
      # get rid of new-line chars
      s = gsub("[\r\n]", "", s)
      
      # match title from episode 
      m = str_match(s, ',"name":"(.*?)",')
      titles = c(titles, m[[2]])
      # match synopsis from episode 
      m = str_match(s, '"plot":\\{"plotText":\\{"plainText":"(.*?)",')
      synopses = c(synopses, m[[2]])
      # match ratings from episode 
      m = str_match_all(s, ',"ratingValue":(.*?)\\},')
      ratings = c(ratings, as.numeric(m[[1]][dim(m[[1]])[1],2]))
    }
  }
  else {
    print("-Data NOT Consistent-")
  }
}
print("End of process--")

# create df
df = data.frame(date=dates, title=titles, rating = ratings, 
                synopsis = synopses)
(dim(df))
View(df)
