# course url
course_url = "https://www.sfu.ca/outlines.html?2022/spring/stat/240/d100"
course_page = readLines(course_url)
# check the number of elements in the vector
length(course_page)
# arbitrary set of 10 lines of html
course_page[240:250]
grep('<h3', course_page)
grep('<h3', course_page, value = T)
heading_index = grep('<h3', course_page)
# note this gives us the same result as using grep(, value = T)
course_page[heading_index]
heading = course_page[(heading_index-1):(heading_index+1)]
heading

download.file(course_url, "~/Documents/stat240/asn6/page.html")

## 1
# a
# extract all h3 heading 
# remove html formatting pieces and replace them with white space
(heading3 = grep("<h3",course_page,value=TRUE))
(heading3a = gsub("<[^<>]+>", " ", heading3))
gsub("\\s{2,}", " ", heading3a)
# b 
# extract course number 
cnum =  grep('<h1 id="name"',course_page,value=TRUE)
cnum = gsub("<[^<>]+>", " ", cnum)
cnum = gsub("\\s{2,}", " ", cnum)
cnum
# c
# extract course title
ctitle = grep('<h2 id="title"',course_page)
ctitle = course_page[ctitle + 1]
ctitle = gsub("\\s{2,}", " ", ctitle)
ctitle
# d
# extract instructor
cins = grep('<h4>Instructor',course_page)
cins = course_page[cins + 1]
cins = gsub("<[^<>]+>", " ", cins)
cins = gsub("\\s{2,}", " ", cins)
cins
# e 
# extract course time & location
ctime_l = grep('<h4>Course Times',course_page)
ctime_l = course_page[ctime_l + 1]
ctime_l = gsub("<[^<>]+>", " ", ctime_l)
ctime_l = gsub("\\s{2,}", " ", ctime_l)
ctime_l = gsub("&ndash;", "-", ctime_l)
ctime_l

## 2
# vector of website links
courses = c('https://www.sfu.ca/outlines.html?2017/spring/evsc/100/d100',
            'https://www.sfu.ca/outlines.html?2018/fall/stat/452/d100',
            'https://www.sfu.ca/outlines.html?2022/spring/stat/100/d100',
            'https://www.sfu.ca/outlines.html?2022/spring/stat/201/d900',
            'https://www.sfu.ca/outlines.html?2022/spring/stat/203/d100',
            'https://www.sfu.ca/outlines.html?2022/spring/stat/270/d100',
            'https://www.sfu.ca/outlines.html?2021/fall/stat/330/d100',
            'https://www.sfu.ca/outlines.html?2021/fall/stat/350/d100')
# vectors of cols 
course_number = vector(mode="character", length=length(courses))
course_title = vector(mode="character", length=length(courses))
course_instructor = vector(mode="character", length=length(courses))
course_time_location = vector(mode="character", length=length(courses))
class_number = vector(mode="character", length=length(courses))
class_delivery = vector(mode="character", length=length(courses))
# for-loop
for(i in 1:length(courses)) {
  course_page = readLines(courses[i])
  # extract course 
  cnum =  grep('<h1 id="name"',course_page,value=TRUE)
  cnum = gsub("<[^<>]+>", " ", cnum)
  cnum = gsub("\\s{2,}", " ", cnum)
  course_number[i] = cnum
  # extract course title
  ctitle = grep('<h2 id="title"',course_page)
  ctitle = course_page[ctitle + 1]
  ctitle = gsub("\\s{2,}", " ", ctitle)
  course_title[i] = ctitle
  # extract course instructor
  cins = grep('<h4>Instructor',course_page)
  cins = course_page[cins + 1]
  cins = gsub("<[^<>]+>", " ", cins)
  cins = gsub("\\s{2,}", " ", cins)
  course_instructor[i] = cins
  # extract course time & location
  ctime_l = grep('<h4>Course Times',course_page)
  ctime_l = course_page[ctime_l + 1]
  ctime_l = gsub("<[^<>]+>", " ", ctime_l)
  ctime_l = gsub("\\s{2,}", " ", ctime_l)
  ctime_l = gsub("&ndash;", "-", ctime_l)
  course_time_location[i] = ctime_l
  # extract class number and delivery
  heading3 = grep("<h3",course_page,value=TRUE)
  heading3 = gsub("<[^<>]+>", " ", heading3)
  heading3 = gsub("\\s{2,}", " ", heading3)
  class_number[i] = heading3[1]
  class_delivery[i] = heading3[2]
}
# data-frame 
result_df = data.frame(courseNumber=course_number, courseTitle=course_title, 
                       courseInstructor=course_instructor, courseTimeLocation=course_time_location,
                       classNumber=class_number, classDelivery=class_delivery)
result_df

## 3
library(rvest)
library(stringr)
library(zoo)
# example 1
movie_url = "https://www.imdb.com/chart/boxoffice/"
movie_table = read_html(movie_url)
length(html_nodes(movie_table, "table"))
html_table(html_nodes(movie_table, "table")[[1]])
html_table(html_nodes(movie_table, "table")[[2]])
# example 2
park_url = "https://en.wikipedia.org/wiki/List_of_National_Parks_of_Canada"
parks = read_html(park_url)
length(html_nodes(parks, "table"))
html_table(html_nodes(parks, "table")[[1]])
park_table = html_table(html_nodes(parks, "table")[[1]])
# a
# scrape box-office-performance & critical-&-public-response tables
# obtain the tables in a single data-frame
url = "https://en.wikipedia.org/wiki/List_of_Marvel_Cinematic_Universe_films"
url_table = read_html(url)
length(html_nodes(url_table, "table"))
# box-office-performance
performance = html_table(html_nodes(url_table, "table")[[6]])
# critical-&-public-response 
response = html_table(html_nodes(url_table, "table")[[7]])
View(performance)
View(response)
# clean tables
performance = performance[performance[, "Film"]!="Phase One" & performance[, "Film"]!="Phase Two" & performance[, "Film"]!="Phase Three", ]
performance = performance[3:25, ]
response = response[response[, "Film"]!="Phase One" & response[, "Film"]!="Phase Two" & response[, "Film"]!="Phase Three", ]
response = response[3:25, ]
# merge tables
marvel_df = merge(performance, response, 
                  by.x="Film", by.y="Film")
marvel_df
# b
# clean table and print first 10 rows 
names(marvel_df)
# rename cols
names(marvel_df)[2] = "Year"
names(marvel_df)[5] = "Worldwide Box Office Gross"
names(marvel_df)[10] = "Rotten Tomatoes"
names(marvel_df)[11] = "Metacritic Scores"
# new data-frame
marvel_movies = marvel_df[, c(1, 2, 5, 8, 10, 11)]
# change Release year to numeric
marvel_movies$`Year` = as.numeric(
  str_replace(marvel_movies$`Year`, ".+,\\s", "")
  ) 
# change Worldwide Box office gross to numeric
marvel_movies$`Worldwide Box Office Gross` = as.numeric(
  str_replace_all(marvel_movies$`Worldwide Box Office Gross`, "\\$|,", "")
  )
# change Budget to numeric, taking lower-bound value 
marvel_movies$Budget = as.numeric(
  str_extract(marvel_movies$Budget, "\\d+\\.?\\d+?\\b")
  ) * 1000000 #convert to million
# change Rotten Tomatoes to numeric
marvel_movies$`Rotten Tomatoes` = as.numeric(
  str_extract(marvel_movies$`Rotten Tomatoes`, "\\d+\\b")
  )
# change Metacritic Scores to numeric
marvel_movies$`Metacritic Scores` = as.numeric(
  str_extract(marvel_movies$`Metacritic Scores`, "\\d+\\b")
  )
marvel_movies[1:10, ]
# c 
# plot moving avg of Worldwide-Box-office-gross & budget vs. time in a single plot
# for clarity, use log10 for dollar amounts
# sort data using year and store it 
mm_df = marvel_movies[order(marvel_movies$Year), ]
# moving average of box-office-gross & budget 
# using interval length == 3
interval = 3
budget_ma = rollmean(mm_df$Budget, interval)
box_office_ma = rollmean(mm_df$`Worldwide Box Office Gross`, interval)
year = mm_df$Year[(1+((interval-1)/2)):(length(mm_df$Year)-((interval-1)/2))]
# plot
plot(year, log10(box_office_ma), type="l",
     main="Marvel movies phase 1, 2, & 3\n (Budget and Box Office Gross Over Time)",
     xlab="year", ylab="moving_average in log10 base", 
     ylim=c(8, 10),
     col="red", lwd=2)
lines(year, log10(budget_ma), 
      col="blue", lwd=2)
legend(2008, 10, c('Box office gross', 'Budget'),  bty="n", col=c('red', 'blue'), lty=1, lwd=2)
# d
# plot log10(revenue) over time for marvel movies
revenue = vector(mode="numeric", length=length(box_office_ma))
for(i in 1:length(revenue)) {
  revenue[i] = box_office_ma[i] - budget_ma[i]
}
plot(year, log10(revenue), type="l", 
     main="Marvel movies phase 1, 2, & 3\n (Revenue Over Time)",
     xlab="year", ylab="moving_average_revenue in log10 base",
     ylim=c(8.3, 9.7),
     col=3, lwd=2)
legend(2008, 9.7, c('Revenue'),  bty="n", col=3, lty=1, lwd=2)
# e
# plot log10(budget_ma) & log10(box_office_ma) vs. Rotten Tomatoes
# include moving average for Rotten Tomatoes ratings w.r.t. budget
# sort data using Rotten Tomatoes and store it 
mm_df2 = marvel_movies[order(marvel_movies$`Rotten Tomatoes`), ]
# moving average of rotten-tomatoes w.r.t. budget
# using interval length == 5
interval = 5
ratings2_ma = rollmean(mm_df2$`Rotten Tomatoes`, interval)
budget = mm_df2$Budget[(1+((interval-1)/2)):(length(mm_df2$Budget)-((interval-1)/2))]
# plot
plot(marvel_movies$`Rotten Tomatoes`, log10(marvel_movies$Budget), type="p",
     main="Marvel movies phase 1, 2, & 3",
     xlab="ratings", ylab="$ amounts in log10 base", 
     ylim=c(8, 10), col=2, lwd=2)
points(marvel_movies$`Rotten Tomatoes`, log10(marvel_movies$`Worldwide Box Office Gross`),
       col=3, lwd=2)
lines(ratings2_ma, log10(budget), 
      col=1, lty=2, lwd=2)
legend(65, 10, c('Ratings w.r.t. Budget', 'Budget', 'Box Office Gross'),  bty="n", col=c(1, 2, 3), lty=c(2, 1, 1), lwd=2)
# f 
# plot ratings vs. time 
# sort data using year and store it
mm_df3 = marvel_movies[order(marvel_movies$Year), ]
# moving average of rotten-tomatoes w.r.t. time
# using interval length == 3
interval = 3
ratings3_ma = rollmean(mm_df3$`Rotten Tomatoes`, interval)
year = mm_df3$Year[(1+((interval-1)/2)):(length(mm_df3$Year)-((interval-1)/2))]
# plot
plot(year, ratings3_ma, type="l",
     main="Marvel movies phase 1, 2, & 3\n (Rotten Tomatoes Ratings Over Time)",
     xlab="year", ylab="moving_average_ratings", 
     ylim=c(70, 100), lwd=2)
legend(2008, 100, c('Ratings (RT)'),  bty="n", lwd=2)



