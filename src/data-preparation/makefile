DATA = ../../data
TEMP = ../../gen/temp

all: $(DATA)/Airbnb_EU_listings_reduced.csv 

../../data/Airbnb_EU_listings_reduced: download.R
	mkdir -p ../../data
	R --vanilla < download.R

