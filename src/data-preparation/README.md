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
#### 3. Wrap-up inspection
- 3.1 Wrap-up inspection

## 1. Merging process

### 1.1 Importing the data
This process was done by downloading the files consisting of the Airbnb data and the scraped data with additional info from the groups's Google Drive. Both files where then saved into seperate dataframes, one consisting of delivered data from Airbnb (airbnb_listings) and on consisting of scraped data with amenitities belonging to each observation in the data (airbnb_amenities).
![image](https://user-images.githubusercontent.com/98958192/159884510-5a937464-1a0e-4a71-b4a9-7bc2dfe17051.png)
### 1.2 Drop and add columns before merging
Since both datafiles consisted of an identical 'price' column, it was decided to drop this column from airbnb_amenities before merging them into one dataframe. Additionaly, a new column consisting of the unique id of each observation was added to check whether the data was still framed well after merging. 
### 1.3 Merge data
Both dataframes were merged into one dataframe consisting of the original data delivered by Airbnb with additional variables showing the amenitites that are present at each accomodation.
### 1.4 First inspection
After merging the seperate datafiles, a dataframe consisting of 330166 rows with observations, each representing an Airbnb accomodation, was left for further preparation. At this stage, the dataframe had 153 seperate variables. For the amenities, each variable had either a value score of 1 in case that a certain amenity was present at an accomodation and a value score 0 when otherwise.

## 2. Data cleaning

### 2.1 Remove duplicates
The first step in the data cleaning process was to check for duplicates in the observations, in which no observations were found.

### 2.2 Remove inconvenient symbols from data
In this stage, the '$' sign and comma were removed from the 'price' variables in order to only remain numbers for each observation that represent the price of an accomodation. Additionaly, the '%' sign was removed from 'host_response_rate' for the same purpose.

### 2.3 Assure correct data types
All the variables were changed to correct data types for analysis purposes. All variables what a numeric value were changed into numeric data types after creating a seperate list conisting of these specific variables. Additionaly, the column consisting of the number of bathrooms had to be recoded, since it included text. 









