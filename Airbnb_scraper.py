#First, import the needed packages:
from bs4 import BeautifulSoup
from time import sleep
import csv
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
#airbnb_data = pd.read_csv('listings.csv')
airbnb_data = pd.read_csv('AirBNB_data_with_Amenities.csv', sep=';')

#Give the url's of the goodreads homepage and the link to the members page of the group we want to scrape:
airbnb_base_url= "https://www.airbnb.com/rooms/" 
airbnb_base_url_addition="/amenities" 
#airbnb_base_url_addition=""
#https://www.airbnb.com/rooms/20168/amenities?source_impression_id=p3_1645023764_EH53xWRUHu09ldcl

#airbnb_base_url_addition=""

if 'Amenities' not in airbnb_data:
    airbnb_data['Amenities']=str(0)



def extract_amenities(listing_url):
    waiting_time=[2, 1]
    """Extracts HTML from JS pages: open, wait, click, wait, extract"""

    options = Options()
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    driver = webdriver.Chrome(options=options)

    driver.get(listing_url)
    sleep(waiting_time[0])
    
    
    res = driver.page_source
    soup = BeautifulSoup(res, features="html.parser")
    teller=0
    list_of_amenities=[]
    Amenities_list=soup.find_all('div', class_="_gw4xx4")
    
    
    for i in range(len(Amenities_list)):
        
        Amenity=Amenities_list[teller].text
        if "Niet beschikbaar" in Amenity:
            break
        list_of_amenities.append(Amenity)
        teller+=1    
    driver.save_screenshot('test.png')
    
    driver.quit()

    return list_of_amenities



#airbnb_data['Amenities']=str(0)

count=0
for place in range(len(airbnb_data)):
    #print(airbnb_data.iloc[count]['Amenities'])
    if airbnb_data.iloc[count]['Amenities']=='[]' or airbnb_data.iloc[count]['Amenities']=='0':
     
        url=airbnb_base_url+str(airbnb_data.iloc[count]['id'])+airbnb_base_url_addition
        print("Scraping page nr: "+ str(count+1) + ", with url: " + url)

        airbnb_data.at[count,'Amenities']=extract_amenities(url)
        print("We found the following nr of Amenities: " + str(len(airbnb_data.iloc[count]['Amenities'])))
        count+=1
    
        if (count/10).is_integer(): #save every 10th run
            airbnb_data.to_csv("AirBNB_data_with_Amenities.csv", index=False, sep=';')
    else:
        print("This is already of length "+ str(len(airbnb_data.iloc[count]['Amenities'])))
        count+=1

airbnb_data.to_csv("AirBNB_data_with_Amenities.csv", index=False, sep=';')