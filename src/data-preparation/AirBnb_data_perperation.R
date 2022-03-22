# install.packages("googledrive")
library(haven)
library(dplyr)
library(ggplot2)
library(car)
library(readxl)
library(base)
library(data.table)
library(googledrive)

# Import data
data_id <-"1Tek0FsrdpnnvzQukog_lmtWAHHvhJJUQ" #the id of the dataset
drive_download(as_id(data_id), path = "Airbnb_EU_listings_reduced.csv", overwrite = TRUE) #download the data from the drive
airbnb_listings<-read.csv("Airbnb_EU_listings_reduced.csv", sep=";") #save the data in a dataframe

data_id_2 <-"15TYK8aDRcJwdPgaNWdu8NSbQVNgTMgqN" #the id of the dataset
drive_download(as_id(data_id_2), path = "Presencematrix_v2.csv", overwrite = TRUE) #download the data from the drive
airbnb_amenities<-read.csv("Presencematrix_v2.csv", sep=";") #save the data in a dataframe

# Drop 'price' column from 'airbnb_amenities'
airbnb_amenities <- airbnb_amenities %>% select(-price)

# Create additional column to check if merging went well
airbnb_amenities$id <- airbnb_amenities$id_check

# Merge data 
airbnb_listings <- merge(airbnb_listings, airbnb_amenities, by = "id")

# Inspect data
View(airbnb_listings)
summary(airbnb_listings)


# Remove dollar signs from price and convert to numeric
airbnb_listings$price <- (gsub("\\$|,", "", airbnb_listings$price))
airbnb_listings$host_response_rate <- (gsub("%", "", airbnb_listings$host_response_rate))

# Assure correct data types
airbnb_listings$host_since <- as.Date(airbnb_listings$host_since)

# Recode bathroom_text to numeric values
airbnb_listings$bathrooms_text <- (gsub("bath|baths|private|shared|half-|Private|Half-|Shared| ", "", airbnb_listings$bathrooms_text))

# Create list of columns that we want to change to numeric
column_list_numeric <- grep('bathrooms_text|price|host_response_rate|host_listings_count|accommodates|bedrooms|beds|minimum_nights|maximum_nights|number_of_reviews|review_scores_rating|review_scores_accuracy|review_scores_cleanliness|review_scores_checkin|review_scores_communication|review_scores_location|review_scores_value|reviews_per_month', colnames(airbnb_listings,), value=T)
for (column in column_list_numeric){
  airbnb_listings[,column] <- as.numeric(airbnb_listings[,column])
}
is.numeric(airbnb_listings$price)
# create values consisting of current valutas of respective countries
czk <- 0.04 # value of 1 CZK in EUR (as of 12-2021)
ddk <- 0.134  # value of 1 DDK in EUR (as of 12-2021)
sek <- 0.097 # value of 1 SEK in EUR (as of 12-2021)

# convert non-euro countries into euro      
airbnb_listings <- airbnb_listings %>% mutate(price_euros=ifelse(country == "Czech Republic", price*czk,
                                                                 ifelse(country == "Denmark", price*ddk,
                                                                        ifelse(country == "Sweden", price*sek, price))))

# Introduce new column for price per person 
airbnb_listings$price_per_person <- airbnb_listings$price_euros/airbnb_listings$accommodates

# Check means per country to observe face validity
airbnb_listings %>% group_by(country) %>% summarize_at(vars(price_euros), list(name=mean), na.rm=TRUE) 
# We observe that especially Czech Republic is not face valid, this seems to be caused by unrealistic values in the price
# Delete extreme low and high outliers based on price per person
airbnb_listings <- airbnb_listings %>% filter(price_per_person > 0 & price_per_person < 1500)
# Check means again
airbnb_listings %>% group_by(country) %>% summarize_at(vars(price_euros), list(name=mean), na.rm=TRUE) 

# Remove variables that we will not use in analysis
airbnb_listings <- airbnb_listings %>% select(-X.x, -X.y, -neighbourhood, -maximum_nights, -host_since, -host_listings_count, -amenities, -neighbourhood_cleansed, -country)

# Change superhost and identified values
airbnb_listings <- airbnb_listings %>% mutate(host_is_superhost=ifelse(host_is_superhost == "t", 1,
                                                                 ifelse(host_is_superhost == "f", 0, NA)))
airbnb_listings <- airbnb_listings %>% mutate(host_identity_verified=ifelse(host_identity_verified == "t", 1,
                                                                       ifelse(host_identity_verified == "f", 0, NA)))
                                                                        
# Create dummy variable for property types that occur at less than 1% of data
table_property_type <-as.data.frame(table(airbnb_listings$property_type))
table_cut_of<- table_property_type %>% filter(Freq >0.01*nrow(airbnb_listings))
airbnb_listings <- airbnb_listings %>% mutate(property_type=ifelse(property_type %in% table_cut_of$Var1, property_type, 'Non-common proporty type'))