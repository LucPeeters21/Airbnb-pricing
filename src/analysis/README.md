###Analysis
## Type of analysis
To examine the relationship between the metric dependent variable and the XX independent variables, a multiple linear regression has been performed. This enables us to account for all important factors and get a precise understanding of the relationship between each individual factor and the price of an Airbnb.

## Check assumptions
*Normality
The first thing that was checked is whether the dependent variable was normally distributed. After plotting the distribution of the dependent variable it showed us that it was not normally distributed. Since the dependent variable was not normally distributed, we took the natural logarithm of the variable which made the distribution more symmetric. 

*Homoscedasticity

*


## Regression analysis
We performed two linear regression analyses to estimate price based on the amenities. Two because 21% of the observations had no reviews and this is the only indication of customer satisfaction which might have a major influence on the price of an Airbnb. After taking the mean of both observations with and without reviews it appeared that there is a significant difference in price between the two. 

After creating the two datasets, with and without reviews, the regression was performed. The regression also showed that a lot of the amenities were insignificant and some were significant but only had an very small effect. Therefore the decision was made to only use amenities with a p-value smaller than 0.05 and an effect that is bigger than 0.075. This led to a final dataset for the regression with XX predictors for the price of an Airbnb. 

The regression was performed and was written to a csv file which will be used for the dashboard for calculating a reasonable price of an Airbnb.