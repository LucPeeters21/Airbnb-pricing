# Data Preparation

### Table of Contents

#### 1. Merging process
- 1.1 Importing the data
- 1.2 Drop and add columns before merging
- 1.3 Merge data
- 1.4 First inspection
#### 2. Data cleaning
- 2.1 Remove duplicates
- 2.2 Remove inconvenient symbols from data
- 2.3 Assure correct data types
- 2.4 Create values for valutas
- 2.5 Convert prices of non-euro countries
- 2.6 Check data for face validity
- 2.7 Remove extreme outliers from dataframe
- 2.8 Remove variables that will not be used in analysis
- 2.9 Change values of host information
- 2.10 Create dummy variable for property type
- 2.11 Check for missing values
#### 3. Wrap-up inspection
- 3.1 Wrap-up inspection

## 1. Merging process

### 1.1 Importing the data
This process was done by downloading the files consisting of the Airbnb data and the scraped data with additional info from the groups's Google Drive. Both files where then saved into seperate dataframes, one consisting of delivered data from Airbnb (airbnb_listings) and on consisting of scraped data with amenitities belonging to each observation in the data (airbnb_amenities).
```
data_id <-"1Tek0FsrdpnnvzQukog_lmtWAHHvhJJUQ" #the id of the dataset
drive_download(as_id(data_id), path = "eu_listings.csv", overwrite = TRUE) #download the data from the drive
airbnb_listings<-read.csv("eu_listings.csv", sep=";") #save the data in a dataframe

data_id_2 <-"15TYK8aDRcJwdPgaNWdu8NSbQVNgTMgqN" #the id of the dataset
drive_download(as_id(data_id_2), path = "presencematrix.csv", overwrite = TRUE) #download the data from the drive
airbnb_amenities<-read.csv("presencematrix.csv", sep=";") #save the data in a dataframe
```
### 1.2 Drop and add columns before merging
Since both datafiles consisted of an identical 'price' column, it was decided to drop this column from airbnb_amenities before merging them into one dataframe. Additionaly, a new column consisting of the unique id of each observation was added to check whether the data was still framed well after merging. 
### 1.3 Merge data
Both dataframes were merged into one dataframe consisting of the original data delivered by Airbnb with additional variables showing the amenitites that are present at each accomodation.
### 1.4 First inspection
After merging the seperate datafiles, a dataframe consisting of 330166 rows with observations, each representing an Airbnb accomodation, was left for further preparation. At this stage, the dataframe had 153 seperate variables, which was mostly due to the large range of amenities. For the amenities, each variable had either a value score of 1 in case that a certain amenity was present at an accomodation and a value score 0 when otherwise.

## 2. Data cleaning

### 2.1 Remove duplicates
The first step in the data cleaning process was to check for duplicates in the dataframe, in which 2 observations were removed.

### 2.2 Remove inconvenient symbols from data
In this stage, the '$' sign and comma were removed from the 'price' variables in order to only remain numbers for each observation that represent the price of an accomodation. Additionaly, the '%' sign was removed from 'host_response_rate' for the same purpose.

### 2.3 Assure correct data types
All the variables were changed to correct data types for analysis purposes. All variables what a numeric value were changed into numeric data types after creating a seperate list conisting of these specific variables. Additionaly, the column consisting of the number of bathrooms had to be recoded, since it included text. 

### 2.4 Create values for valutas
Since all values  in the 'price' column were shown in own valutas, multiple values had to be changed into euros for a number of countries by creating a value that represented the rate of a given currency. This was done for the non-euro countries in the data set: Czech Republic, Sweden and Denmark.
```
czk <- 0.04 # value of 1 CZK in EUR (as of 12-2021)
ddk <- 0.134  # value of 1 DDK in EUR (as of 12-2021)
sek <- 0.097 # value of 1 SEK in EUR (as of 12-2021)
```
Note that the currency rates of valutas fluctuate over time. The currency rates used in the dataset are from the same period as the delivered from Airbnb.

### 2.5 Convert prices of non-euro countries
The values in the 'price' column for the accomodations in Czech Republic, Sweden and Denmark were converted into euros by using the mentioned values and taking the product of these values and the prices of their own respective currency rate. In thise stage, an additional column consisting of the price in euros was created to check whether the convertions to euro were handled correctly.
```
airbnb_listings <- airbnb_listings %>% mutate(price_euros=ifelse(country == "Czech Republic", price*czk,
                                                                 ifelse(country == "Denmark", price*ddk,
                                                                        ifelse(country == "Sweden", price*sek, price))))
```
### 2.6 Check data for face validity
In this stage, an additional column representing the price in euros per person was created. Using this variable, the mean price per person for each country was calculated to check whether the prices seemed to be realistic. Since this wasn't the case for certain countries, it was concluded that there had to be a number of extreme outliers in the 'price' column.

### 2.7 Remove extreme outliers from dataframe
Since there were prices in the dataset that showed either a value of 0 or an extremely high value, it was decided to drop these kind of observations. The cutoff point for this process was set at a minimum of at least 0 and a maximum of 1500 in terms of price in euros per person. This process caused a decrease in the number of observations, leaving the dataset with a total of "......." rows.

### 2.8 Remove variables that will not be used in analysis
At this point, it was decided that certain variables were not suitable for analysis and therefore had to be removed from the dataset. This included unnecessary host information and variables that overlapped with others. For this purpose, the country and neighbourhood variables were removed, since they would overlap with the 'city' column. Additionaly, the column that consisted of the list of amenities, which had already been turned into seperate columns, was removed. 
```
airbnb_listings <- airbnb_listings %>% select(-X.x, -X.y, -neighbourhood, -maximum_nights, -host_since, -host_listings_count, 
                  -amenities, -neighbourhood_cleansed, -country)
```
### 2.9 Change values of host information
The relevant host information about being a superhost and whether the identity of the host is publicly known, appeared in the dataset with the values 't' for true and 'f' for false. These values were changed into '1' for true and '0' for false.

### 2.10 Create dummy variable for property type
Since there was wide variation in the 'property type' column, it would be inconvenient to take all into account for regression. Therefore, it was decided that only the property types that appeared in at least 1% of all observations would be kept, creating a variety of property types that are relevant and that can be handled when creating the regression. All observations with a property type appearing in less than 1% were kept in the dataframe, but their property type value was changed to 'non-common property type' in order to not throw away any valuable data. 
```
table_property_type <-as.data.frame(table(airbnb_listings$property_type))
table_cut_of<- table_property_type %>% filter(Freq >0.01*nrow(airbnb_listings))
airbnb_listings <- airbnb_listings %>% mutate(property_type=ifelse(property_type %in% table_cut_of$Var1, property_type, 
                   'Non-common proporty type'))
```

### 2.11 Check for missing values 
It was observed that in 33% of the cases the host response rate is not recorded. Additionally, the value of bedrooms is missing in 6% of the cases. Since there are other variables present in the dataset that are able to capture the service of the host and the capacity of an accomodation, it was decided to remove these two variables from the dataset. 

Moreover, it was also observed that review scores are absent in 21% of the observations. In this case, there is no other variable in the dataset that captures consumers' opinion about an accomodation. Therefore, it is essential to keep this variable in the dataset. Since it is impossible to ignore the amount of missing values in this variable, it was decided to take a closer look into the reviews. It was observed that there is a significant difference between the price of accomodations with a review score, and accomodations without a review score. Therefore, the analysis will consist of two parts, one part for listings with a review score and the other part for listings without a review score.

```
airbnb_listings_with_reviews<-airbnb_listings%>% filter(!is.na(review_scores_value))
mean(airbnb_listings_with_reviews$price_euros)

airbnb_listings_without_reviews<-airbnb_listings%>% filter(is.na(review_scores_value))
mean(airbnb_listings_without_reviews$price_euros)
```
After creating these two different datasets, all variables regarding review scores were removed from the dataset without reviews. To wrap things up concerning the preparation of the data, a last check was done to see if there were no more missing values that cause more than 5% of the data to be removed from analysis for both datasets:
```
df_missing_values_with_reviews<-as.data.frame(sapply(airbnb_listings_with_reviews, function(x) sum(is.na(x))))
df_missing_values_without_reviews<-as.data.frame(sapply(airbnb_listings_without_reviews, function(x) sum(is.na(x))))
```

## 3. Wrap-up inspection
After cleaning the data, two seperate datasets remained:

- airbnb_listings_with_reviews -> 258974 observations with 144 variables
- airbnb_listings_without_reviews -> 69589 observations with 136 variables

These two dataframes were used for the analysis and the creation of the dynamic estimation tool.









