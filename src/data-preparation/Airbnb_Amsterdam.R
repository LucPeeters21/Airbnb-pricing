library(haven)
library(dplyr)
library(ggplot2)
library(car)
library(readxl)
library(base)

# Import data Amsterdam
setwd("C:/Users/Gebruiker/Documents/0. Master Marketing Analytics/Skills Data Prep.&Workflow Mgt")
Airbnb_listings_Amsterdam <- read_excel("AirBNB_data_with_Amenities.xlsx")
View(Airbnb_listings_Amsterdam)

# Inspect data
summary(Airbnb_listings_Amsterdam)
host_id_count <- count(Airbnb_listings_Amsterdam, host_id)

#Histogram


# Scatterplot
ggplot(Airbnb_listings_Amsterdam, aes(x=number_of_reviews, y=price))+ geom_point()
ggplot(Airbnb_listings_Amsterdam, aes(x=neighbourhood, y=price))+ geom_point()

#Create subsets
mean_prices_neighbourhoods <- Airbnb_listings_Amsterdam %>% select(neighbourhood, price) %>%  group_by(neighbourhood) %>%  summarize_all(mean, na.rm=TRUE)
View(mean_prices_neighbourhoods)
barplot(table(mean_prices_neighbourhoods$neighbourhood))

#simple regression
regr_neigh_price <- lm(price ~ number_of_reviews+room_type+neighbourhood+, Airbnb_listings_Amsterdam)
summary(regr_neigh_price)
