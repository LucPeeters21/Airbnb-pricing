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



#Present the url to scrape:
Inside_airbnb_url= "http://insideairbnb.com/get-the-data.html"


#Set up selenium:
options = Options()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
driver = webdriver.Chrome(options=options)
driver.get(Inside_airbnb_url)

sleep(5) #Let the scraper sleep a few seconds to reduce the chance of getting blocked from the site
    
#load the page source and open it with beautiful soup:
res = driver.page_source
soup = BeautifulSoup(res, features="html.parser")

Cities_list=soup.find_all('tbody') #create a list of all cities (identified by 'tbody')

city_list=[] # create an empty list to later store the individual city download url's in
for city in Cities_list:
    URL_link = city.find("a") #open the first 'a' in each 'tbody', since thisis where the listings.csv.gz file is.
    city_list.append(URL_link.get('href')) #only append the 'href', which is the link of the csv.gz file.
   
    
(pd.DataFrame(city_list)).to_csv("Airbnb_listing_urls.csv", index=False, sep=';') #Finally save your data to a csv