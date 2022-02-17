#Please note that you may want to run this script multiple times, especially in the following situations:
#1. If your scraper stopped inbetween because of a connection loss
#2. If you have a lot of missing value's for the amenities and you think it was caused due to bad connection.
#3. To update the information if it is a long time ago since you scraped for the last time. 

#First, import the needed packages:
from bs4 import BeautifulSoup
from time import sleep
import pandas as pd


#prepare selenium and chrome driver:
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


#Import the airbnb file
#airbnb_data = pd.read_csv('listings.csv') #Use this line if this is your first scrape of this data and you have not yet changed the name of the dataset to 'AirBNB_data_with_Amenities.csv' and made it ;-seperated.
airbnb_data = pd.read_csv('AirBNB_data_with_Amenities.csv', sep=';')

#Present the base url and the addition of the amentities pages on Airbnb here
airbnb_base_url= "https://www.airbnb.com/rooms/" 
airbnb_base_url_addition="/amenities" 


if 'Amenities' not in airbnb_data: #For your first run you want to add the extra column 'Amenities'. 
    airbnb_data['Amenities']=str(0)


#The amenities extracter that scrapes the amentities from the 'listing_url'. 
def extract_amenities(listing_url):
    waiting_time=10 #Let the scraper wait after every scrape to prevent getting blocked (note: 2 seconds seems to work too, but just to be sure we set it to 10 seconds for now)

    #Set up selenium:
    options = Options()
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    driver = webdriver.Chrome(options=options)
    driver.get(listing_url)
    
    sleep(waiting_time) #Let the scraper sleep for the set waiting time to prevent getting blocked from Airbnb.
    
    #get the source code of the webpage:
    res = driver.page_source
    soup = BeautifulSoup(res, features="html.parser")


    Amenities_list=soup.find_all('div', class_="_gw4xx4") #search for the amenties and save it in a list
    
    list_of_amenities=[] #create an empty list to later store the amenities of this listing. 
    teller=0 #this counts the number of the amenity that you are adding to the list of amenities.

    #extract only the relevant text from the amenties list (get rid of all the html coding):
    for i in range(len(Amenities_list)):
        
        Amenity=Amenities_list[teller].text
        if "Niet beschikbaar" in Amenity: #leave out the amenties that are not available (='Niet beschikbaar' in Dutch).
            break
        list_of_amenities.append(Amenity)
        teller+=1    
    driver.save_screenshot('test.png') #save a screenshot of the webpage to check in case something seems to have gone wrong / when a crash occured. 
    
    driver.quit() #quit the driver

    return list_of_amenities


count=0 #keep track of the number of listings you have scraped. 
for place in range(len(airbnb_data)):

    if airbnb_data.iloc[count]['Amenities']=='[]' or airbnb_data.iloc[count]['Amenities']=='0': #only scrape this listing if there is no information aviable of it yet (this applies to the times you have to run the scraper multiple times)
     
        url=airbnb_base_url+str(airbnb_data.iloc[count]['id'])+airbnb_base_url_addition
        print("Scraping page nr: "+ str(count+1) + ", with url: " + url) #to track what you are doing in the console window. 

        airbnb_data.at[count,'Amenities']=extract_amenities(url)
        print("We found the following nr of Amenities: " + str(len(airbnb_data.iloc[count]['Amenities'])))
        count+=1
    
        if (count/10).is_integer(): #save every 10th run to prevent data loss in case of scraper crashes due to connection problems
            airbnb_data.to_csv("AirBNB_data_with_Amenities.csv", index=False, sep=';')
            sleep(20) #to prevent getting blocked at a longer sleep after every 10th run
    else:
        print("This is already of length "+ str(len(airbnb_data.iloc[count]['Amenities'])))
        count+=1

airbnb_data.to_csv("AirBNB_data_with_Amenities.csv", index=False, sep=';') #Finally save your data