# install.packages("googledrive")
library(haven)
library(dplyr)
library(ggplot2)
library(car)
library(readxl)
library(base)
library(data.table)
library(googledrive)

#########################
### DATA PREPARATION ####
#########################

# import dataset with listings from our googledrive
data_id <-"1Tek0FsrdpnnvzQukog_lmtWAHHvhJJUQ" #the id of the dataset
dir.create("../../data/")
drive_download(as_id(data_id), path = "../../data/eu_listings.csv", overwrite = TRUE) #download the data from the drive
airbnb_listings<-read.csv("../../data/eu_listings.csv", sep=";") #save the data in a dataframe

# import dataset with amenities from our googledrive
data_id_2 <-"15TYK8aDRcJwdPgaNWdu8NSbQVNgTMgqN" #the id of the dataset
drive_download(as_id(data_id_2), path = "../../data/presencematrix.csv", overwrite = TRUE) #download the data from the drive
airbnb_amenities<-read.csv("../../data/presencematrix.csv", sep=";") #save the data in a dataframe


# create additional column in amenties dataframe to later double check if merging went well
airbnb_amenities$id <- airbnb_amenities$id_check


# drop 'price' column from 'airbnb_amenities'
airbnb_amenities <- airbnb_amenities %>% select(-price)


# merge data frame of listings and amenities by id
airbnb_listings <- merge(airbnb_listings, airbnb_amenities, by = "id")


# inspect the merged data frame
View(airbnb_listings)
summary(airbnb_listings)


# remove possible duplicates
airbnb_listings <- airbnb_listings %>% filter(!duplicated(airbnb_listings))


# remove dollar signs from price and convert to numeric
airbnb_listings$price <- (gsub("\\$|,", "", airbnb_listings$price))
airbnb_listings$host_response_rate <- (gsub("%", "", airbnb_listings$host_response_rate))


# convert date column
airbnb_listings$host_since <- as.Date(airbnb_listings$host_since)


# recode bathroom_text to numeric values, by dropping everything except numbers and dots
airbnb_listings$bathrooms_text <- (gsub("[^0-9.]", "", airbnb_listings$bathrooms_text))


# create list of columns that we want to change to numeric
column_list_numeric <- grep('bathrooms_text|price|host_response_rate|host_listings_count|accommodates|bedrooms|beds|minimum_nights|maximum_nights|number_of_reviews|review_scores_rating|review_scores_accuracy|review_scores_cleanliness|review_scores_checkin|review_scores_communication|review_scores_location|review_scores_value|reviews_per_month', colnames(airbnb_listings,), value=T)
for (column in column_list_numeric){
  airbnb_listings[,column] <- as.numeric(airbnb_listings[,column])
}


# save the exchange rate of the currencies of non-Euro countries in the data set at the moment that the data was scraped (December 2021)
czk <- 0.04 # Czech Republic: value of 1 CZK in EUR (as of 12-2021)
ddk <- 0.134  # Denmark: value of 1 DDK in EUR (as of 12-2021)
sek <- 0.097 # Sweden: value of 1 SEK in EUR (as of 12-2021)

# convert non-euro currencies into euro's   
airbnb_listings <- airbnb_listings %>% mutate(price_euros=ifelse(country == "Czech Republic", price*czk,
                                                                 ifelse(country == "Denmark", price*ddk,
                                                                        ifelse(country == "Sweden", price*sek, price))))


# introduce new column for price per person 
airbnb_listings$price_per_person <- airbnb_listings$price_euros/airbnb_listings$accommodates


# compute means per country to check face validity of prices
airbnb_listings %>% group_by(country) %>% summarize_at(vars(price_euros), list(name=mean), na.rm=TRUE) 

# we observe that especially Czech Republic does not seem to be face valid, this seems to be caused by unrealistic values in the price
# delete observations with extreme low and high price outliers based on price per person
airbnb_listings <- airbnb_listings %>% filter(price_per_person > 0 & price_per_person < 1500)

# check means again for face validity
airbnb_listings %>% group_by(country) %>% summarize_at(vars(price_euros), list(name=mean), na.rm=TRUE) 


# remove variables that are not interesting for the purpose of the analysis
airbnb_listings <- airbnb_listings %>% select(-X.x, -X.y, -neighbourhood, -maximum_nights, -host_since, -host_listings_count, -amenities, -neighbourhood_cleansed, -country)


# transform the host_is_superhost variable and host_identity_verified variable into binary values
airbnb_listings <- airbnb_listings %>% mutate(host_is_superhost=ifelse(host_is_superhost == "t", 1,
                                                                 ifelse(host_is_superhost == "f", 0, NA)))
airbnb_listings <- airbnb_listings %>% mutate(host_identity_verified=ifelse(host_identity_verified == "t", 1,
                                                                       ifelse(host_identity_verified == "f", 0, NA)))

                                                                        
# create dummy variable for property types that occur at less than 1% of data, to limit the number of different property types that will be used in the analysis
table_property_type <-as.data.frame(table(airbnb_listings$property_type))
table_cut_of<- table_property_type %>% filter(Freq >0.01*nrow(airbnb_listings))
airbnb_listings <- airbnb_listings %>% mutate(property_type=ifelse(property_type %in% table_cut_of$Var1, property_type, 'Non-common proporty type'))


# check if we have a lot of missing values (ignoring these could create a bias if it occurs at more than 5% of the cases)
df_missing_values<-as.data.frame(sapply(airbnb_listings, function(x) sum(is.na(x))))
View(df_missing_values)

# we observe that for 33% of cases the response rate is not recorded and that bedrooms is missing at 6% of the cases.
# since we have other variables that represent the service level of the host and we have other variables that represent the capacity of a listing, we decide to remove both variables from the analysis.
airbnb_listings<-airbnb_listings%>% select(-c(host_response_rate, bedrooms))

# moreover, we observe that at 21% of cases there are no reviews available. Since we don't have any other variables that indicate customer satisfaction, we inspect this variable in more dept:
# we investigate if there is a significant price difference between listings with reviews and listings without
airbnb_listings_with_reviews<-airbnb_listings%>% filter(!is.na(review_scores_value))
mean(airbnb_listings_with_reviews$price_euros)

airbnb_listings_without_reviews<-airbnb_listings%>% filter(is.na(review_scores_value))
mean(airbnb_listings_without_reviews$price_euros)

# since we observe a significant price difference between cases with reviews and cases without, we decide to split the analysis between both groups.
# we remove the review columns for the data frame where the reviews are NA
airbnb_listings_without_reviews<-airbnb_listings_without_reviews%>% select(-c(review_scores_value, review_scores_location, review_scores_checkin, review_scores_communication, review_scores_accuracy, review_scores_accuracy, review_scores_cleanliness, review_scores_rating, reviews_per_month))

# then, we check if we no longer have missing values that cause more than 5% of data to be removed from analysis for both datasets
df_missing_values_with_reviews<-as.data.frame(sapply(airbnb_listings_with_reviews, function(x) sum(is.na(x))))
df_missing_values_without_reviews<-as.data.frame(sapply(airbnb_listings_without_reviews, function(x) sum(is.na(x))))
