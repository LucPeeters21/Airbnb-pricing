library(broom)
library(haven)
library(dplyr)
library(ggplot2)
library(car)
library(rms)
install.packages('data.table')
library(data.table)
#### What drives the price of Airbnb accomodations?

# Check for normality
ggplot(airbnb_listings, aes(price_euros))+ geom_histogram(binwidth = 50) + xlim(0, 22191) + ylim(0, 2700) # non-normal

# Take log of price_euros
airbnb_listings <- airbnb_listings %>% mutate(log_price_euros=log(price_euros))

# Check the plot again for normality but this time using the log of price_euros
ggplot(airbnb_listings, aes(log_price_euros))+ geom_histogram(bins = 50) # normal


# Build regression model with all variables
regression_all <- lm(log_price_euros~.,airbnb_listings)
summary(regression_all)

# Create a dataframe with models output
df_regression <- tidy(regression_all)
df_regression

# Get variables with p-value less than 0.05
df_regression_significant <- df_regression$term[df_regression$p.value < 0.05]
df_regression_significant

coeftable = data.table(summary(regression_all)$coefficients)
coeftable[, variable:=rownames(summary(regression_all)$coefficients)]
setnames(coeftable, c('est','se','t','p','variable'))
setcolorder(coeftable, 'variable')

sigvariables = coeftable[p<.05]$variable
sigvariables = paste0('`', sigvariables, '`')

character_variables = paste0(sigvariables, collapse='+')

as.formula(paste0('hannes~1+', character_variables))





