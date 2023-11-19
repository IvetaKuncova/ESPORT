# From https://www.esportsearnings.com/ scrapes Date of Birth of individual players
## Most of the players have not Date of Birth filled.
# You need file with all the links, similar to my sample file "links_todo.csv"

# load modules
import requests
import csv
import time
from bs4 import BeautifulSoup
# for session creation and treatment of http status codes
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

## VARIABLES TO CHANGE:
input_file_name_links_todo = "links_todo.csv"
output_file_name_DatesOfBirth = "DatesOfBirth.csv"

# creating a session to handle HTTP exceptions
# If the API returns a code 502 (bad gateway) or 429 (too many requests) instead of the data, 
# the "retry" tries to query the same data again with increasing delay (backoff_factor)
session = requests.Session()
retry = Retry(
    total=5,
    backoff_factor=0.5,
    status_forcelist=(429, 500, 502, 504))
adapter = HTTPAdapter(max_retries=retry)
session.mount("http://", adapter)
session.mount("https://", adapter)

## get links to scrape from file
links_todo = []
with open(f"{input_file_name_links_todo}", mode="r", encoding="utf-8") as fr:
    for rows in fr:
        rows1 = rows.strip()
        rows3 = rows1.split(',', 2)
        collumn = rows3[0].strip('"')
        if collumn != 'Url':
            links_todo.append(collumn)

print(f"Number of links to process: {len(links_todo)}")

dob_list = []
def get_DateOfBirth(url):
    time.sleep(1.0)

    response = session.get(url)
    # on the terminal I can see which address I am currently at for quick orientation, how far I am in the request, in pink
    print(f"\u001b[35m{url}-{i}\u001b[0m")
    
    if response.status_code != 200:
        print(f"\u001b[31;1mError: HTTP {response.status_code}\u001b[0m") 
        data = [{"Error": f"HTTP {response.status_code}", "Url": url}]

    elif not response.text:
        data = [{"Error": "Empty response", "Url": url}]      
          
    else:
        try:
            # Create BeautifulSoup object
            soup = BeautifulSoup(response.text, 'html.parser')

            # Find the element containing the date of birth
            dob_element = soup.find('div', string='Date of Birth:')

            # Pull the date of birth from the following element
            dob = dob_element.find_next_sibling('div').text
            dictionary = {}
            dictionary["Url"]= url
            dictionary["DateOfBirth"] = dob
            data = dictionary
        except:
            print(f"\u001b[31;1mError: Invalid response: {url}\u001b[0m")
            print(response.status_code)
            print(response.text)
            data = [{"Error": "Invalid response", "Url": url}]
   
    # Save the date of birth in the list
    dob_list.append(data)
    return dob_list

# saving data to a file
try: 
    with open(f"{output_file_name_DatesOfBirth}", "w", encoding="utf-8", newline='') as fw:
        first_row = True
        for i in range(0,len(links_todo)):
            url = links_todo[i]    
            DataA = get_DateOfBirth(url)
            if not DataA:
                continue
            for listA in DataA:
                if first_row:
                    first_row = False
                    headers = ["Url", "DateOfBirth", "Error"]
                    writer = csv.DictWriter(fw, fieldnames=headers)
                    writer.writeheader()       
            writer.writerow(listA)        
# the code will be executed even if the user interrupts its execution (which sometimes takes hours):
except KeyboardInterrupt:
    print("Interrupted by user")     

print(f"\u001b[33mThe name of the output file is: {output_file_name_DatesOfBirth}\u001b[0m") # yellow