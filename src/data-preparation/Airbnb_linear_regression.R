library(haven)
library(dplyr)
library(ggplot2)
library(car)

#### What drives the price of Airbnb accomodations?

# Check for normality of price variables (price_euros, price_per_person)
ggplot(airbnb_listings, aes(price_euros))+ geom_histogram(binwidth = 50) + xlim(0, 22191) + ylim(0, 2700) # non-normal
ggplot(airbnb_listings, aes(price_per_person))+ geom_histogram(binwidth = 50) + xlim(0, 1453.6) + ylim(0, 3000) # non-normal

airbnb_listings <- airbnb_listings %>% mutate(log_price_euros=log(price_euros)) # take log for price_euros
airbnb_listings <- airbnb_listings %>% mutate(log_price_per_person=log(price_per_person)) # take log for price_per_person

ggplot(airbnb_listings, aes(log_price_euros))+ geom_histogram(bins = 50) # normal
ggplot(airbnb_listings, aes(log_price_per_person))+ geom_histogram(bins = 50) # normal

# First regression with all variables
price_euros_regression_all_var <- lm(log_price_euros~as.factor(host_response_time)+as.factor(host_is_superhost)+
                                       as.factor(host_identity_verified)+as.factor(property_type)+as.factor(room_type)+
                                       as.factor(city)+as.factor(country)+host_response_rate+
                                       host_listings_count+accommodates+bedrooms+beds+
                               minimum_nights+maximum_nights+number_of_reviews+review_scores_rating+
                               review_scores_accuracy+review_scores_cleanliness+review_scores_checkin+
                               review_scores_communication+review_scores_location+review_scores_value+
                               reviews_per_month, airbnb_listings)
summary(price_euros_regression_all_var)

# Remove non-significant values


