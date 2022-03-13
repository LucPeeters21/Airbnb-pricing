install.packages("googledrive")
library(haven)
library(dplyr)
library(ggplot2)
library(car)
library(readxl)
library(base)
library(data.table)
library(googledrive)

#################
####DOWNLOAD#####
#################

# Import data
data_id <-"1Tek0FsrdpnnvzQukog_lmtWAHHvhJJUQ" #the id of the dataset
drive_download(as_id(data_id), path = "Airbnb_EU_listings_reduced.csv", overwrite = TRUE) #download the data from the drive
airbnb_listings<-read.csv("Airbnb_EU_listings_reduced.csv", sep=";") #save the data in a dataframe

####################
####ADJUST DATA#####
####################

# Remove dollar sign from 'prices' column
airbnb_listings$price <- (gsub("\\$|,", "", airbnb_listings$price))

# Assure 'price' column is a numeric object type
airbnb_listings$price <- as.numeric(airbnb_listings$price)
is.numeric(airbnb_listings$price)

# Introduce new column for price per person 
airbnb_listings$accommodates <- as.numeric(airbnb_listings$accommodates)
is.numeric(airbnb_listings$accommodates)
airbnb_listings$price_per_person <- airbnb_listings$price_euros/airbnb_listings$accommodates

# create values consisting of current valutas of respective countries
czk <- 0.04 # value of 1 CZK in EUR (as of 12-2021)
ddk <- 0.134  # value of 1 DDK in EUR (as of 12-2021)
sek <- 0.097 # value of 1 SEK in EUR (as of 12-2021)

# convert non-euro countries into euro      
airbnb_listings <- airbnb_listings %>% mutate(price_euros=ifelse(country == "Czech Republic", price*czk,
                                                                 ifelse(country == "Denmark", price*ddk,
                                                                        ifelse(country == "Sweden", price*sek, price))))

# Check means per country to observe face validity
airbnb_listings %>% group_by(country) %>% summarize_at(vars(price_euros), list(name=mean), na.rm=TRUE) 

# Create plot to observe outlying prices
ggplot(airbnb_listings, aes(x=price_per_person)) + geom_histogram(binwidth = 10) # without limit
# initial graph is very unclear due to extreme outliers
ggplot(airbnb_listings, aes(x=price_euros)) + geom_histogram(binwidth = 0.1) + xlim(-1, 5) + ylim(0, 30) # introduce limit                                 
ggplot(airbnb_listings, aes(x=price_per_person)) + geom_histogram(binwidth = 10) + xlim(500, 5000) + ylim(0, 3000) # with limit

# Delete extreme low and high outliers based on price per person
airbnb_listings <- airbnb_listings %>% filter(price_per_person > 0 & price_per_person < 1000)

# Check means of price_euros for multiple variables
cities <- airbnb_listings %>% group_by(city, room_type) %>% summarize_at(vars(price_euros), list(name=mean), na.rm=TRUE) 
cities <- airbnb_listings %>% group_by(city, property_type) %>% summarize_at(vars(price_euros), list(name=mean), na.rm=TRUE)
table_property_type <-as.data.frame(table(airbnb_listings$property_type))

# Filter common property types (at least 1% of total listings)
common_properties<-table_property_type %>% filter(Freq>3300)
sum(common_properties$Freq)
airbnb_listings <- airbnb_listings %>% mutate(common_property=ifelse(property_type %in% common_properties$Var1)

#################
####Analysis#####
#################