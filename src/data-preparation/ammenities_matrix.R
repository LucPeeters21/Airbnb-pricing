################################################################################
#this script is used to create a matrix that indicates for each listing the amenities that are present
################################################################################
#load relevant packages
library(tidyr)
library(dplyr)
library(stringr)
library(googledrive)


#Download the listings data from our google drive with the googledrive package:
data_id <-"1Tek0FsrdpnnvzQukog_lmtWAHHvhJJUQ" #the id of the dataset
drive_download(as_id(data_id), path = "Airbnb_EU_listings_reduced.csv", overwrite = TRUE) #download the data from the drive
Listings<-read.csv("Airbnb_EU_listings_reduced.csv", sep=";") #save the data in a dataframe


#extract the amenities column (this is the colomn that we want to investigate:
Ammenities<-as.data.frame(Listings$amenities)


#Remove the opening and closings brackets of the list and remove spaces (the spaces seem to cause amenities that are actually the same to differ from eachother): 
signs_to_remove <- c("\\[|\\]| ") #define the signs to remove
Ammenities$'Listings$amenities' <-str_replace_all(Ammenities$'Listings$amenities', signs_to_remove, "") #remove the signs


#Next, we want to seperate the amenities that are in the list of amenities cell into seperate cells. 
#Since the length of this list differs for every listing, we want to know the maximum number of cells we would need to fit all data.
#we do that with the following line of code:
max_nr_amenities<-max(str_count(Ammenities$`Listings$amenities`, ","))


#Then, we create the matrix with all Amenities in a separete cell.
#To do this, we need 'max_nr_amenities' different column names, which we can create by the first line below:
long_list<- as.character( seq(1:max_nr_amenities))
Amenities_matrix<-separate(data = Ammenities, col="Listings$amenities", into = long_list, sep = ",") #Finally, create the amenities matrix


################################################################################
#To keep the analysis of amenities workable, we choose to only look at amenities that occur at at least 1% of the listings.
#We find out what amenities these are with below code:


#First, we store the number of occurences of all amenities in the amenities matrix:
Amenities_frequency<-as.data.frame(table(unlist(Amenities_matrix)))


#Then, filter for only the amenities that occur in more than 1% of listings, and sort it descending:
cut_off<-0.01 #define in what percentage of listings an amenity should occur to consider it as relevant for our analysis
Relevant_amenities<-Amenities_frequency %>% filter(Freq>cut_off*nrow(Amenities_matrix))
Relevant_amenities<-Relevant_amenities %>% arrange(desc(Freq))


#the next step is to create an empty dataframe whith columns that represent the relevant amenities.
#This dataframe should contain a row for each listing in our data.
#With this format, we can indicate the presence of each relevant amenity for each listing in a clear manner later on.
most_frequent_amenities<-as.character(Relevant_amenities$Var1) #this is a list with the names of the most frequent amenities, which we will later use as our column names
Presence_matrix<- data.frame(matrix(ncol = length(most_frequent), nrow=nrow(Amenities_matrix))) #then, we create the empty data frame to later store the presence of each amenity per listing
colnames(Presence_matrix)<- c(most_frequent_amenities) #change the column names into the names of the amenities


################################################################################
#Then, we will loop over all columns of relevant amenities and check for each listing if it has that amenity


for (am in colnames(Presence_matrix)){ #loop over all amenities in the presence matrix
  
  
  print(am) #print what amenity we are currently looking at
  Present<-apply(Amenities_matrix, 1, function(r) any(r %in% am)) #check for each listing if it has the amenity
  
  
  #save to the presence matrix what listings have the amenity, where 1 indicates presence and 0 indicates abscense of the amenity
  for (listing in 1:length(Present)){
    if (Present[listing]==1){ Presence_matrix[listing,am]<-1} else {Presence_matrix[listing,am]<-0}
  }
}


################################################################################
#Finally, add the id of the listing to each row and save the data in a csv


Presence_matrix$id_check<-Listings$id #add the listing id's
write.csv2(Presence_matrix, "Presencematrix_v3.csv") #save the data to csv