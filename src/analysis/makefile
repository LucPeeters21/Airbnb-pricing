## ANALYSIS WORKFLOW ##

DATA = ../../data


all: $(DATA)/regression_output_with_reviews.csv $(DATA)/regression_output_without_reviews.csv

$(DATA)/regression_output_with_reviews.csv $(DATA)/regression_output_without_reviews.csv: regression.R
    R --vanilla < regression.R
