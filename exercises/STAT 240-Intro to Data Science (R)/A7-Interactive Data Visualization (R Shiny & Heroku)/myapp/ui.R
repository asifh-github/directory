# k-means only works with numerical variables,
# so don't give the user the option to select
# a categorical variable
library(shiny)

vars <- setdiff(names(iris), "Species")

ui <- fluidPage(
  pageWithSidebar(
    headerPanel('Density of iris properties'),
    
    sidebarPanel(
      selectInput('xcol', 'Variable', vars)
    ),
    
    mainPanel(
      plotOutput('plot1')
    )
  ) 
)

