library(shiny)

######################
### SHINY APP ########
######################

# load the result of the regression
regression_output<-df_regression_final_with_reviews


# select the amenities (since we only selected 10 amenities, we know that 2:11 are the amenities)
regression_output_amenities<-regression_output[2:11,]


# make the amenities text more attractive to present in the app
regression_output_amenities$term <- (gsub("X.|\\.", "", regression_output_amenities$term))


# clean the property types and create a list of possible property types
regression_output_pt <- regression_output[regression_output$term %like% "property_type",] 
regression_output_pt$term <- (gsub("property_type", "", regression_output_pt$term))
property_types<-sort(unique(airbnb_listings$property_type))


# clean the room types and create a list with possible room types
regression_output_rt <- regression_output[regression_output$term %like% "room_type",] 
regression_output_rt$term <- (gsub("room_type", "", regression_output_rt$term))
room_types<-unique(airbnb_listings$room_type)


# clean the cities and create a list of possible cities
regression_output_city <- regression_output[regression_output$term %like% "city",] 
regression_output_city$term <- (gsub("city", "", regression_output_city$term))
cities<-sort(unique(airbnb_listings$city))


# clean the host response time variable and create a list of possible host response times
regression_output_hrt <- regression_output[regression_output$term %like% "host_response_time",] 
regression_output_hrt$term <- (gsub("host_response_time", "", regression_output_hrt$term))
host_response_time<-(unique(airbnb_listings$host_response_time))
host_response_time<-host_response_time[c(1,4,5,6,3,2)] #change the order such that it is more logically

#load the variables that were taken into the model and create an empty data frame with these variables as heading (this dataframe will later be used to run the regression on):
table_heads<-variable_list_with_reviews
table_heads<-gsub("\\`", "", table_heads) #remove the '`' from the headings, such that they match the headings that the regression will go look for 
df<- data.frame(matrix(ncol = length(table_heads), nrow = length(cities))) #create empty dataframe on which we will later run the regression
colnames(df)<-table_heads #change the column names into the required table headings

# define UI for application that draws a histogram
ui <- fluidPage(
  
  # application title
  titlePanel("Goodbye to overpriced Airbnbs"),
  
  # sidebar
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "city", label = "City",
                  choices = cities,
                  selected = cities[1]),
      
      
      selectInput(inputId = "Property type", label = "Preferred Property type", 
                   choices = property_types,
                   selected = property_types[1]),
      
      
      selectInput(inputId = "Room type", label = "Preferred Room type", 
                   choices = room_types,
                  selected = room_types[1]),
    
      
      selectInput(inputId = "hrt", label = "Host normally responds within:", 
                  choices = host_response_time,
                  selected = host_response_time[1]),
      
            
      
      numericInput(inputId = "acc", label = "Maximum number of guests", value = 6, min = 1, max = 16),
      numericInput(inputId = "bath", label = "Number of bathrooms", value = 1, min = 0, max = 50),
      numericInput(inputId = "rating", label = "Review score rating", value = 5, min = 0, max = 5),
      numericInput(inputId = "clean", label = "Review score cleanliness", value = 5, min = 0, max = 5),
      numericInput(inputId = "location", label = "Review score location", value = 5, min = 0, max = 5),
      numericInput(inputId = "value", label = "Review score value" , value = 5, min = 0, max = 5),
      
      checkboxGroupInput("amenities", 
                         h3("amenities"), 
                         choices = regression_output_amenities$term,
                         selected = regression_output$term[1]),
    ),
    
    
    mainPanel(
      textOutput("out"),
      textOutput("extra"),
      tableOutput("table")
    )
  )
)





# define server logic required to draw output
server <- function(input, output){ 
  
  output$out<-renderText({
  
  # safe what amenities the user indicated to be present at the listing
  amenity_present<- regression_output_amenities$term %in% input$amenities
  df[1,1:10]<-as.numeric(amenity_present)
  
  
  # safe the other input of the user to the dataframe, such that we can later apply the regression on this dataframe  
  df[1, 'property_type']<- input$"Property type"
  df[1, 'bathrooms_text']<- as.numeric(input$bath)
  df[1, 'room_type']<- input$"Room type"
  df[1, 'accommodates']<- as.numeric(input$acc)
  df[1, 'city']<- input$city
  df[1, 'host_response_time']<- input$hrt
  df[1, 'review_scores_rating']<- as.numeric(input$rating)
  df[1, 'review_scores_cleanliness']<- as.numeric(input$clean)
  df[1, 'review_scores_location']<- as.numeric(input$location)
  df[1, 'review_scores_value']<- as.numeric(input$value)
  
  # define the output
  paste("A reasonable price for one night at this Airbnb would be: €",  round(exp(predict(regression_final_with_reviews, newdata = df[1,])),2))

  
  })
  
  
  # add a extra line that introduces the table
  output$extra<- renderText({paste(" Below you can find what a reasonable price for a comparable Airbnb in other EU cities would be:")})
  
  
  # show a table in which the user can see the adviced price of comparable airbnb's in other cities
  output$table <- renderTable({
    
    
    # safe what amenities the user indicated to be present at the listing
    amenity_present<- regression_output_amenities$term %in% input$amenities
    df[1,1:10]<-as.numeric(amenity_present)
    
    
    # safe the other input of the user to the dataframe, such that we can later apply the regression on this data frame  
    df[1, 'property_type']<- input$"Property type"
    df[1, 'bathrooms_text']<- as.numeric(input$bath)
    df[1, 'room_type']<- input$"Room type"
    df[1, 'accommodates']<- as.numeric(input$acc)
    df[1, 'host_response_time']<- input$hrt
    df[1, 'review_scores_rating']<- as.numeric(input$rating)
    df[1, 'review_scores_cleanliness']<- as.numeric(input$clean)
    df[1, 'review_scores_location']<- as.numeric(input$location)
    df[1, 'review_scores_value']<- as.numeric(input$value)    
    
    
    
    # store the possible different cities in the dataframe
    df[1:length(cities),]<-df[1,]
    df[1:length(cities),'city']<-cities
    
    
    # create a column in which the predicted regression price can later be stored
    df[,'price']<-0
    df$'price'<-round(exp(predict(regression_final_with_reviews, newdata = df)),2) #run the regression
    
    
    # arreange the price column in such a way that the highest price is on the top
    df<- df %>% arrange(desc(price))
    colnames(df)[which(colnames(df)=='price')] <- 'price (in Euros)' #change the column name such that it is less ambiguous
    
    
    # extract only the relevant columns of the dataframe that we want to show to the user
    df_to_show<-df%>% select(city, 'price (in Euros)')
    df_to_show
    
    })
  
  
}


# run the application 
shinyApp(ui = ui, server = server)