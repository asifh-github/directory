# do sentiment analysis
library(tidytext)
sent = get_sentiments()
sentiments = c()
for(i in 1:length(synopses)) {
  if(!is.na(synopses[i])) {
    synopsis = synopses[i]
    words = table(unlist(strsplit(trimws(synopsis), '\\s+')))
    words = data.frame(word = names(words), count = as.numeric(words)) 
    # names(x) -> word, as.numeric(x) -> count
    if (dim(words)[1] > 1) {
      joined = merge(x = words, y = sent, by = "word")
      sentiment = sum(joined[, "sentiment"] == "positive") - 
        sum(joined[, "sentiment"] == "negative")
      sentiments = c(sentiments, sentiment)
      print(sentiment)
    }
  }
}
# plot sentiments
plot(sentiments, ylab = 'Sentiment', xlab = 'Episode', 
     main = 'One Piece synopses sentiments', col=2, lwd=2, cex=1)