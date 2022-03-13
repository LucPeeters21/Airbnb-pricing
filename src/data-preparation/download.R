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