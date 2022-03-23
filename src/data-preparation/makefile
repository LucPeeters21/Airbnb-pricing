DATA = ../../data
PREPARATION = ../../data-preparation

all: $(DATA)/Airbnb_EU_listings_reduced.csv $(DATA)/Presencematrix_v2.csv 

$(DATA)/Airbnb_EU_listings_reduced: $(PREPARATION)/AirBnb_data_preperation.R
	R --vanilla < $(PREPARATION)/AirBnb_data_preperation.R

$(DATA)/Presencematrix_v2.csv: $(PREPARATION)/AirBnb_data_preperation.R
	R --vanilla < $(PREPARATION)/AirBnb_data_preperation.R



HOE NU NAAR ANALYSIS VOOR UITVOEREN?