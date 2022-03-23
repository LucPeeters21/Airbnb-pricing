#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Goodbye to overpriced Airbnbs"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          numericInput(inputId = "city", label = "City",
                      choices = c("Antwerp", "Athens", "Barcelona", "Bergamo","Berlin", 
                                  "Bologna", "Bordeaux", "Brussels", "Copenhagen", "Crete", "Euskadi",
                                  "Florence", "Ghent", "Girona", "Lisbon", "Lyon", "Madrid", "Malaga",
                                  "Mallorca", "Menorca", "Milan", "Munich", "Naples", "Paris", "Porto", 
                                  "Prague", "Puglia", "Riga", "Rome", "Sevilla", "Sicily", "South Aegean",
                                  "Stockholm", "Thessaloniki", "Trentino", "Valencia", "Venice", "Vienna"),
                      selected = "Antwerp"),
          radioButtons(inputId = "Property type", label = "Choose your preferred property type", 
                       choices = c("Loft", "Entire rental unit", "Private rental unit", 
                                   "Entire residential home", "Room residential home", 
                                   "Serviced apartment", "Townhouse", "Villa", "Bed and breakfast", 
                                   "Condo", "Other"), selected = "Loft"),
          checkboxGroupInput("amenities", 
                             h3("Amenities"), 
                             choices = list("Essentials" = 1, "Kitchen" = 2, "Hairdryer" = 3, "Hangers" = 4,
                                            "Airconditioning" = 5, "Dishwasher" = 6, "Free streetparking" = 7,
                                            "Dryer" = 8, "Indoor fireplace" = 9, "Pool" = 10, "Babysitter recommendations" = 11,
                                            "Hottub" = 12, "Private pool" = 13, "bathrooms" = 14, "Hotel room" = 15,
                                            "Private room" = 16, "Shared room" = 17, "accommodates" = 18, "bedrooms" = 19, "rating" = 20),
                             selected = 1),
        ),

        # Show a plot of the generated distribution
        mainPanel(
           textOutput("selected_amenities")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$selected_amenities <- renderDataTable({(input$amenities*5)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
