library(tidypredict)
library(yaml)
library(shiny)

######################
### SHINY APP ########
######################

# load the result of the regression
regression_output_wr<- read.csv("../../data/regression_output_with_reviews.csv", fileEncoding = "UTF-8")
regression_output_wor<- read.csv("../../data/regression_output_without_reviews.csv", fileEncoding = "UTF-8")
airbnb_listings_with_reviews <- read.csv("../../data/listings_with_reviews.csv", fileEncoding = "UTF-8") 
variable_list_with_reviews<- read.csv("../../data/variable_list_with_reviews.csv")
variable_list_without_reviews<- read.csv("../../data/variable_list_without_reviews.csv")
regression_model_wr<-read_yaml("../../data/regression_output_wr.yml")
regression_model_wr <- as_parsed_model(regression_model_wr)
regression_model_wor<-read_yaml("../../data/regression_output_wor.yml")
regression_model_wor <- as_parsed_model(regression_model_wor)






# select the amenities (since we only selected 10 amenities, we know that 2:11 are the amenities)
regression_output_amenities_wr<-regression_output_wr[2:11,]
regression_output_amenities_wor<-regression_output_wor[2:11,]


# make the amenities text more attractive to present in the app
regression_output_amenities_wr$term <- (gsub("X.|\\.", "", regression_output_amenities_wr$term))
regression_output_amenities_wor$term <- (gsub("X.|\\.", "", regression_output_amenities_wor$term))


# clean the property types and create a list of possible property types
regression_output_pt <- regression_output_wr[regression_output_wr$term %like% "property_type",] 
regression_output_pt$term <- (gsub("property_type", "", regression_output_pt$term))
property_types<-sort(unique(airbnb_listings_with_reviews$property_type))


# clean the room types and create a list with possible room types
regression_output_rt <- regression_output_wr[regression_output_wr$term %like% "room_type",] 
regression_output_rt$term <- (gsub("room_type", "", regression_output_rt$term))
room_types<-unique(airbnb_listings_with_reviews$room_type)


# clean the cities and create a list of possible cities
regression_output_city <- regression_output_wr[regression_output_wr$term %like% "city",] 
regression_output_city$term <- (gsub("city", "", regression_output_city$term))
cities<-sort(unique(airbnb_listings_with_reviews$city))


# clean the host response time variable and create a list of possible host response times
regression_output_hrt <- regression_output_wr[regression_output_wr$term %like% "host_response_time",] 
regression_output_hrt$term <- (gsub("host_response_time", "", regression_output_hrt$term))
host_response_time<-(unique(airbnb_listings_with_reviews$host_response_time))
host_response_time<-host_response_time[c(1,4,5,6,3,2)] #change the order such that it is more logically


################################################################################
# write function that applies the correct regression to the data

df_creator<-function(variable_list, cities, regression_output_amenities, input, regression_final){
  #load the variables that were taken into the model and create an empty data frame with these variables as heading (this dataframe will later be used to run the regression on):
  table_heads<-variable_list
  table_heads<-gsub("\\`", "", table_heads) #remove the '`' from the headings, such that they match the headings that the regression will go look for 
  df<- data.frame(matrix(ncol = length(table_heads), nrow = length(cities))) #create empty dataframe on which we will later run the regression
  colnames(df)<-table_heads #change the column names into the required table headings


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
  # copy the data of the first row to all rows in the data frame
  df[1:length(cities),]<-df[1,]

  # store all possible cities in the cities column of the data frame
  df[1:length(cities),'city']<-cities

  # create a column in which the predicted regression price can later be stored
  df[,'price']<-0
  df$'price'<- df %>% mutate(pred = exp(!! tidypredict_fit(regression_final)))%>% select(pred)

  # arrange the price column in such a way that the highest price is on the top
  df<- df %>% arrange(desc(price))
  colnames(df)[which(colnames(df)=='price')] <- 'price (in Euros)' #change the column name such that it is less ambiguous


  return(df)}


################################################################################
# write the code of actual shiny app


# define UI for application that draws a histogram
ui <- fluidPage(
  
  
  # application title
  titlePanel("Goodbye to overpriced Airbnbs"),
  
  
  # sidebar with the information that the user needs to fill in
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "city", label = "City",
                  choices = cities,
                  selected = cities[1]),
      
      selectInput(inputId = "Property type", label = "Property type", 
                   choices = property_types,
                   selected = property_types[1]),
      
      selectInput(inputId = "Room type", label = "Room type", 
                   choices = room_types,
                  selected = room_types[1]),
    
      selectInput(inputId = "hrt", label = "Host normally responds within:", 
                  choices = host_response_time,
                  selected = host_response_time[1]),
      
      numericInput(inputId = "acc", label = "Maximum number of guests", value = 6, min = 1, max = 16),
      numericInput(inputId = "bath", label = "Number of bathrooms", value = 1, min = 0, max = 50),
      
      radioButtons(inputId = "ratings_present", label = "Are there reviews available for this listing?",
                  choices = c('Yes', "No"),
                  selected = 'Yes'),      
      
      numericInput(inputId = "rating", label = "Review score rating", value = NA, min = 0, max = 0),
      numericInput(inputId = "clean", label = "Review score cleanliness", value = NA, min = 0, max = 5),
      numericInput(inputId = "location", label = "Review score location", value = NA, min = 0, max = 5),
      numericInput(inputId = "value", label = "Review score value" , value = NA, min = 0, max = 5),
      
      checkboxGroupInput("amenities", 
                         h3("Amenities"), 
                         choices = regression_output_amenities_wr$term,
                         selected = NA),
    ),
    
    
    mainPanel(
      textOutput("out"),
      textOutput("extra"),
      tableOutput("table")
    )
  )
)


# define server logic required to draw output
server <- function(input, output, session){ 
  
  
  #change the possible inputs based on the answer to the question "Are there reviews available for this listing?"
  observeEvent(input$ratings_present, { 
    
    updateNumericInput(session, input = "rating", value = ifelse(input$ratings_present == "Yes",5, NA ),
                       min = ifelse(input$ratings_present == "Yes",0, 0 ),
                       max = ifelse(input$ratings_present == "Yes",5, 0 ))
    updateNumericInput(session, input = "clean", value = ifelse(input$ratings_present == "Yes",5, NA ),
                       min = ifelse(input$ratings_present == "Yes",0, 0 ),
                       max = ifelse(input$ratings_present == "Yes",5, 0 ))
    updateNumericInput(session, input = "location", value = ifelse(input$ratings_present == "Yes",5, NA ),
                       min = ifelse(input$ratings_present == "Yes",0, 0 ),
                       max = ifelse(input$ratings_present == "Yes",5, 0 ))
    updateNumericInput(session, input = "value", value = ifelse(input$ratings_present == "Yes",5, NA ),
                       min = ifelse(input$ratings_present == "Yes",0, 0 ),
                       max = ifelse(input$ratings_present == "Yes",5, 0 ))
    
    # define the amenities for the cases with and without available reviews
    am_list<-if(input$ratings_present == "Yes"){regression_output_amenities_wr$term} else{regression_output_amenities_wor$term}
    updateCheckboxGroupInput(session, inputId ="amenities", label = 'amenities', choices = am_list,selected = NA)   
    })
  
  
  
  # run the applicable regression analysis over the data that the user filled out
  output$out<-renderText({
  
  # check if we deal with a listing with or without reviews and adjust the model based on this information
  if(input$ratings_present=="No"){
    df<-df_creator(variable_list_without_reviews[,'x'], cities, regression_output_amenities_wor, input, regression_model_wor)

    # define the output
    paste("A reasonable price for one night at this Airbnb would be: ???",  round(df[df$city==input$city,'price (in Euros)'],2))
   
  # define what we want to do in case we deal with ratings 
  }else{
    df<-df_creator(variable_list_with_reviews[,'x'], cities, regression_output_amenities_wr, input, regression_model_wr)
    
    # define the output
    paste("A reasonable price for one night at this Airbnb would be: ???",  round(df[df$city==input$city,'price (in Euros)'],2))
    }#[df$city==input$city]
  })
  
  
  # add a extra line that introduces the table
  output$extra<- renderText({paste(" Below you can find what a reasonable price for a comparable Airbnb in other European cities would be:")})
  
  
  # show a table in which the user can see the advised price of comparable airbnb's in other cities
  output$table <- renderTable({
    
    # check if we deal with a listing with or without reviews and adjust the data frame based on this information
    if(input$ratings_present=="No"){
      df<-df_creator(variable_list_without_reviews[,'x'], cities, regression_output_amenities_wor, input, regression_model_wor)
      
      # extract only the relevant columns of the dataframe that we want to show to the user
      df_to_show<-df%>% select(city, 'price (in Euros)')
      df_to_show    }
    
      # define what we want to do in case we deal with ratings 
    else{
      df<-df_creator(variable_list_with_reviews[,'x'], cities, regression_output_amenities_wr, input, regression_model_wr)
    
      # extract only the relevant columns of the dataframe that we want to show to the user
      df_to_show<-df%>% select(city, 'price (in Euros)')
      df_to_show }
    })}


# run the application 
shinyApp(ui = ui, server = server)

write.csv(regression_output_wr, file= "../../data/regression_output_wr.csv", fileEncoding = "UTF-8")
