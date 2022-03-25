#install.packages('data.table')
library(broom)
library(haven)
library(dplyr)
library(ggplot2)
library(car)
library(ggfortify)
library(data.table)

######################
### REGRESSION #######
######################

# Load data so the make file recognizes the variables
airbnb_listings_with_reviews <- read.csv("../../data/listings_with_reviews.csv", fileEncoding = "UTF-8") 
airbnb_listings_without_reviews <- read.csv("../../data/listings_without_reviews.csv", fileEncoding = "UTF-8")

# check for normality of price (the DV)
ggplot(airbnb_listings_with_reviews, aes(price_euros))+ geom_histogram(binwidth = 50) + xlim(0, 22191) + ylim(0, 2700) # non-normal
ggplot(airbnb_listings_without_reviews, aes(price_euros))+ geom_histogram(binwidth = 50) + xlim(0, 22191) + ylim(0, 2700) # non-normal

# since both are not-normal, we take the log of price_euros and check if this is normal
airbnb_listings_with_reviews <- airbnb_listings_with_reviews %>% mutate(log_price_euros=log(price_euros))
airbnb_listings_without_reviews <- airbnb_listings_without_reviews %>% mutate(log_price_euros=log(price_euros))
ggplot(airbnb_listings_with_reviews, aes(log_price_euros))+ geom_histogram(bins = 50) # normal
ggplot(airbnb_listings_without_reviews, aes(log_price_euros))+ geom_histogram(bins = 50) # normal


# build regression models with log_price and all variables that might be relevant
regression_all_with_reviews <- lm(log(price_euros)~ .-id -price - price_per_person -log_price_euros -id_check,airbnb_listings_with_reviews)
summary(regression_all_with_reviews)
regression_all_without_reviews <- lm(log(price_euros)~ .-id -price - price_per_person -log_price_euros -id_check, airbnb_listings_without_reviews)
summary(regression_all_without_reviews)


## check assumptions
autoplot(regression_all_with_reviews) #linear, normal and approximately equal variances
autoplot(regression_all_without_reviews) #linear, normal and approximately equal variances


# create a dataframe with models output
df_regression_with_reviews <- tidy(regression_all_with_reviews)
df_regression_without_reviews <- tidy(regression_all_without_reviews)


# check what amenities we want to keep in the model (amenities can be recognized by the X. string)
df_regression_amenities_with_reviews<-df_regression_with_reviews[df_regression_with_reviews$term %like% "X.",]
df_regression_amenities_without_reviews<-df_regression_without_reviews[df_regression_without_reviews$term %like% "X.",]


# get amenities with p-value less than 0.05, to only include significant variables
df_regression_with_reviews_amenities_keep <- df_regression_amenities_with_reviews %>% filter(p.value <0.05) 
df_regression_without_reviews_amenities_keep <- df_regression_amenities_without_reviews %>% filter(p.value <0.05)


# limit the model to the 10 amenities that have the biggest impact based on absolute estimate (this makes the final app easier to work with, since users don't have to specify too many amenities that don't have a big impact)
df_regression_with_reviews_amenities_keep <- df_regression_with_reviews_amenities_keep  %>% arrange(desc(estimate))
df_regression_with_reviews_amenities_keep <- df_regression_with_reviews_amenities_keep[1:10,]

df_regression_without_reviews_amenities_keep <- df_regression_without_reviews_amenities_keep  %>% arrange(desc(estimate))
df_regression_without_reviews_amenities_keep  <- df_regression_without_reviews_amenities_keep [1:10,]


# check what other variables we want to keep in the model, by applying a cutoff of 0.075 for the estimate and 0.05 for the p-value
df_regression_with_reviews_others<-df_regression_with_reviews[!df_regression_with_reviews$term %like% "X.",]
df_regression_with_reviews_others_keep <- df_regression_with_reviews_others %>% filter(p.value <0.05) %>% filter(abs(estimate) > 0.075)
View(df_regression_with_reviews_others_keep)
variables_to_keep_list_with_reviews<- c('property_type', 'bathrooms_text', 'room_type', 'accommodates', 'city', 'host_response_time', 'review_scores_rating', 'review_scores_cleanliness', 'review_scores_location', 'review_scores_value')

df_regression_without_reviews_others<-df_regression_without_reviews[!df_regression_without_reviews$term %like% "X.",]
df_regression_without_reviews_others_keep <- df_regression_without_reviews_others %>% filter(p.value <0.05) %>% filter(abs(estimate) > 0.075)
View(df_regression_without_reviews_others_keep)
variables_to_keep_list_without_reviews<- c('property_type', 'bathrooms_text', 'room_type', 'accommodates', 'city', 'host_response_time')


# merge the amenities to keep and the variables to keep list
variable_list_with_reviews<-c(df_regression_with_reviews_amenities_keep$term, variables_to_keep_list_with_reviews)
variable_list_without_reviews<-c(df_regression_without_reviews_amenities_keep$term, variables_to_keep_list_without_reviews)


# adjust the variable list such that it can be added as a formula in the regression
variable_list_with_reviews <- paste0('`',variable_list_with_reviews, '`')
character_variables_with_reviews<-paste0(variable_list_with_reviews, collapse= '+')

variable_list_without_reviews <- paste0('`',variable_list_without_reviews, '`')
character_variables_without_reviews <-paste0(variable_list_without_reviews, collapse= '+')


# build regression models with all relevant variables
regression_final_with_reviews <- lm(as.formula(paste0('log(price_euros)~', character_variables_with_reviews)), airbnb_listings_with_reviews)
summary(regression_final_with_reviews)

regression_final_without_reviews <- lm(as.formula(paste0('log(price_euros)~', character_variables_without_reviews)),airbnb_listings_without_reviews)
summary(regression_final_without_reviews)


# write the regression output to a data frame
df_regression_final_with_reviews <- tidy(regression_final_with_reviews)
df_regression_final_without_reviews <- tidy(regression_final_without_reviews)


# save the regression output of both models
write.csv2(df_regression_final_with_reviews, file = "../../data/regression_output_with_reviews.csv")
write.csv2(df_regression_final_without_reviews, file = "../../data/regression_output_without_reviews.csv")