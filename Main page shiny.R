install.packages("shiny")
library(shiny)

countries_benelux <- c("Netherlands", "Belgium", "Luxembourg")

Citys_netherlands <- c("Amsterdam", "Rotterdam", "Haarlem", "Eindhoven")
Specifications_Airbnb <- c("superhost", "host response time", "host response rate", "neighbourhood", "property type","accommodates", "bahtroom", "bedrooms", "beds", "reviews score") 

# Define UI ----
ui <- fluidPage(titlePanel("Airbnb price calculator"),p("The airbnb price calculator calculates the correct price for an accommodation based on several variables. This allows you to calculate if you are paying too much on average for an accommodation. In the category box, you can view the variables that affect the price and choose the categories that are important to you."),
  sidebarLayout(sidebarPanel("Choose the correct option in the dropdown below"),
                (mainPanel("Estimated Price"))
               
            )
      )
  
# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
