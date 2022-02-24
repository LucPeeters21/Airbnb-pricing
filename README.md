# Airbnb - Don't Pay Too Much

Hi and welcome to our repository! This repository includes research done by five students of the Tilburg University about Airbnb. As you might know in the early years of Airbnb's existence, the business was widely known as an affordable and friendly way to travel. The fact that it was a way for hosts to make some extra money and for travellers to find a bed for competitive prices turned the concept into a massive success. However, the growth of Airbnb comes with certain disadvantages. One of them is the increasing cost of renting an accomodation trough Airbnb as can be seen in the graph below. Therefore we made an estimating tool that renters of Airbnb accomodations can use to become better informed about the average price for similar accomodations. 
![image](https://user-images.githubusercontent.com/98957827/155588734-57418bdc-111e-48ff-808a-09fbe5bca812.png)

Hi and welcome to our repository! This repository includes research done by five students of the Tilburg University about Airbnb. As you might know in the early years of Airbnb's existence, the business was widely known as an affordable and friendly way to travel. The fact that it was a way for hosts to make some extra money and for travellers to find a bed for competitive prices turned the concept into a massive success. However, the growth of Airbnb comes with certain disadvantages. One of them is the increasing cost of renting an accomodation trough Airbnb as can be seen in the graph below. Therefore we made an estimating tool that renters of Airbnb accomodations can use to become better informed about the average price for similar accomodations. 

That sound nice right! It gets even better. 
This estimating tool will be available on a website. To come to estimation, the visitor of the website has to fill out all characteristcs of their respective accomodation. The tool then builds a linear regression based on these characteristics and shows as an output the average price.

The data used in the research is gathered using an available Airbnb dataset, with additional data retrieved through scraping the Airbnb website. The data will be used to build a tool that, for both host and renter, answers the question: *"What is the average price for an accomodation similar to the one that I am renting?"*. This tool will be based upon *linear regression* and includes variables that are retrieved from the available and scraped Airbnb data. The outcome variable will show the average price of an accomodation with characteristics that are used as input variables. These variables are based on characteristics regarding (1) ***demographics*** (e.g., city, neighbourhood, nearby facilities), (2) ***accomodation*** (e.g., rating, number of reviews, amenities etc.) and (3) ***host*** (e.g., number of accomodations owned by hosts). 


### Research method
To collect the required data, two data collection methods will be used. Firstly data that is made available by Airbnb (http://insideairbnb.com/get-the-data.html) will be used to retrieve information about the prices in the different cities. Secondly, a web-scraper will be used that retrieves information on the data that isn't provided by Airbnb. For example Airbnb doesn't provide information about the different characteristics an Airbnb rental has (e.g., city, neighbourhood, nearby facilities). These characteristics will be used as explanatory variables for price and by using linear regressions, the significance and the size of the effect can be determined for a variety of circumstances.

### Literature

### Authors

Annabelle den Heijer, [Mike Verweij](https://github.com/Mikeverweij96), Sjors Boelaars, Bouke Schippers, Luc Peeters

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
