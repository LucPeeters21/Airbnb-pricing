#First, load some usefull packages:
library(tidyverse)
library(here)
library(ggplot2)
library(dplyr)

#Secondly, install the gsheet package, which is a handy package to download data from google drive:
#install.packages('gsheet')  
library(gsheet) 

#load the list of links to listing downloads of all cities on InsideAirbnb:
City_list <- gsheet2tbl('https://drive.google.com/open?id=d/1h0K6VKTCU1u-jRNRQLaEjzwmtsEVliVhmDiLnFV6V6M/edit?usp=sharing')

#Retrieve and save the first dataset:
con <- gzcon(url(paste(City_list[1,],
                       "", sep="")))
txt <- readLines(con)
Airbnb_listings<- read.csv(textConnection(txt))
Airbnb_listings$link<-substr(City_list[1,],1,nchar(City_list[1,])-15) #save the link from which we downloaded this city

Error_cities<-c() #use this vector to store cities that we could not add to the dataset


#loop over all cities in the City list:
for (i in 2:nrow(City_list)){
  
  #Print what city we will retrieve data of:
  print(City_list[i,])
  print(i)
  
  URL<-City_list[i,] #save the url of the city we will download the data of
  
  
  #download the data of the city in interest and store it in a temporary variable:
  con <- gzcon(url(paste(URL,
                         "", sep="")))
  txt <- readLines(con)
  temporary_data <- tryCatch({read.csv(textConnection(txt))}, 
  error = function(e){
    return(NA) #in the rare case that we could not download the data, we want to return an NA, to prevent the program from crashing
  }
  )
  
  #Bind the temporary dataframe of this cities listings with the previously downloaded dataframes:
  if(!is.na(temporary_data)){ #only proceed for cities that were avaialble to download
    
    temporary_data$link<-substr(City_list[i,],1,nchar(City_list[i,])-15) #save the link from which we downloaded these entries
    
    if(ncol(temporary_data)==ncol(Airbnb_listings)){ #only continue if the number of columns are the same, this will leave out datasets of whole countries(otherwise the program will crash)
  Airbnb_listings<-rbind(Airbnb_listings,temporary_data)  
  } else {
    Error_cities<-c(Error_cities, i)
  } 
  }else{
    Error_cities<-c(Error_cities,i)
  }
  
  
}


closeAllConnections() #Close all connections to prevent running out of open connections

#Since we will save the data to a file that is separated by ';', we want to remove this value from the data if it is present:
Airbnb_listings <-data.frame(lapply(Airbnb_listings, function(x){
  gsub(";",",", x)
}))

#since some of the csv.gz files seem to have rows appended that are not relevant, we want to remove them. Below seems to be a fine solution for this:
Airbnb_listings<-Airbnb_listings[!is.na(as.numeric(as.character(Airbnb_listings$id))),]
Airbnb_listings<-Airbnb_listings[!is.na(as.numeric(as.character(Airbnb_listings$scrape_id))),]
Airbnb_listings<-Airbnb_listings[!is.na(as.numeric(as.character(Airbnb_listings$host_id))),]
Airbnb_listings<-Airbnb_listings[grepl("https",Airbnb_listings$listing_url),]


Airbnb_listings_final<-Airbnb_listings[grepl(".00",Airbnb_listings$price),] #We only want listings for which we have a price (note, every price seems to contain .00, so this is a good filter)

#Finally, safe the data to a csv: 
write.csv2(Airbnb_listings_final, file = "Airbnb_ALL_listings.csv")
