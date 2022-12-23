library(tidyverse)

dfiles <- dir("Lab11Data", full.names=TRUE)
dfiles

# 1 
# write a func- read_rename_csv() t/
# read csv files w/ read_csv()
# change the names of cols to c("x", "y")
# compare to lab 11
read_rename_csv <- function(files) {
  ff <- vector("list", length(files))
  for(i in seq_along(files)) {
  study_data <- read_csv(files[i])
  names(study_data) <- c("x", "y")
  ff[[i]] <- study_data
  }
  return(ff)
}
read_rename_csv(dfiles)

# 2
# use map() & read_rename_csv() to read and rename all 9 files from lab11dat folder
map(dfiles, read_rename_csv)

# 3
# re-do call to map from exe 2
# now, use 'func on fly' to do the same thing
# which do you prefer?
# hint: use '~{....}'
dfiles %>% 
  map(~{ tibb<-read_csv(.); names(tibb)<-c("x", "y"); tibb })
## (-> exe 3, b/c no need to worry about small errors + cleaner code)

# 4
# apply forward pipe to get equivalent to plot.study.data() f/ lab 11
# use steps:
#  pipe dfiles through call to map() t/ reads & renames the files
#     use code from exe 2 or 3
# pipe result through bind_rows(.id="study)
# pipe result through mutate() to change study to a factor
# &, pipe result into ggplot() to make a plot
dfiles %>%
  map(~{ tibb<-read_csv(.); names(tibb)<-c("x", "y"); tibb }) %>%
  bind_rows(.id="study") %>%
  mutate(study=factor(study)) %>%
  ggplot(aes(x=x, y=y, color=study)) + 
  geom_smooth(se=FALSE) + geom_point(alpha=0.5)
