#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Goodbye to overpriced Airbnbs"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "city", label = "City",
                      choices = c("Antwerp", "Athens", "Barcelona", "Bergamo","Berlin", 
                                  "Bologna", "Bordeaux", "Brussels", "Copenhagen", "Crete", "Euskadi",
                                  "Florence", "Ghent", "Girona", "Lisbon", "Lyon", "Madrid", "Malaga",
                                  "Mallorca", "Menorca", "Milan", "Munich", "Naples", "Paris", "Porto", 
                                  "Prague", "Puglia", "Riga", "Rome", "Sevilla", "Sicily", "South Aegean",
                                  "Stockholm", "Thessaloniki", "Trentino", "Valencia", "Venice", "Vienna"),
                      selected = "Antwerp"),
          radioButtons(inputId = "Property type", label = "Preferred room type", 
                       choices = c("Hotel room", "Private room", "Shared room"), selected = "Hotel room"),
          radioButtons(inputId = "Property type", label = "Preferred property type", 
                       choices = c("Loft", "Entire rental unit", "Private rental unit", 
                                   "Entire residential home", "Room residential home", 
                                   "Serviced apartment", "Townhouse", "Villa", "Bed and breakfast", 
                                   "Condo", "Other"), selected = "Loft"),
          numericInput(inputId = "num", label = "Number of accomodates", value = 10, min = 1, max = 16),
          numericInput(inputId = "num", label = "Number of bathrooms", value = 10, min = 0, max = 50),
          numericInput(inputId = "num", label = "Number of bedrooms", value = 10, min = 1, max = 101),
          sliderInput(inputId = "Preferred average rating", label = "Preferred average rating", value = c(3, 4), min = 0, max = 5),
          checkboxGroupInput("amenties", 
                             h3("Amenities"), 
                             choices = list("Essentials" = 1, "Kitchen" = 2, "Hairdryer" = 3, "Hangers" = 4,
                                            "Airconditioning" = 5, "Dishwasher" = 6, "Free streetparking" = 7,
                                            "Dryer" = 8, "Indoor fireplace" = 9, "Pool" = 10, "Babysitter recommendations" = 11,
                                            "Hottub" = 12, "Private pool" = 13, "bathrooms" = 14, "accommodates" = 15, "bedrooms" = 16, "rating" = 17),
                             selected = 1),
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
