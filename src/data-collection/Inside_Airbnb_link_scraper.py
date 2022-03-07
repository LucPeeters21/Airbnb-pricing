#This simple webscraper is written to extract all 'listings.csv.gz' download links from InsideAirbnb at once.
#The different download links are safed into a csv that can serve as the basis to download all data at once in R.


#First, import the needed packages:
from bs4 import BeautifulSoup
from time import sleep
import pandas as pd


#secondly, prepare selenium and chrome driver:
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
chrome_options = Options()
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--headless')
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("--window-size=1980,1030")
chrome_options.add_argument("start-maximised")
chrome_options.add_argument("--disable-gpu")
driver = webdriver.Chrome(options=chrome_options)
driver.get('https://www.google.com/')


#Then, present the url to scrape:
Inside_airbnb_url= "http://insideairbnb.com/get-the-data.html"


#Next, set up selenium to navigate to the Inside Airbnb URL:
options = Options()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
driver = webdriver.Chrome(options=options)
driver.get(Inside_airbnb_url)
sleep(5) #Let the scraper sleep a few seconds to reduce the chance of getting blocked from the site

    
#Then, load the page source and open it with beautiful soup:
res = driver.page_source #load the page source
soup = BeautifulSoup(res, features="html.parser") #open the page source with Beautiful soup
cities_list=soup.find_all('tbody') #create a list of all cities (identified by 'tbody')
identifier_list=soup.find_all('h3') #Create a list that gives the identifier of the city, which is the city, province/state and country


#After that, loop through all cities in the cities_list and store the information that we want in the city_data:
city_data=[] # create an empty list to later store the individual city data in
for city in range(len(cities_list)):
    URL_link = cities_list[city].find("a").get('href') #open the first 'a' in each 'tbody', since thisis where the listings.csv.gz file is, and only extract the 'href', which is the link of the csv.gz file.
    identifier = identifier_list[city].text #Get the identifier that corresponds to this city (i.e. the city, state/province, country variable)
    country = identifier.split(",",3)[-1] #save the country, which is always the last part of the identifier that seperates city, state/province and country by comma's.
    city = identifier.split(",",3)[0] #save the city, which is always the first part of the identifier that seperates city, state/province and country by comma's.
    
    
    #store the city, country and URL link in a temporary dictionary:
    city_info = {"Country": country, "City": city ,"Link": URL_link}
    
    
    #append the temporary dictionary with the city, country and URL link to the list of all cities:
    city_data.append(city_info) 


#Finally save your data to a csv: 
(pd.DataFrame(city_data)).to_csv("Airbnb_listing_urls.csv", index=False, sep=';') 
print(city_data)