library(broom)
library(haven)
library(dplyr)
library(ggplot2)
library(car)
library(rms)
#install.packages('data.table')
library(data.table)
#### What drives the price of Airbnb accomodations?

# Check for normality
ggplot(airbnb_listings, aes(price_euros))+ geom_histogram(binwidth = 50) + xlim(0, 22191) + ylim(0, 2700) # non-normal

# Take log of price_euros
airbnb_listings <- airbnb_listings %>% mutate(log_price_euros=log(price_euros))

# Check the plot again for log-normality of price
ggplot(airbnb_listings, aes(log_price_euros))+ geom_histogram(bins = 50) # normal


# Build regression model with log_price and all variables that might be relevant
regression_all <- lm(log(price_euros)~ .-id -price - price_per_person -country -log_price_euros -id_check,airbnb_listings)
summary(regression_all)


# Create a dataframe with models output
df_regression <- tidy(regression_all)


#First, we want to check what amenities we want to keep in the model (amenities can be recognised by the X. string):
df_regression_amenities<-df_regression[df_regression$term %like% "X.",]


# Get amenities with p-value less than 0.05 and absolute estimate above 0.075 to limit the model to the variables that have the biggest impact 
df_regression_amenities_keep <- df_regression_amenities %>% filter(p.value <0.05) %>% filter(abs(estimate) > 0.075)


#Next, we want to check what other variables we want to keep in the model, by applying the same cutoff as for the amenities:
df_regression_others<-df_regression[!df_regression$term %like% "X.",]
df_regression_others_keep <- df_regression_others %>% filter(p.value <0.05) %>% filter(abs(estimate) > 0.075)
View(df_regression_others_keep)

#by inspecting the last dataframe, we conduct below list of variables that we also want to keep:
variables_to_keep_list<- c('property_type', 'bathrooms_text', 'room_type', 'accommodates', 'bedrooms', 'city', 'review_scores_rating', 'review_scores_cleanliness', 'review_scores_location', 'review_scores_value')


#Next, we merge the amenities to keep and the variables to keep list:
variable_list<-c(df_final_regression$term, variables_to_keep_list)


#Adjust the variable list such that it can be added as a formula in the regression
variable_list <- paste0('`',variable_list, '`')
character_variables_test<-paste0(variable_list, collapse= '+')


# Build regression model with all relevant variables
regression_final <- lm(as.formula(paste0('log(price_euros)~', character_variables_test)),airbnb_listings)
summary(regression_final)


#Finally, write the regression output to a dataframe
df_regression_final <- tidy(regression_final)


write.csv2(df_regression_final, file = "RegressionOutput.csv")


