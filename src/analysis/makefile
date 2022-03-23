DATA = ../../data
TEMP = ../../gen/temp
ANALYSIS = ../../src/analysis

all: $(TEMP)/

$(TEMP)/: $(ANALYSIS)/Airbnb_regression.R $(DATA)/Airbnb_EU_listings_reduced $(DATA)/Presencematrix_v2.csv
    R --vanilla < $(ANALYSIS)/Airbnb_regression.R



WELKE FILES? NAAM OUTPUT NA "$(TEMP)/"  ZETTEN