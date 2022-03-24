################################################################################
#Prepare the downloading


#First, load some usefull packages:
library(tidyverse)
library(here)
library(ggplot2)
library(dplyr)


#Secondly, install the googledrive package, which is a handy package to download data from google drive:
#install.packages('googledrive')  
library(googledrive)


#download the file with download links from google drive:
data_id <-"1aN4jx3ScvUJPL4DQEz-UZzXym5UGlZ8Po-718KKrGPM"
drive_download(as_id(data_id), path = "Airbnb_listing_urls.csv", overwrite = TRUE)
City_data <- read.csv("Airbnb_listing_urls.csv", sep=";")


#Filter for only the EU countries, since these are our scope:
#First define what countries are in EU (source: https://www.gov.uk/eu-eea#:~:text=The%20EU%20countries%20are%3A,%2C%20Slovenia%2C%20Spain%20and%20Sweden.)
Countries_in_EU<-c('Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Republic of Cyprus', 'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'The Netherlands', 'Poland', 'Portugal', 'Romania', 'Slovakia', 'Slovenia', 'Spain', 'Sweden')
EU_cities <- City_data %>% filter(Country %in% Countries_in_EU)


################################################################################
#Function to download all listings from inside Airbnb that are of interest:


download_function<-function(dataset){
  #safe the country, city and link variables from the dataset row:
  country<-dataset[1]
  city<-dataset[2]
  link<-dataset[3]
  
  
  #Print what we are going to download:
  print(link)
  
  
  #access the link and download the data:
  con <- gzcon(url(paste(link,
                         "", sep="")))
  txt <- readLines(con)
  Airbnb_listings_temporary<- read.csv(textConnection(txt))
  
  
  #Save the city and country to the dataframe:
  Airbnb_listings_temporary$city<-city
  Airbnb_listings_temporary$country<-country
  
  
  #since some files contain wrongly formatted cells, which results in a lot of unusable rows and hence, a waist of storage space of more than 1 GB of data,
  #we already try to filter out these rows immediatly. It seems that by dropping rows that dont have a correct price format (i.e. ending with .00) and rows that have a non-numeric id,
  #we find out that we can reduce >99.9% of wrongly formatted rows.
  Airbnb_listings_temporary<-Airbnb_listings_temporary[grepl(".00",Airbnb_listings_temporary$price),]
  Airbnb_listings_temporary<-Airbnb_listings_temporary[!is.na(as.numeric(as.character(Airbnb_listings_temporary$id))),]
  
  
  return(Airbnb_listings_temporary)
}

################################################################################
#Execution of the function


#run the function on the EU_cities data:
listings_Europe<-apply(EU_cities,1,FUN=download_function)
closeAllConnections() #Close all connections after running the function, to prevent running out of open connections


#save the data as a dataframe and save this as a CSV
listings_Europe_df<- as.data.frame(do.call(rbind, listings_Europe))
write.csv2(listings_Europe_df, file = "Airbnb_EU_listings.csv")


#create a smaller csv file that stores only the columns that we will be going to use (this reduces the file size signifcantly):
#First, define the relevant columns:
relevant_cols<-c('id', 'host_since', 'host_response_time', 'host_response_rate', 'host_is_superhost', 'host_listings_count', 'host_identity_verified', 'neighbourhood', 'neighbourhood_cleansed', 'property_type', 'room_type', 'accommodates', 'bathrooms_text', 'bedrooms', 'beds',
                 'amenities', 'price', 'minimum_nights', 'maximum_nights', 'number_of_reviews', 'review_scores_rating', 'review_scores_accuracy', 'review_scores_cleanliness', 'review_scores_checkin', 'review_scores_communication', 'review_scores_location', 'review_scores_value', 'reviews_per_month', 'country' , 'city')
#Then, extract these columns and save them to a csv:
listings_Europe_reduced<- listings_Europe_df[,which(colnames(listings_Europe_df) %in% relevant_cols)]
write.csv2(listings_Europe_reduced, file = "Airbnb_EU_listings_reduced.csv")


################################################################################