install.packages("shiny")
library(shiny)


Specifications_Airbnb <- c("superhost", "host response time", "host response rate", "neighbourhood", "property type","accommodates", "bahtroom", "bedrooms", "beds", "reviews score") 

ui <- fluidPage(
    selectInput(
    "Specifications", "What specifications do you want an Airbnb to have?", Specifications_Airbnb,
    multiple = TRUE
  )
)


# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
