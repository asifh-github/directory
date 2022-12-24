library(stringr)
library(lubridate)

# create directory
dir.create('downloads/years', showWarnings = FALSE, recursive = TRUE)
dir.create('downloads/episodes', showWarnings = FALSE, recursive = TRUE)

episode = 1

# download year->1999 & epi->1 webpage
download.file('https://www.imdb.com/title/tt0388629/episodes?year=1999', 
              'downloads/years/y99.html')

#<div class="airdate">
#2 Nov. 2013
#</div>
#   <strong><a href="/title/tt0947442/?ref_=ttep_ep1"
#title="Ore wa Rufi! Kaizoku O ni Naru Otoko Da!" itemprop="name">Ore wa Rufi! 
# Kaizoku O ni Naru Otoko Da!</a></strong>

# read file 
f = 'downloads/years/y99.html'
s = readChar(f, file.info(f)$size)
# get rid of new-line chars
s = gsub("[\r\n]", "", s)
# match all airdate
m = str_match_all(s, "<div class=\"airdate\">(.*?)</div>")
m = m[[1]]
l1 = dim(m)[1]
date = trimws(m[1,2])
date = dmy(date)
# match all episode link
m = str_match_all(s, "<strong><a href=\"/title/tt(.*?)\"")
m = m[[1]]
l2 = dim(m)[1]
u = trimws(m[1,2])

# download episode->1 info.
token = 'y99e01'
url = paste0('https://www.imdb.com/title/tt', u)
f = paste0('downloads/episodes/', token, '.html')
download.file(url, f)
# read file 
s = readChar(f, file.info(f)$size)
# get rid of new-line chars
s = gsub("[\r\n]", "", s)
# match title from episode 
# "name":"Ore wa Rufi! Kaizoku O ni Naru Otoko Da!"
m = str_match(s, ',"name":"(.*?)",')
title = m[[2]]
# match synopsis from episode 
# "plot":{"plotText":{"plainText":"Alvida pirates plunder a ship only to find 
# a barrel containing a strange boy names Luffy who is on a quest to find the 
# legendary \"One Piece\" and become the King of Pirates."
m = str_match(s, '"plot":\\{"plotText":\\{"plainText":"(.*?)",')
synopsis = m[[2]]
# match ratings from episode 
# "ratingValue":7.9
m = str_match_all(s, ',"ratingValue":(.*?)\\},')
rating = as.numeric(m[[1]][2,2])

# create df
df = data.frame(episode=episode, title=title, date=date, rating = rating, 
                synopsis = synopsis)
View(df)
