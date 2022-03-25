# Data Collection

Data was retrieved from Inside Airbnb, with additional data collected by scraping amenitities of the accomodations that were listed on the Inside Airbnb datafile. The result consisted of two seperate datafiles. The datafile retrieved from Inside Airbnb consisted of 31 variables that were further used in the preparation and analysis of the data. The 'amenities' variable is represented in this datafile as a list, but in the scraped datafile each amenity is represented as a seperate variable. The table shows each variable and description of the datafile as retrieved from Airbnb.

| Variable                       | Description                                |
| -------------------------------| -------------------------------------------|
|id                              |Unique identifier of listing                |
|host_since                      |Date the host was created                   |
|host_response_time              |Time after which a host responds            |
|host_response_rate              |Rate at which a host responds               |
|host_is_superhost               |Whether host is superhost                   |
|host_listings_count             |Number of listings a host has               |
|host_identity_verified          |Whether identity of host is known           |
|neighbourhood                   |Neighbourhood of the listing                |
|neighbourhood_cleansed          |Detailer neighbourhood of listing           |
|property_type                   |Self described type of property             |
|room_type                       |Self described type of room                 |
|accommodates                    |Maximum capacity of listing                 |
|bathrooms_text                  |Number of bathrooms                         |
|bedrooms                        |Number of bedrooms                          |
|beds                            |Number of beds                              |
|amenities                       |Additional specifications of listing,       |
|price                           |Daily price in local currency               |
|minimum_nights                  |Minimum nights a guest can stay             |
|maximum_nights                  |Maximum nights a guest can stay             |
|number_of_reviews               |Total amount of reviews a listing has       |
|review_scores_rating            |General review score of property            |
|review_scores_accuracy          |Review score for accuracy of property       |
|review_scores_cleanliness       |Review score for cleanliness of property    |
|review_scores_checkin           |Review score of the check-in at property    |
|review_scores_communication     |Review score of the communication by host   |
|review_scores_location          |Review score of the property location       |
|review_scores_value             |Review score of value of property           |
|reviews_per_month               |Amount of reviews a listing has per month   |
|city                            |City that a listing is situated             |
|country                         |Country in which a listing is situated      |
