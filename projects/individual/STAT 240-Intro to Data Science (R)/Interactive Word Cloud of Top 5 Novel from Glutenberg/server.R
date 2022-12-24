server <- function(input, output) {
  output$wcPlot <- renderPlot({
    # download selected novel
    number = input$novel
    fname = sprintf('%s-0.txt', input$novel)
    if (!file.exists(fname) || file.info(fname)$size < 1024) {
      download.file(sprintf('https://www.gutenberg.org/files/%s/%s', number, fname), fname)
    }
    
    # read lines from novel
    text = readLines(fname)
    # remove preamble and postamble
    if(input$novel == "1342") {
      text = text[175:(length(text)-350)]
    }
    else {
      text = text[75:(length(text)-350)]
    }
    
    # collapse lines
    text = paste(text, collapse = ' ')
    # change text to all lower-case
    text = tolower(text)
    # remove non-alphabetical chars
    text = gsub('[^ a-z]', '', text)
    # trim extra white-space
    text = trimws(text)
    # extract/split each word
    w = strsplit(text, '\\s+')
    # unlist w
    w = unlist(w)
    # remove stopwords
    w = w[!(w %in% stopwords('en'))]
    # create table
    t = table(w)
    
    # create wordcloud
    wordcloud(names(t), t, max.words=input$words)
  })
  
}