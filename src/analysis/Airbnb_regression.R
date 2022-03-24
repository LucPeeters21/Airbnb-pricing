library(broom)
library(haven)
library(dplyr)
library(ggplot2)
library(car)
library(rms)
library(ggfortify)
#install.packages('data.table')
library(data.table)
#### What drives the price of Airbnb accomodations?
summary(airbnb_listings)


#Check if we have a lot of missing values (ignoring these could create a bias if it occurs at more than 5% of the cases)
df_missing_values<-as.data.frame(sapply(airbnb_listings, function(x) sum(is.na(x))))
View(df_missing_values)


#We observe that for 33% of cases the response rate is not recorded and bedrooms is missing at 6% of the cases.
#Since we have other variables that represent the service level of the host and we have other variables thar represent the capacity of a listing, we decide to remove both variables from the analysis.
airbnb_listings<-airbnb_listings%>% select(-c(host_response_rate, bedrooms))


#Moreover, we observe that at 21% of cases there are no reviews available. Since we dont have any other variables that indicate customer satisfaction, we inspect this variable in more dept:
#We investigate if there is a significant price difference between listings with reviews and listings without:
airbnb_listings_with_reviews<-airbnb_listings%>% filter(!is.na(review_scores_value))
mean(airbnb_listings_with_reviews$price_euros)

airbnb_listings_without_reviews<-airbnb_listings%>% filter(is.na(review_scores_value))
mean(airbnb_listings_without_reviews$price_euros)


#Since we observe a significant price difference between cases with reviews and cases without, we decide to split the analysis between both groups.
#First, we remove the review columns for the dataframe where the reviews are NA:
airbnb_listings_without_reviews<-airbnb_listings_without_reviews%>% select(-c(review_scores_value, review_scores_location, review_scores_checkin, review_scores_communication, review_scores_accuracy, review_scores_accuracy, review_scores_cleanliness, review_scores_rating, reviews_per_month))


#Next, we check if we no longer have missing values that cause more than 5% of data to be removed from analysis:
df_missing_values_with_reviews<-as.data.frame(sapply(airbnb_listings_with_reviews, function(x) sum(is.na(x))))
df_missing_values_without_reviews<-as.data.frame(sapply(airbnb_listings_without_reviews, function(x) sum(is.na(x))))


# Then, check for normality of price (the DV)
ggplot(airbnb_listings_with_reviews, aes(price_euros))+ geom_histogram(binwidth = 50) + xlim(0, 22191) + ylim(0, 2700) # non-normal
ggplot(airbnb_listings_without_reviews, aes(price_euros))+ geom_histogram(binwidth = 50) + xlim(0, 22191) + ylim(0, 2700) # non-normal


# Since both are not-normal, we take the log of price_euros
airbnb_listings_with_reviews <- airbnb_listings_with_reviews %>% mutate(log_price_euros=log(price_euros))
airbnb_listings_without_reviews <- airbnb_listings_without_reviews %>% mutate(log_price_euros=log(price_euros))


# Check the plots again for log-normality of price
ggplot(airbnb_listings_with_reviews, aes(log_price_euros))+ geom_histogram(bins = 50) # normal
ggplot(airbnb_listings_without_reviews, aes(log_price_euros))+ geom_histogram(bins = 50) # normal


# Build regression models with log_price and all variables that might be relevant
regression_all_with_reviews <- lm(log(price_euros)~ .-id -price - price_per_person -log_price_euros -id_check,airbnb_listings_with_reviews)
summary(regression_all_with_reviews)
regression_all_without_reviews <- lm(log(price_euros)~ .-id -price - price_per_person -log_price_euros -id_check, airbnb_listings_without_reviews)
summary(regression_all_without_reviews)

## Check assumptions
residuals_with_reviews <- regression_all_with_reviews$residuals

# Check residual vs. fitted plot
###

# Check for normality
qqPlot(regression_all_with_reviews)

# Check for heteroscedasticity for both regressions with and without reviews
residuals_with_reviews <- regression_all_with_reviews$residuals
ggplot(regression_all_with_reviews, aes(x=log_price_euros, y=residuals_with_reviews))+ geom_point()

residuals_without_reviews <- regression_all_without_reviews$residuals
ggplot(regression_all_without_reviews, aes(x=log_price_euros, y=residuals_without_reviews))+ geom_point()

# Create a dataframe with models output
df_regression_with_reviews <- tidy(regression_all_with_reviews)
df_regression_without_reviews <- tidy(regression_all_without_reviews)


#Then, we want to check what amenities we want to keep in the model (amenities can be recognised by the X. string):
df_regression_amenities_with_reviews<-df_regression_with_reviews[df_regression_with_reviews$term %like% "X.",]
df_regression_amenities_without_reviews<-df_regression_without_reviews[df_regression_without_reviews$term %like% "X.",]


# Get amenities with p-value less than 0.05, to only include significant variables:
df_regression_with_reviews_amenities_keep <- df_regression_amenities_with_reviews %>% filter(p.value <0.05) 
df_regression_without_reviews_amenities_keep <- df_regression_amenities_without_reviews %>% filter(p.value <0.05)


#limit the model to the variables that have the biggest impact based on absolute estimate (this makes the final app easier to work with, since users dont have to specify too many amenties that are not that relevant)
df_regression_with_reviews_amenities_keep <- df_regression_with_reviews_amenities_keep  %>% arrange(desc(estimate))
df_regression_with_reviews_amenities_keep <- df_regression_with_reviews_amenities_keep[1:10,]


df_regression_without_reviews_amenities_keep <- df_regression_without_reviews_amenities_keep  %>% arrange(desc(estimate))
df_regression_without_reviews_amenities_keep  <- df_regression_without_reviews_amenities_keep [1:10,]


#Next, we want to check what other variables we want to keep in the model, by applying a cutoff of 0.075 for the estimate and 0.05 for the p-value:
df_regression_with_reviews_others<-df_regression_with_reviews[!df_regression_with_reviews$term %like% "X.",]
df_regression_with_reviews_others_keep <- df_regression_with_reviews_others %>% filter(p.value <0.05) %>% filter(abs(estimate) > 0.075)
View(df_regression_with_reviews_others_keep)
variables_to_keep_list_with_reviews<- c('property_type', 'bathrooms_text', 'room_type', 'accommodates', 'city', 'host_response_time', 'review_scores_rating', 'review_scores_cleanliness', 'review_scores_location', 'review_scores_value')


df_regression_without_reviews_others<-df_regression_without_reviews[!df_regression_without_reviews$term %like% "X.",]
df_regression_without_reviews_others_keep <- df_regression_without_reviews_others %>% filter(p.value <0.05) %>% filter(abs(estimate) > 0.075)
View(df_regression_without_reviews_others_keep)
variables_to_keep_list_without_reviews<- c('property_type', 'bathrooms_text', 'room_type', 'accommodates', 'city', 'host_response_time')


#Next, we merge the amenities to keep and the variables to keep list:
variable_list_with_reviews<-c(df_regression_with_reviews_amenities_keep$term, variables_to_keep_list_with_reviews)
variable_list_without_reviews<-c(df_regression_without_reviews_amenities_keep$term, variables_to_keep_list_without_reviews)

#Adjust the variable list such that it can be added as a formula in the regression
variable_list_with_reviews <- paste0('`',variable_list_with_reviews, '`')
character_variables<-paste0(variable_list_with_reviews, collapse= '+')


variable_list_without_reviews <- paste0('`',variable_list_without_reviews, '`')
character_variables_wor<-paste0(variable_list_without_reviews, collapse= '+')


# Build regression model with all relevant variables
regression_final <- lm(as.formula(paste0('log(price_euros)~', character_variables)),airbnb_listings_with_reviews)
summary(regression_final)


regression_final_wor <- lm(as.formula(paste0('log(price_euros)~', character_variables_wor)),airbnb_listings_without_reviews)
summary(regression_final_wor)


#Finally, write the regression output to a dataframe
df_regression_final <- tidy(regression_final)
df_regression_final <- tidy(regression_final_wor)


write.csv2(df_regression_final, file = "RegressionOutput_with_reviews.csv")
write.csv2(df_regression_final, file = "RegressionOutput_without_reviews.csv")

