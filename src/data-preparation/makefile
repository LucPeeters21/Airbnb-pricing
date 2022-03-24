## DATA PREPARATION WORKFLOW ##


all: ../../data/Airbnb_EU_listings_reduced.csv ../../data/Presencematrix_v2.csv 

../../data/Airbnb_EU_listings_reduced Presencematrix_v2.csv: AirBnb_data_preperation.R
	R --vanilla < AirBnb_data_preperation.R