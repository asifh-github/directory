library(shiny)

vars <- c("ClumpThickness", 
          "UniformityOfCellSize",
          "UniformityOfCellShape",
          "MarginalAdhesion",
          "SingleEpithelialCellSize")

shinyUI(pageWithSidebar(
  headerPanel('Density of Breast Cancer Wisconsin Data Set'),
  
  sidebarPanel(
    selectInput('xcol', 'Variable', vars)
  ),
  
  mainPanel(
    plotOutput('plot1')
  )
))
