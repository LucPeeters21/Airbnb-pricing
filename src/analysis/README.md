# Analysis
## Type of analysis
To examine the relationship between the metric dependent variable and the 144 independent variables, a multiple linear regression has been performed. This enables us to account for all important factors and get a precise understanding of the relationship between each individual factor and the price of an Airbnb. In the data preparation it appeared that there was a big significant difference in price between Airbnbs with and without reviews, the mean price for Airbnbs with reviews was €114,05 and the mean price for Airbnbs without reviews was €183,31. This big difference made us decide to run a regression on both of them seperately which enables us to make price predictions for both Airbnbs with and without reviews.

## Check assumptions

### Homoscedasticity
First the assumption of homoscedasticity was checked to see whether the error term is the same across all variables. This was done by using a scale-location plot in which we can visually check if there is any pattern that stands out. 

### Normality
The second thing that was checked is whether the dependent variable was normally distributed. After plotting the distribution of the dependent variable it showed us that it was not normally distributed. Since the dependent variable was not normally distributed, we took the natural logarithm of the variable which made the distribution more symmetric. We also examined whether the residuals were normally distributed by using a QQ-plot. The QQ-plot shows that most of the residuals are close to the diagonal line, except for really low and really high prices. For these price levels the residuals are not normally distributed which in the price calculator could lead to less precise predictions. 

### Linearity
The last assumption that was checked was linearity, to check this assumption we used a plot which shows the residuals and the fitted values. 

## Regression analysis
After creating two datasets, with and without reviews, the regression was performed. The regression also showed that a lot of the amenities were insignificant and some were significant but only had an very small effect. Therefore the decision was made to only use amenities with a p-value smaller than 0.05 and an effect that is bigger than 0.075 for the regression. This led to a final dataset for the regression with XX predictors for the price of an Airbnb. 

The regression was performed and was written to a csv file which will be used as input for the dashboard for calculating a reasonable price for an Airbnb.