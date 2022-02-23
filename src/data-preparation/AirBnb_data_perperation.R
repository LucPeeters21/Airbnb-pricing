library(haven)
library(dplyr)
library(ggplot2)
library(car)
library(readxl)
library(base)
library(data.table)


# Import data:
Airbnb_listings<-fread("./data/Large data/Airbnb_ALL_listings.csv")
View(Airbnb_listings)

# Inspect data
summary(Airbnb_listings)
host_id_count <- count(Airbnb_listings, host_id)

#Histogram


# Scatterplot
ggplot(Airbnb_listings, aes(x=number_of_reviews, y=price))+ geom_point()
ggplot(Airbnb_listings, aes(x=neighbourhood, y=price))+ geom_point()

#Create subsets
mean_prices_neighbourhoods <- Airbnb_listings %>% select(neighbourhood, price) %>%  group_by(neighbourhood) %>%  summarize_all(mean, na.rm=TRUE)
View(mean_prices_neighbourhoods)
barplot(table(mean_prices_neighbourhoods$neighbourhood))

#simple regression
regr_neigh_price <- lm(price ~ number_of_reviews+room_type+neighbourhood+, Airbnb_listings)
summary(regr_neigh_price)
