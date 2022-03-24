# Airbnb - Don't Pay Too Much
### Goodbye to overpriced Airbnbs

For a research project on estimating the effects of different amenities on the price of an Airbnb, we created a tool which enables people to compare the price of a certain Airbnb to other comparable Airbnb's (based on amenities). This can prevent people from paying too much when there are better alternatives.


## Motivation

This repository includes research done by five students of the Tilburg University about Airbnb. As you might know in the early years of Airbnb's existence, the business was widely known as an affordable and friendly way to travel. The fact that it was a way for hosts to make some extra money and for travellers to find a bed for competitive prices turned the concept into a massive success. However, the growth of Airbnb comes with certain disadvantages. One of them is the rapid increasing cost of renting an accomodation trough Airbnb. Therefore we made an estimating tool that renters of Airbnb accomodations can use to become better informed about the average price for similar accomodations. 

This estimating tool will be made publicly available on a website. To come to estimation, the visitor of the website has to fill out all characteristcs of their respective accomodation. The tool then builds a linear regression based on these characteristics and shows as an output the average price.

The data used in the research is gathered through scraping the Airbnb website. The data will be used to build a tool that answers the question: *"What is the average price for an accomodation similar to the one that I am renting?"*. This tool will be based upon *linear regression* and includes variables that are retrieved from the available and scraped Airbnb data. The outcome variable will show the average price of an accomodation with characteristics that are used as input variables. These variables are based on characteristics regarding (1) ***demographics*** (e.g., city, neighbourhood, nearby facilities), (2) ***accomodation*** (e.g., rating, number of reviews, amenities etc.) and (3) ***host*** (e.g., number of accomodations owned by hosts). 

## Research method 

To collect the required data, a web-scraper was build that retrieves information on the data that isn't provided by Airbnb. For example Airbnb doesn't provide information about the different characteristics an Airbnb rental has (e.g., city, neighbourhood, nearby facilities). These characteristics will be used as explanatory variables for price and by using linear regressions, the significance and the size of the effect can be determined for a variety of circumstances.

## Relevance

This research question covers both hosts and tenants of Airbnb. This research will investigate whether hosts ask too much money for their Airbnb. It definitely is an important topic to investigate, because for hosts, it is very attractive to rent out their home via Airbnb, especially if the person lives in a popular city. For example, consider Amsterdam, it is a tourist attraction and hosts can charge a huge rent for an Airbnb. First, this research examines whether a hosts is allowed to charge the rent it does. Secondly, this research is very relevant because there is a correlation between the number of Airbnb's and the house price in the Netherlands. 
Again, taking Amsterdam into consideration, there the general house price is bizarrely high, according to a study by (Woudstra, 2018), this is partly due to the high number of Airbnb's, 20,000 in 2019. Landlords with a lot of money see an easy opportunity to make a lot of money.  As a result, fewer owner-occupied houses become available for the private individual and student houses for the student. The logical consequence is that prices rise exponentially. 
This study seeks to expose that landlords are charging way too much for their Airbnb with the hope that rents will fall, fewer Airbnb’s will become available, more buying homes, and at least house prices will not continue to rise.

## Repository overview

```
├── README.md
├── makefile
└── src
    ├── analysis
    ├── data-preparation
    ├── data-collection
    └── pricing-app
```

### Dependencies

Please follow the installation guide on http://tilburgsciencehub.com/.

- Python. [Installation guide](http://tilburgsciencehub.com/setup/python/).
- R. [Installation guide](http://tilburgsciencehub.com/setup/r/).
- Make. [Installation guide](http://tilburgsciencehub.com/setup/make).
- For the Python packages, check the source code lines starting with ```from ... import``` and ```import```.
- For the R packages, check the source code lines starting with ```library```.

### Running the code

Follow the instructions to run the code:
1. Fork this repository
2. Open your command line/terminal:

```
clone https://github.com/LucPeeters21/Airbnb-pricing.git
```
3. To directly all code use:

```
make
```
4. After these steps you are now able to run the pricing app in ../src/pricing-app -> pricing_app.R

Another option will be to run all code in the following order:
- ../src/data-preparation -> data_preparation.R
- ../src/analysis -> regression.R
- ../src/pricing-app -> pricing_app.R


## Authors

[Annabelle den Heijer](https://github.com/annabelledenh), [Mike Verweij](https://github.com/Mikeverweij96), [Sjors Boelaars](https://github.com/SjorsBoelaars1), [Bouke Schippers](https://github.com/BSchippers1), [Luc Peeters](https://github.com/LucPeeters21)
