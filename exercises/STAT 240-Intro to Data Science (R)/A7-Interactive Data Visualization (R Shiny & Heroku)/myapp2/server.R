library(stringr)

dat <- read.table("breast-cancer-wisconsin.data")

ClumpThickness <- vector(mode="numeric")
UniformityOfCellSize <- vector(mode="numeric")
UniformityOfCellShape <- vector(mode="numeric")
MarginalAdhesion <- vector(mode="numeric")
SingleEpithelialCellSize <- vector(mode="numeric")

for(i in 1:length(dat[[1]])) {
  vec <- strtoi(str_extract_all(dat[[1]][i], "\\d+\\b")[[1]])
  # dupm rows that contain missing values
  if(length(vec) == 11) {
    # use 5 variables 
    ClumpThickness[length(ClumpThickness)+1] <- vec[2]
    UniformityOfCellSize[length(UniformityOfCellSize)+1] <- vec[3]
    UniformityOfCellShape[length(UniformityOfCellShape)+1] <- vec[4]
    MarginalAdhesion[length(MarginalAdhesion)+1] <- vec[5]
    SingleEpithelialCellSize[length(SingleEpithelialCellSize)+1] <- vec[6]
  }
}

df <- data.frame("ClumpThickness"=ClumpThickness, 
                 "UniformityOfCellSize"=UniformityOfCellSize, 
                 "UniformityOfCellShape"=UniformityOfCellShape,
                 "MarginalAdhesion"=MarginalAdhesion,
                 "SingleEpithelialCellSize"=SingleEpithelialCellSize)

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

server <- function(input, output, session) {
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    df[, input$xcol]
  })

  output$plot1 <- renderPlot({
    
    par(mar = c(5.1, 4.1, 4.1, 1))
    
    plot(density(selectedData()), 
         main=input$xcol)
  })
}
