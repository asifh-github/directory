library(shiny)
library(udpipe)
library(stopwords)
library(wordcloud)

ui <- fluidPage(
  # page title
  titlePanel("Gutenberg Top 5 Popular Novels Wordcloud*"),
  
  sidebarLayout(
    # sidebar panel for inputs
    sidebarPanel(
      # input: novel
      selectInput(inputId = "novel", 
                  label = "Novel:",
                  c("Frankenstein" = "84",
                    "Pride and Prejudice" = "1342", 
                    "Alice's Adventures in Wonderland" = "11",
                    "The Great Gatsby" = "64317",
                    "The Adventures of Sherlock Holmes" = "1661")
                  ),
      # input: number of words
      sliderInput("words", "Number of words:",
                  min = 1,
                  max = 100,
                  value = 50)
      
    ),
    
    # main panel for outputs
    mainPanel(
      # output: wordcloud
      plotOutput(outputId = "wcPlot", width="100%", height = "600px")
    )
  )
)