DATA = ../../data
TEMP = ../../gen/temp

all: $(DATA)/Airbnb_EU_listings_reduced

../../data/Airbnb_EU_listings_reduced: download.R
	mkdir -p ../../data
	R --vanilla < download.R