# Analysis
## Type of analysis
To examine the relationship between the metric dependent variable price and the 144 independent variables, a multiple linear regression has been performed. This enables us to account for all important factors and get a precise understanding of the relationship between each individual factor and the price of an Airbnb. In the data preparation it appeared that there was a big significant difference in price between Airbnbs with and without reviews: the mean price for Airbnbs with reviews was €114,05 and the mean price for Airbnbs without reviews was €183,31. This big difference made us decide to run a regression on Airbnbs with and without reviews separately.

## Check assumptions
To visually check the assumptions required for regression analysis, a few plots have been created using the following codechunk:
```
autoplot(regression_all_with_reviews)
autoplot(regression_all_without_reviews
```
The plots on the left represent the plots of the regression with reviews and the plots on the right of the regression without reviews.

### Linearity
The first assumption that was checked was linearity, to check this assumption we used a plot which shows the residuals and the fitted values. Visually checking, the residuals seem to bounce randomly around the zero line for both regressions which suggests that the assumption of linearity is reasonable.

![residualsvsfitted1](https://user-images.githubusercontent.com/98892780/160093851-7a056a3a-3137-41eb-94a9-c953bfe34b59.PNG)![residualsvsfitted2](https://user-images.githubusercontent.com/98892780/160093885-6edc48ae-7084-4535-a8ab-4c2c7c6b3dd4.PNG)


### Normality
The second assumption that was checked is whether the dependent variable was normally distributed. After plotting the distribution of the dependent variable it showed us that it was not normally distributed. Since the dependent variable was not normally distributed, we took the natural logarithm of the variable which made the distribution more symmetric. We also examined whether the residuals were normally distributed by using a QQ-plot. Both QQ-plots show that most of the residuals are close to the diagonal line, except for really low and really high prices. For these price levels the residuals are not normally distributed which means that this may lead to less precise predictions of the price calculator for these price levels. 

![QQ-plot1](https://user-images.githubusercontent.com/98892780/160093912-7b6f86d7-7f84-4916-abb4-df7ad4e81a88.PNG)![QQ-plot2](https://user-images.githubusercontent.com/98892780/160093935-2dce8b73-f915-48eb-aa8b-03a7e0d60f60.PNG)


### Homoscedasticity
The last assumption, the assumption of homoscedasticity was checked to see whether the error term is the same across all variables. This was done by using a scale-location plot in which we can visually check if there is any pattern that stands out. In both regressions the horizontal line is almost flat and we can see random spread points which indicates that the assumption of homoscedasticity is satisfied.

![scale-location plot1](https://user-images.githubusercontent.com/98892780/160093996-f24cdd98-d8a0-485d-bd8b-e83d7a5e7b17.PNG)![scale-location plot2](https://user-images.githubusercontent.com/98892780/160094175-59e164fa-2b8f-481a-83c8-5800d546d280.PNG)


## Regression analysis
After creating the two datasets, with and without reviews, the regression was performed. The regression showed that a lot of the amenities had an insignificant effect on price or only had a very small effect. To limit the number of amenities that a user of the shiny app should specify, the decision was made to only use amenities with a p-value smaller than 0.05 and an effect that is bigger than 0.075. This led to a final dataset for the regression with 20 predictors for the price of an Airbnb with reviews (R-squared equal to 0.4797) and 16 predictors for the price of an Airbnb without reviews (R-squared equal to 0.3644). 

The regression was performed and was written to a csv file which has been used as input for the Shiny App dashboard for calculating a reasonable price for an Airbnb. In this analysis we can give an example of what the effect of one or multiple of the independent variables on the price of an Airbnb is, but it is much more interesting to do this yourself by opening the Shiny app and selecting some of the independent variables. The price calculator will then calculate a reasonable price for the Airbnb in the city and with the amenities you have selected. Go check it out! --> [Airbnb price calculator](https://github.com/LucPeeters21/Airbnb-pricing/tree/main/src/pricing-app).
