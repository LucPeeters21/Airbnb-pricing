## DATA PREPARATION WORKFLOW ##

DATA = ../../data

all: $(DATA)/eu_listings.csv $(DATA)/presencematrix.csv 

$(DATA)/eu_listings.csv $(DATA)/presencematrix.csv: data_preparation.R
	R --vanilla < data_preparation.R