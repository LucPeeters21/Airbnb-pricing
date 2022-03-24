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
After merging the seperate datafiles, a dataframe consisting of 330166 rows with observations, each representing an Airbnb accomodation, was left for further preparation. At this stage, the dataframe had 153 seperate variables, which was mostly due to the large range of amenities. For the amenities, each variable had either a value score of 1 in case that a certain amenity was present at an accomodation and a value score 0 when otherwise.

## 2. Data cleaning

### 2.1 Remove duplicates
The first step in the data cleaning process was to check for duplicates in the observations, in which no observations were found.

### 2.2 Remove inconvenient symbols from data
In this stage, the '$' sign and comma were removed from the 'price' variables in order to only remain numbers for each observation that represent the price of an accomodation. Additionaly, the '%' sign was removed from 'host_response_rate' for the same purpose.

### 2.3 Assure correct data types
All the variables were changed to correct data types for analysis purposes. All variables what a numeric value were changed into numeric data types after creating a seperate list conisting of these specific variables. Additionaly, the column consisting of the number of bathrooms had to be recoded, since it included text. 

### 2.4 Create values for valutas
Since all values  in the 'price' column were shown in own valutas, multiple values had to be changed into euros for a number of countries by creating a value that represented the rate of a given currency. This was done for the non-euro countries in the data set: Czech Republic, Sweden and Denmark.

![image](https://user-images.githubusercontent.com/98958192/159895485-3719cc3e-391f-4460-bf68-ad1061752906.png)

Note that the currency rates of valutas fluctuate over time. The currency rates used in the dataset are from the same period as the delivered from Airbnb.

### 2.5 Convert prices of non-euro countries
The values in the 'price' column for the accomodations in Czech Republic, Sweden and Denmark were converted into euros by using the mentioned values and taking the product of these values and the prices of their own respective currency rate. In thise stage, an additional column consisting of the price in euros was created to check whether the convertions to euro were handled correctly.

![image](https://user-images.githubusercontent.com/98958192/159897524-5f0e2e3f-4e14-4132-a6a3-766ee3aa1f03.png)

### 2.6 Check data for face validity
In this stage, an additional column representing the price in euros per person was created. Using this variable, the mean price per person for each country was calculated to check whether the prices seemed to be realistic. Since this wasn't the case for certain countries, it was concluded that there had to be a number of extreme outliers in the 'price' column.

### 2.7 Remove extreme outliers from dataframe
Since there were prices in the dataset that showed either a value of 0 or an extremely high value, it was decided to drop these kind of observations. The cutoff point for this process was set at a minimum of at least 0 and a maximum of 1500 in terms of price in euros per person. This process caused a decrease in the number of observations, leaving the dataset with a total of "......." rows.

### 2.8 Remove variables that will not be used in analysis
At this point, it was decided that certain variables were not suitable for analysis and therefore had to be removed from the dataset. This included unnecessary host information and variables that overlapped with others. For this purpose, the country and neighbourhood variables were removed, since they would overlap with the 'city' column. Additionaly, the column that consisted of the list of amenities, which had already been turned into seperate columns, was removed. 

![image](https://user-images.githubusercontent.com/98958192/159900303-2e35caa9-4164-4036-b6a3-507809e55687.png)

### 2.9 Change values of host information
The relevant host information about being a superhost and whether the identity of the host is publicly known, appeared in the dataset with the values 't' for true and 'f' for false. These values were changed into '1' for true and '0' for false.

### 2.10 Create dummy variable for property type
Since there was wide variation in the 'property type' column, it would be inconvenient to take all into account for regression. Therefore, it was decied that only the property types that appeared in at least 1% of all observations would be kept, creating a variety of property types that are relevant and that can be handled when creating the regression. All observations with a property type appearing in less than 1% were kept in the dataframe, but there property type value was changed to 'non-common property type' in order to not throw away any valuable data. 

![image](https://user-images.githubusercontent.com/98958192/159901924-3ffbc407-c10c-4411-8c93-eff8638f42b7.png)

## 3. Wrap-up inspection
The dataset after cleaning consisted of 328564 rows with 146 different columns. Each row represented in an accomodation in one of the 13 countries taken into account for the analysis. 









