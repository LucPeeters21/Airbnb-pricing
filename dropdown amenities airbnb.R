getwd()
setwd("C:/Users/Sjors Boelaars/Documents/Shiny web application")
Airbnb_dataset <- read.csv()

library(shiny)
amenities <- c("Extra pillows and blankets", "dryer", "washer", "airco", "TV")

ui <- fluidPage(
  selectInput(
    "amenities", "What amenities does an Airbnb need to have, according to your wishes?", amenities,
    multiple = TRUE
  )
)


# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
