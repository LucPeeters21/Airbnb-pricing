# Airbnb - Don't Pay Too Much

### Management summary

In the early years of Airbnb's existence, the business was widely known as an affordable and friendly way to travel. The fact that it was a way for hosts to make some extra money and for travellers to find a bed for competitive prices turned the concept into a massive success. However, the growth of Airbnb comes with certain disadvantages. One of them is the increasing cost of renting an accomodation trough Airbnb. The project will focus on creating a price estimating tool that both hosts and renters of Airbnb accomodations can use to become better informed about the average price for similar accomodations. 

The data used in the research is gathered using an available Airbnb dataset, with additional data retrieved through scraping the Airbnb website. The data will be used to build a tool that, for both host and renter, answers the question: *"What is the average price for an accomodation similar to the one that I am renting?"*. This tool will be based upon *linear regression* and includes variables that are retrieved from the available and scraped Airbnb data. The outcome variable will show the average price of an accomodation with characteristics that are used as input variables. These variables are based on characteristics regarding (1) ***demographics*** (e.g., city, neighbourhood, nearby facilities), (2) ***accomodation*** (e.g., rating, number of reviews, amenities etc.) and (3) ***host*** (e.g., number of accomodations owned by hosts). 

Eventually, the results of the research are planned to be presented using a website. This website shows the tool which one can use to estimate the price of their accomodation. To come to estimation, the visitor of the website has to fill out all characteristcs of their respective accomodation. The tool then builds a linear regression based on these characteristics and shows as an output the average price. Hosts can use this information in order to set a price for their accomodation and renters can use it to decide whether they are willing to pay a certain price when being confronted with the average price of similar accomodations. The goal is to keep the Airbnb market honest and transparant.

### Research method
To collect the required data, two data collection methods will be used. Firstly data that is made available by Airbnb (http://insideairbnb.com/get-the-data.html) will be used to retrieve information about the prices in the different cities. Secondly, a web-scraper will be used that retrieves information on the data that isn't provided by Airbnb. For example Airbnb doesn't provide information about the different characteristics an Airbnb rental has (e.g., city, neighbourhood, nearby facilities). These characteristics will be used as explanatory variables for price and by using linear regressions, the significance and the size of the effect can be determined for a variety of circumstances.

### Relevance
This research question covers both hosts and tenants of Airbnb. This research will investigate whether hosts ask too much money for their Airbnb. It definitely is an important topic to investigate,
because for hosts, it is very attractive to rent out their home via Airbnb, especially if the person lives in a popular city. For example, consider Amsterdam, it is a tourist attraction and hosts can charge a huge rent for an Airbnb. First, this research examines whether a hosts is allowed to charge the rent it does. Secondly, this research is very relevant because there is a correlation between the number of Airbnb's and the house price in the Netherlands. 
Again, taking Amsterdam into consideration, there the general house price is bizarrely high, according to a study by (Woudstra, 2018), this is partly due to the high number of Airbnb's, 20,000 in 2019. Landlords with a lot of money see an easy opportunity to make a lot of money.  As a result, fewer owner-occupied houses become available for the private individual and student houses for the student. The logical consequence is that prices rise exponentially. 
This study seeks to expose that landlords are charging way too much for their Airbnb with the hope that rents will fall, fewer Airbnb’s will become available, more buying homes, and at least house prices will not continue to rise.

### Literature
Woudstra, E. (2018, decembre 10). De prijzen schieten omhoog: De invloed van Airbnb op de woningmarkt. Spatial, Transport and Environmental Economics. Retrieved February 22, 2022, from https://spatialeconomics.nl/korte-termijnverhuur-van-accommodaties-de-invloed-van-airbnb-op-de-woningmarkt/
### Authors

Annabelle den Heijer, Mike Verweij, Sjors Boelaars, Bouke Schippers, Luc Peeters

### Executing program

* How to run the program
* Step-by-step bullets
```
code blocks for commands
```

### Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

### Version History

* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

### License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
