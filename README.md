# Airbnb - Don't Pay Too Much
### Goodbye to overpriced Airbnbs

For a research project on estimating the effect that different Airbnb characterstics have on the price of the Airbnb, we created a tool which enables people to compare the price of a certain Airbnb to other comparable Airbnb's (based on the characterstics of the Airbnb). This can prevent people from booking Airbnb's that ask too much for their listing compared to their competitors. 


## Motivation

This repository includes research done by five students of the Tilburg University about Airbnb. As you might know, in the early years of Airbnb's existence, the business was widely known as an affordable and friendly way to travel. The fact that it was a way for hosts to make some extra money and for travellers to find a bed for competitive prices turned the concept into a massive success. However, the growth of Airbnb came with certain disadvantages. Examples of this are the rapid increasing cost of renting an accomodation trough Airbnb and hosts trying to 'scam' tourists by asking unreasonable high prices for their accomodation. To prevent tourists from booking too expensive Airbnbs, we made an estimating tool that renters of Airbnb accomodations can use to become better informed about a reasonable price for similar accomodations. 

This estimating tool will be made publicly available on a website. To come to the estimation, the visitor of the website has to fill out certain characteristcs of the  respective accomodation. The tool then applies a linear regression to the inserted data. This regression is based on the characteristics of Airbnbs that turned out to have the highest impact on price. The output of the regression is an estimation of the price. 

The data used in the research is gathered from [InsideAirbnb](http://insideairbnb.com/get-the-data.html), which contains different collections of airbnb listings information that were collected through scraping the Airbnb website. The data will be used to build a tool that answers the question: *"What is a reasonable price for an accomodation similar to the one that I am planning to rent?"*. This tool will be based upon *linear regression* and includes variables that are retrieved from the available and scraped Airbnb data. The outcome variable will show the average price of an accomodation with characteristics that are used as input variables. These variables are based on characteristics regarding (1) ***demographics*** (e.g., city, neighbourhood, nearby facilities), (2) ***accomodation*** (e.g., rating, number of reviews, amenities etc.) and (3) ***host*** (e.g., host response time). 

## Research method 

To collect the required data, a web-scraper was build that collects all data sets of EU cities published on [InsideAirbnb](http://insideairbnb.com/get-the-data.html). With the downloaded data, several new variables are created that represent interesting characteristics of Airbnb listings. This data will be used as explanatory variables for price, by applying linear regression. With linear regression, a model can be made that predicts a price based on the characteristics of a listing. This model can later be used to indicate to the users of our app what a reasonable price would be for a certain listing.

## Relevance

This research is particularly relevant for tourists planning to book an Airbnb. Since sometimes hosts on Airbnb try to ask unreasonably high prices for their Airbnb, this research aims to give renters of Airbnbs a tool that can help them check if they are not being scammed. Moreover, the tool provides insights in the prices of comparable Airbnbs in other big European cities, which could help tourists on a budget decide if they should maybe consider visiting another city with lower rental prices. It can be said that the tool created by this research increases the power of Airbnb renters to recognize what a fair price for a listing would be!

## Repository overview

```
├── README.md
├── makefile
└── src
    ├── analysis
    ├── data-collection
    ├── data-preparation
    └── pricing-app
```

### Dependencies

Please follow the installation guide on http://tilburgsciencehub.com/.

- Python. [Installation guide](http://tilburgsciencehub.com/setup/python/).
- R. [Installation guide](http://tilburgsciencehub.com/setup/r/).
- Make. [Installation guide](http://tilburgsciencehub.com/setup/make).
- For the required Python packages, check the source code lines starting with ```from ... import``` and ```import```.
- For the required R packages, check the source code lines starting with ```library```.

### Running the code

Follow the instructions to run the code:
1. Fork this repository
2. Open your command line/terminal:

```
clone https://github.com/LucPeeters21/Airbnb-pricing.git
```
3. To directly run all code use:

```
make
```
4. After these steps you are now able to run the pricing app in ../src/pricing-app -> pricing_app.R

Another option will be to run all code in the following order:
- ../src/data-preparation -> data_preparation.R
- ../src/analysis -> regression.R
- ../src/pricing-app -> pricing_app.R

Note: that above worflow skips the data collection step and the preparation of the amenities matrix. Running these steps typically takes around 20 hours in total. Therefore, the output files of these two steps are stored on our shared google drive folder, from which they are downloaded in the data_preparation file. If one is interested in running these steps too, one should run below files in the following order:
- ../src/data-collection -> Inside_Airbnb_link_scraper.py
- ../src/data-collection -> data_download.R
- ../src/data-preparation -> ammenities_matrix.R

## Authors

[Annabelle den Heijer](https://github.com/annabelledenh), [Mike Verweij](https://github.com/Mikeverweij96), [Sjors Boelaars](https://github.com/SjorsBoelaars1), [Bouke Schippers](https://github.com/BSchippers1), [Luc Peeters](https://github.com/LucPeeters21)
