/* This part of the project was a teamwork. There were so many distinct locations (ca 3000), 
which we had to go through manually, it has to be done in cooperation. 
*/

CREATE OR REPLACE TABLE API07_TOURNAMENT_LOCATIONS AS
SELECT *, "Location" as UPDATED_LOCATION FROM API07_TOURNAMENT_UNIONED;

-- Update locations - change all ";" to ",". It has made trouble while updating some rows - they did not update even though the text was in '' or with %.
UPDATE API07_TOURNAMENT_LOCATIONS
SET "Location" = REPLACE("Location", ';', ',');

-- troubled locations (not a country or city)
UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = null
-- locations with more than one country were considered online
WHERE (UPDATED_LOCATION ILIKE ANY 
        (
        ' West Europe', 
        '%n/a%',
        '%none%',
        '%online%',
        '-', 
        '?',
        'Africa',
        'AMERICAS',
        'Asia - Pacific', 
        'Asia',
        'Asia, Australia',
        'Asia, Middle East',  
        'Asia/Oceania', 
        'Asia-Pacific',
        'Benelux', 
        'Berlin (Play-In and Groups); Madrid (Quarterfinals and Semifinals); Paris (Final)',
        'Berlin, Germany / Copenhagen, Denmark',
        'Berlin, Germany / Krakow, Poland', 
        'Berlin, Germany / Madrid, Spain',
        'Berlin, Germany / Paris, France',
        'Berlin, Germany / Paris, France', 
        'Berlin, Germany / Rotterdam, Netherlands',
        'Berlin, Germany / Stockholm, Sweden',
        'Buenos Aires, Argentinia / Santiago, Chile',
        'Central America', 
        'Cis - Asia', 
        'CIS, Asia', 
        'Cologne, Germany / Burbank, USA / Katowice, Poland',
        'Cologne, Germany / Los Angeles, USA', 
        'Dojo', 
        'East Asia', 
        'East Asia, Southeast Asia', 
        'Eu - NA - Asia', 
        'EU',
        'EUROPE', 
        'Europe, Middle East',
        'Europe, Middle East, Africa',
        'Europe/Americas/OCE',
        'Europe/NA',
        'FACEIT',
        'Germany, Austria, Switzerland',
        'Guangzhou China, Tokyo Japan',
        'Hanoi, Vietnam / Taipei, Taiwan',
        'Hanoi, Vietnam; Heidelberg, Germany', 
        'Hat Factory', 
        'Hong Kong and Taiwan', 
        'Hong Kong, Taiwan', 
        'Chile (Season), Columbia (Playoffs)', 
        'China & Vietnam', 
        'China, Japan', 
        'China, Korea', 
        'China, South Korea, Thailand, Vietnam', 
        'Iberia',
        'India, Bangladesh, Sri Lanka', 
        'India, Pakistan, Nepal', 
        'Indonesia, Malaysia, Singapore, Philippines', 
        'Indonesia, Philippines',
        'Japan & South Korea', 
        'Japan, North America',
        'Japan, North America, Europe', 
        'Japan, South Korea', 
        'Kuala Lumpur, Jakarta',
        'Laos, Thailand, Vietnam',
        'Latin America North', 
        'Latin America South', 
        'Latin America', 
        'Levant and North Africa',
        'Levant,North Africa', 
        'London, UK / Istanbul, Turkiye',
        'Los Angeles, CA, USA / Toronto, Canada',
        'Los Angeles, CA, USA / Vancouver, Canada',
        'Malaysia & Singapore', 
        'Malaysia, Cambodia, Philippines',
        'Malaysia, Cambodia, Philippines, Sri Lanka',
        'Malaysia, Singapore', 
        'Malaysia, Singapore, Philippines', 
        'Malaysia, Singapore, Philippines, Sri Lanka', 
        'Malaysia/Singapore', 
        'Mexico City/Chile Santiago de Mexico, Chile',
        'Middle East', 
        'Middle East, Africa', 
        'Middle-East', 
        'Montpellier, France / Berlin, Germany',
        'No answer', 
        'Nordic',
        'North Africa', 
        'North America', 
        'North America, Europe', 
        'North America, Europe, Australia',
        'North America, Europe, Oceania', 
        'North America, Europe, South America', 
        'North America, South America',
        'North Amerika', 
        'North Macedonia', 
        'Northeast Asia', 
        'Oceania', 
        'Oceanic, Europe, Americas',
        'offline Finals', 
        'offline', 
        'offline, North America', 
        'Offline','Pacific',
        'Offline/Online (Busan)',
        'on-site in Toronto, Canada / Belgrade, Serbia',
        'Pakistan-China Friendship Center, Islamabad, Pakistan', 
        '%Paris, France (Group Stage), London, UK (Quarterfinals), Brussels, Belgium (Semifinals), Berlin, Germany (Final)%',
        '%Paris, France % London, UK % Brussels, Belgium % Berlin, Germany%',
        'Philippines, Cambodia, Myanmar, Singapore',
        'Rotterdam, NL (Playoffs) / Berlin, Germany', 
        'San Francisco, Atlanta, New York, Mexico City',
        'Santiago, Chile / Lima, Peru', 
        'Seoul, South Korea / Beijing, China', 
        'Seoul, South Korea / Las Vegas, Nevada, USA', 
        'Seoul, South Korea / Shanghai, China', 
        'Shenzhen, China, Seoul, South Korea', 
        'Singapore, Malaysia', 
        'South America',
        'South Asia', 
        'South Asia, Asia-Pacific', 
        'South Asia, Mongolia, Pakistan',
        'South East Asia', 
        'South Korea, Japan',
        'Southeast Asia - South Asia - Oceania', 
        'Southeast Asia', 
        'Southeast Asia, Oceania South, Asia',
        'Southeast Asia, Oceania', 
        'Southeast Asia, Oceania, South Asia', 
        'Southeast Asia, South Asia, Oceania', 
        'Southeast Asia, Taiwan, Hong Kong', 
        'Southeast Asia, Taiwan, Hong Kong, Oceania', 
        'Spain, Portugal',
        '%Taipei and Singapore (Group Stage), Busan, South Korea (Quarterfinals), Seoul, South Korea (Semi finals and Finals)%',
        '%Taipei and Singapore %, Busan, South Korea %, Seoul, South Korea%',
        'Taiwan, Hong Kong', 
        'Taiwan, Hong Kong, Southeast Asia',
        'Taiwan, Hongkong, Macau', 
        'Taiwan/Hong Kong', 
        'United Arab Emirates, Maldives, Online',
        'United Kingdom, Ireland',
        'United Kingdom, Nordic Countries, Ireland',
        'unknown',
        'Vietnam & China',
        'Vietnam, China', 
        'West Africa',
        'West Europe',
        'Athens, Greece (Playoffs) / Berlin, Germany',
        'ESL',
        'Global',
        'International',
        'Latin America Servers',
        'Latin American Servers',
        'Levant, North Africa',
        'NA/EU',
        'Remote',
        'SEA',
        'Servers',
        'W3Arena',
        'World',
        'Worlds',
        'Worldwide',
        'challengermode.com',
        'heat.net',
        'https%',
        'kloudchasers@twitch.tv',
        'youtube',
        'America',
        'GFLClan.com',
        'NetEase',
        'Nort',
        'North Amerika',
        'Salón del Calvo de Brazzers',
        '%NA East%', 
        '%NA West%',
        'Berlin, Malmö',
        'Bangkok (Thailand) / Ho Chi Minh City (Vietnam)',
        'Thailand, Vietnam',
        'Hi-Rez Studios',
        'CIS',
        'NA',
        'EUMENA',
        'Europe, Middle East, Africa, CIS',
        'Europe, Middle East, CIS, Africa'
        )
    OR UPDATED_LOCATION LIKE ANY 
        ('AMERICA',
        '%EMEA%'
        ))
-- locations with 'online/offline' and country or city are considered "offline"
AND UPDATED_LOCATION NOT IN (
    'Offline/Online (Busan)',
    'Online / Offline (Germany)', 
    'Online / Offline final: Lisbon, Portugal',
    'online / offline Finals (Italy)',
    'Online / Offline: Bandung',
    'Online / Offline: Birmingham, England, UK',
    'Online / Offline: Helsinki, Finland',
    'Online / Offline: Istanbul, Turkey',
    'Online / Offline: Lisbon, Portugal',
    'Online / Offline: Melbourne, Victoria, AUS',
    'Online / Offline: Moscow, Russia',
    'Online / Offline: Oryol, Russia',
    'Online / Offline: Santiago, Chile',
    'Online / Offline: Ulaanbaatar, Mongolia',
    'Online / Offline: Vitoria, Euskadi, Spain',
    'Online / Offline: Warsaw, Poland',
    'online/offline (Australia)',
    'Online/Offline (Hong Kong)',
    'online/offline (China)',
    'Online/Offline (Indonesia)', 
    'Online/Offline (Italy)',
    'Online/Offline (Kiev)',
    'Online/Offline (Philippines)', 
    'Online/Offline (Sao Paolo, Brazil)',
    'Online/Offline (Seoul)',
    'Online/Offline (Taiwan)',
    'Online/Offline (Turkey)', 
    'Online/Offline finals Italy', 
    'Online/Offline Sofia, Bulgaria',
    'Online/Offline, São Paulo',
    'Online/Offline: Düsseldorf, NRW, Germany',
    'Online/Offline: Singapore',
    'Europe, CIS, Turkey',
    'Europe, Turkey, CIS'
    )
;

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Azerbaijan'
WHERE UPDATED_LOCATION ILIKE '%Azerbaijan%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Argentina'
WHERE UPDATED_LOCATION ILIKE ANY ('%Argentina%', 'Argentinia', '%Buenos Aires%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Albania'
WHERE UPDATED_LOCATION ILIKE '%Albania%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Armenia'
WHERE UPDATED_LOCATION ILIKE '%Armenia%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Australia'
WHERE (UPDATED_LOCATION ILIKE ANY ('%Australia%', '%Sydney%', '%Victoria%', '%Brisbane%', '%Melbourne%', 'Bentley')
 OR UPDATED_LOCATION = 'Adelaide')
 AND UPDATED_LOCATION NOT IN ('Ciudad de Victoria, Philippines', 'Royal Victoria Dock, 1 Western Gateway, Royal Docks, London E16 1XL, UK');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Austria'
WHERE UPDATED_LOCATION ILIKE ANY ('%Austria%', '%Wien%', '%Vienna%', '%St. Pölten%') ;

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Bangladesh'
WHERE UPDATED_LOCATION ILIKE '%Bangladesh%' ;

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Bahamas'
WHERE UPDATED_LOCATION ILIKE '%Bahamas%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Bahrain'
WHERE UPDATED_LOCATION ILIKE ANY ('%Bahrain%', '%Riffa, Barhain%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Belarus'
WHERE UPDATED_LOCATION ILIKE '%Belarus%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Belgium'
WHERE UPDATED_LOCATION ILIKE ANY ('%Belgium%', '%Brussel%', '%Charleroi%', '%Ghent%', '%Mechelen%', '%Schaerbeek%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Bosnia and Herzegovina'
WHERE UPDATED_LOCATION ILIKE '%Bosnia%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Brazil'
WHERE UPDATED_LOCATION ILIKE ANY ('%Brazil%', '%Bras%', '%Paulo%', '%Curitiba%', '%Niteroi%', '%Sao Paolo%')
AND UPDATED_LOCATION != 'Bellevue, Nebraska, USA';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Brunei Darussalam'
WHERE UPDATED_LOCATION ILIKE '%Brunei%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Bulgaria'
WHERE UPDATED_LOCATION ILIKE '%Bulgaria%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Cambodia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Cambodia%', '%Phnom Penh%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Canada'
WHERE UPDATED_LOCATION ILIKE ANY ('%Canada%', '%Alberta%', '%Toronto%', '%Montreal%', '%Montréal%', 
'%Vancouver%', '%BC%', '%Ontario%', '%QC%', '%Oakville%', '%Quebec%', '%Mississauga%', '%Ottawa%', '%Québec%')
AND UPDATED_LOCATION NOT IN ('Richmond, BC', 'Ontario, CA, USA', 'Ontario, California', 'Ontario, California, US', 'Ontario, California, USA');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Colombia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Colombia%', '%Bogotá%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Costa Rica'
WHERE UPDATED_LOCATION ILIKE '%Costa Rica%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Croatia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Croatia%', '%Osijek%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Czechia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Czech%', '%Prague%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Denmark'
WHERE UPDATED_LOCATION ILIKE ANY ('%Denmark%', '%Danemark%', '%Copenhagen%', '%Fredericia%') ;

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Dominican Republic'
WHERE UPDATED_LOCATION ILIKE ANY ('%Dominican Republic%', '%Domingo%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Ecuador'
WHERE UPDATED_LOCATION ILIKE '%Ecuador%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Egypt'
WHERE UPDATED_LOCATION ILIKE ANY ('%Egypt%', '%Cairo%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Estonia'
WHERE UPDATED_LOCATION ILIKE '%Estonia%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Faroe Islands'
WHERE UPDATED_LOCATION ILIKE '%Faroe Islands%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Finland'
WHERE UPDATED_LOCATION ILIKE ANY ('%Finland%', '%Helsinki%', '%Finalnd%', '%Turku%', '%Tempere%', '%Tampere%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'France'
WHERE (UPDATED_LOCATION ILIKE ANY ('%France%', 'Aubervilliers', 'Cappelle la Grande', '%Chartres%', '%Tours%', '%Brest%', '%Gardanne%', '%La Rochelle%',
 '%Le Kremlin-Bicetre%', '%Perpi%', '%Pari%', '%Lille', '%Lyon%', '%Marseille%',  '%Montpellier%', '%Nantes%', '%Noisy%', '%Versailles%', '%Poitiers%', '%Rennes%', '%Royan%') 
 OR UPDATED_LOCATION LIKE '%FRA%')
 AND UPDATED_LOCATION NOT LIKE '%s/Paris Las Vegas,  Las Vegas, NV'; 

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Georgia'
WHERE UPDATED_LOCATION = 'Tbilisi, Georgia';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Germany'
WHERE UPDATED_LOCATION ILIKE ANY ('%Germany%', 'Aachen', '%Berlin%', '%Cologne%', '%Essen%', '%Frankfurt%', '%Hamburg%', '%Zorneding%', '%Krefeld%', 
'%Deutschland%', '%Leipzig%', '%Munich%', '%Osnabrück%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Ghana'
WHERE UPDATED_LOCATION ILIKE '%Ghana%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Greece'
WHERE UPDATED_LOCATION ILIKE ANY ('%Greece%', '%Ilion, Athens%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Honduras'
WHERE UPDATED_LOCATION ILIKE '%Honduras%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Hong Kong'
WHERE  UPDATED_LOCATION ILIKE ANY ('%Mong Kok%', '%Hong Kong%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Hungary'
WHERE UPDATED_LOCATION ILIKE ANY ('%Hungary%', '%Budapest%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Chile'
WHERE UPDATED_LOCATION ILIKE ANY ('%Chile%', '%Caldera%');
 
UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'China'
WHERE UPDATED_LOCATION ILIKE ANY ('%China%', '%Beijing%', '%Changsha%', '%Changzhou%', '%Shenzhen%', '%Xian%','%Xiamen%', '%Suzhou%', '%Chine%',  '%Hangzhou%',
 '%Shandong%', '%Maca%', '%Wuhan%', '%Shanghai%', 'Xi%')
 AND UPDATED_LOCATION != 'Pak-China Friendship Center, Islamabad, Pakistan';  
 
UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Iceland'
WHERE UPDATED_LOCATION ILIKE '%Iceland%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'India'
WHERE UPDATED_LOCATION ILIKE ANY ('%India',  '%Hyderabad%', 'South Asia, Chennai');
-- here must not be a second percentage at India -> Indiana - USA

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Indonesia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Indonesia%', '%Jakarta%', '%Bandung%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Iran'
WHERE UPDATED_LOCATION ILIKE '%Iran%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Iraq'
WHERE UPDATED_LOCATION ILIKE '%Iraq%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Ireland'
WHERE UPDATED_LOCATION ILIKE ANY ('%Ireland%', '%Cork%', '%Dublin%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Israel'
WHERE UPDATED_LOCATION ILIKE ANY ('%Israel%', '%Tel Aviv%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Italy'
WHERE UPDATED_LOCATION ILIKE ANY ('%Italy%', 'Adria', '%Bologna%', '%Spezia%', '%Milan%', 'Napol%', '%Rimini%', '%Rome%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Japan'
WHERE UPDATED_LOCATION ILIKE ANY ('%Japan%', '%Chiba%', '%Tokyo%', '%Okinawa%', '%Saitama%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Kazakhstan'
WHERE UPDATED_LOCATION ILIKE ANY ('%Kazakhstan%', '%Almaty%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'South Korea'
WHERE UPDATED_LOCATION ILIKE ANY ('%South Korea%', 'Seoul, Korea', 'Busan, Korea', 'offline, Korea', 'Korea', '???, Korea', 'Incheon, Korea', 'Ulsan, Korea',
'Offline, Korea', 'Goyang, Korea', 'Seongnam, Korea', '%Seoul%', '%Busan%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Kosovo'
WHERE UPDATED_LOCATION ILIKE '%Kosovo%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Kuwait'
WHERE UPDATED_LOCATION ILIKE '%Kuwait%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Kyrgyzstan'
WHERE UPDATED_LOCATION ILIKE '%Kyrgyzstan%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Lao Peoples Democratic Republic'
WHERE UPDATED_LOCATION ILIKE '%Laos%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Latvia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Latvia%', '%Lativa%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Lebanon'
WHERE UPDATED_LOCATION ILIKE '%Lebanon%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Lithuania'
WHERE UPDATED_LOCATION ILIKE ANY ('%Lithuania%', '%Kaunas%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Luxembourg'
WHERE UPDATED_LOCATION ILIKE '%Luxembourg%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Macao'
WHERE UPDATED_LOCATION ILIKE ANY ('%Macao%', 'Macau%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Malaysia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Malaysia%', '%Subang%', '%Kuala%', '%Petaling%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Malta'
WHERE UPDATED_LOCATION ILIKE '%Malta%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Mexico'
WHERE UPDATED_LOCATION ILIKE '%Mexico%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Moldova'
WHERE UPDATED_LOCATION ILIKE '%Moldova%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Monaco'
WHERE UPDATED_LOCATION ILIKE '%Monaco%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Mongolia'
WHERE UPDATED_LOCATION ILIKE '%Mongolia%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Montenegro'
WHERE UPDATED_LOCATION ILIKE '%Montenegro%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Morocco'
WHERE UPDATED_LOCATION ILIKE '%Morocco%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Myanmar'
WHERE UPDATED_LOCATION ILIKE ANY ('%Myanmar%', '%Yangon%'); 

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Netherlands'
WHERE UPDATED_LOCATION ILIKE ANY ('%Netherlands%', '%Netherland%', '%Alphen aan den Rijn%', '%Utrecht%', '%Tilburg%', '%Amsterdam%', '%Arnhem%', 'Assen', '%, NL%', 
'%Holland%', '%Maastricht%', '%Rotterdam%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'New Zealand'
WHERE UPDATED_LOCATION ILIKE ANY ('%New Zealand%', 'ANZ', '%Christchurch%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'North Macedonia'
WHERE UPDATED_LOCATION ILIKE '%Macedonia%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'North Macedonia'
WHERE UPDATED_LOCATION ILIKE '%Macedonia%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Norway'
WHERE UPDATED_LOCATION ILIKE ANY ('%Norway%', '%Lillestrom%', '%Oslo%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Pakistan'
WHERE UPDATED_LOCATION ILIKE ANY ('%Pakistan%', '%Islamabad%', '%Karachi%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Panama'
WHERE UPDATED_LOCATION ILIKE '%Panam%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Paraguay'
WHERE UPDATED_LOCATION ILIKE '%Paraguay%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Peru'
WHERE UPDATED_LOCATION ILIKE ANY ('%Peru%', '%Lima%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Philippines'
WHERE UPDATED_LOCATION LIKE ANY ('%Manila%', '%Philippines%', '%Phillipines%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Poland'
WHERE UPDATED_LOCATION ILIKE ANY ('%Poland%', '%Katowice%', '%Gdańsk%', '%Warsaw%', '%Kraków%', '%Nadarzyn%', '%Next One Cup%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Portugal'
WHERE UPDATED_LOCATION ILIKE ANY ('%Portugal%', '%Lisbon%', '%Porto%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Puerto Rico'
WHERE UPDATED_LOCATION ILIKE '%Puerto Rico%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Qatar'
WHERE UPDATED_LOCATION ILIKE '%Qatar%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Romania'
WHERE UPDATED_LOCATION ILIKE ANY ('%Romania%', '%Bucharest%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Russian Federation'
WHERE UPDATED_LOCATION ILIKE ANY ('%Russia%', '%Belgorod%', '%Ufa%', '%Moscow%')
AND UPDATED_LOCATION NOT ILIKE '%King of Prussia%'; 

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Saudi Arabia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Saudi Arabia%', 'Al Khobar', '%Riyadh%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Serbia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Serbia%', '%Belgrade%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Singapore'
WHERE UPDATED_LOCATION ILIKE ANY ('%Singapore%', '%Singpore%', '%Singapore');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Slovakia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Slovakia%', '%Bratislava%', '%Slowakia%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Slovenia'
WHERE UPDATED_LOCATION ILIKE ANY ('%Slovenia%', '%Ljubljana%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'South Africa'
WHERE UPDATED_LOCATION ILIKE ANY ('%South Africa%', '%Pretoria%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Spain'
WHERE UPDATED_LOCATION ILIKE ANY ('%Spain%', 'A Coruña', '%Madrid%', '%Barcelona%', '%Daganzo de Arriba%', '%Valencia%', '%Malaga%', '%Mérida%', '%Pontevedra%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Sri Lanka'
WHERE UPDATED_LOCATION ILIKE '%Sri Lanka%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Sweden'
WHERE UPDATED_LOCATION ILIKE ANY ('%Sweden%', '%Jönköping%', '%Stockholm%', '%Gothenburg%', '%Lidköping%', '%Malmö%')
AND UPDATED_LOCATION != 'Jönköping, USA';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Switzerland'
WHERE UPDATED_LOCATION ILIKE ANy ('%Switzerland%', 'Bern', '%Bienne%', '%Zürich%', '%Zurich%', '%Winterthur%', '%Wangen%', '%Fribourg%', '%Swiss%', '%Swizerland%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Taiwan'
WHERE UPDATED_LOCATION ILIKE ANY ('%Taiwan%', '%Taipei%', '%Tapei%', '%Kaohsiung%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Thailand'
WHERE UPDATED_LOCATION ILIKE ANY ('%Thailand%', '%Bangkok%', '%Chiang Mai%', '%Rangsit%', 'Thai', '%Suphanburi%', '%Nonthaburi%', '%Rayong%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Tunisia'
WHERE UPDATED_LOCATION ILIKE '%Tunisia%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Turkiye'
WHERE UPDATED_LOCATION ILIKE '%Turkey%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Ukraine'
WHERE UPDATED_LOCATION ILIKE ANY ('%Ukraine%', '%Kyiv%', '%Kiev%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'United Arab Emirates'
WHERE UPDATED_LOCATION ILIKE ANy ('%Emirates%', '%Dubai%', '%UAE%', '%Abu Dhabi%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'United States of America'
WHERE (UPDATED_LOCATION ILIKE ANY (
    '%Alabama%',
    '%Anaheim%', 
    '%Arizona%', 
    '%Arkansas%',
    '%Arlington%', 
    '%Atlanta%', 
    '%Atlantic City%', 
    '%Austin%',
    '%Baltimore%',
    '%Bangor%',
    '%Beach%',
    '%Bellflower%',
    '%Black Box - Table Arts Center%',
    '%Boston%',
    '%Burbank%',
    '%California%', 
    '%Carolina%',
    '%Cincinnati%',
    '%City of Industry%',
    '%Colorado%',
    '%Columbus%',
    '%Connecticut%',
    '%Dallas%',
    '%Davenport%',
    '%Daytona Beach%',
    '%Denver%',
    '%Detroit%',
    '%Elk Grove, CA%',
    '%Elmhurst%',
    '%Florida%',
    '%Fort Lee%',
    '%Fresno%',
    '%Gainesville%',
    '%Georgia%', 
    '%Hawaii%',
    '%Hi-Rez Studios%',
    '%Hollywood%',
    '%Houston%',
    '%Huntington Beach%',
    '%Champlain College%',
    '%Chantilly%',
    '%Cherry Hill%',
    '%Chicago%', 
    '%Illinois%',
    '%Indiana%',
    '%Kansas%',
    '%Kay Bailey%',
    '%Kentucky%',
    '%King of Prussia%',
    '%Kirtland%', 
    '%Las Vegas%',
    '%Laurel%',
    '%Los Angeles%',
    '%Louisiana%',
    '%Maine%',
    '%Mall%',
    '%Marietta%',
    '%Maryland%',
    '%Massachusetts%', 
    '%Melrose%',
    '%Miami%',
    '%Michigan%', 
    '%Minneapolis%',
    '%Minnesota%',
    '%Mirada%',
    '%Missouri%',
    '%Morristown%',
    '%Nashville%',
    '%Nevada%',
    '%New Hampshire%',
    '%New Jersey%', 
    '%New York%',
    '%Niagra Falls%',
    '%NorCal%',
    '%Oakland%',
    '%Ohio%',
    '%Oklahoma%',
    '%Oregon%',
    '%Orlando%',
    '%Parsippany%',
    '%Paul%',
    '%Pennsylvania%',
    '%Philadelphia%',
    '%Phoenixville%',
    '%Piscataway%',
    '%Pittsburgh%',
    '%Port St. Lucie%',
    '%Portland%',
    '%Red Bank%', 
    '%Rhode Island%', 
    '%Richmond%',
    '%Salt Lake City%',
    '%San Francisco%',
    '%San%',
    '%Seattle%',
    '%South Windsor%',
    '%St. Louis%',
    '%Tennessee%',
    '%texas%', 
    '%United States%',  
    '%Vermont%',
    '%Virginia%',
    '%Washington%',
    '%Winter Park%',
    '%Wisconsin%',
    'Balance Patch, MA',
    'Londonderry, New Hampshire',
    'Manchester, Connecticut',
    'Manchester, Connecticut',
    'Manchester, CT',
    'Manchester, New Hampshire',
    'Manchester, New Hampshire, US',
    'Manchester, New Hampshire, US',
    'Manchester, NH ',
    'San Francisco, California, US (USF Lone Mountain Conference Center)', 
    'Shakopee, Minnesota, US (Mystic Lake Casino)',
    'Kent',
    'Somerset',
    '%Waterville%'
    )

OR UPDATED_LOCATION LIKE ANY (
'%, FL%', 
'%, GA%', 
'%, IN%', 
'%, ME%', 
'%, MI%', 
'%, PA%', 
'%AL%', 
'%AR%', 
'%CA%', 
'%CT%', 
'%IL%', 
'%KS%', 
'%KY%', 
'%LA%', 
'%MA%', 
'%MD%', 
'%MO%', 
'%NC%', 
'%ND%', 
'%NH%', 
'%NJ%', 
'%NY%', 
'%OH%', 
'%OK%', 
'%OR%', 
'%SC%', 
'%SD%', 
'%TN%', 
'%TX%', 
'%US',
'%USA%', 
'%VA%', 
'%WI%', 
'US-E', 
'US-W',
'us-e'
))

AND UPDATED_LOCATION != 'Vietnam - INDOORGAME';


UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'United Kingdom of Great Britain and Northern Ireland'
WHERE UPDATED_LOCATION ILIKE ANY ('%United Kingdom%', '%England%', '%Birmingham%', '%Edinburgh%', 'York', '%Stoke%', '%Glasgow%', '%Kettering%', '%Leicester%',
'%London%', '%Liverpool%', '%Manchester%', '%Helens%', '%Peterborough%', '%Scotland%')
OR UPDATED_LOCATION LIKE '%UK%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Uruguay'
WHERE UPDATED_LOCATION ILIKE '%Uruguay%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Uzbekistan'
WHERE UPDATED_LOCATION ILIKE '%Uzbekistan%';

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Venezuela'
WHERE UPDATED_LOCATION ILIKE ANy ('%Venezuela%', '%Carab%');

UPDATE API07_TOURNAMENT_LOCATIONS
SET UPDATED_LOCATION = 'Vietnam'
WHERE UPDATED_LOCATION ILIKE ANY ('%Vietnam%', 'AOEVIET 76 Le Duc Tho Street', '%Hanoi%', '%Viet Nam%', '%Ho Chi%', '%Minh%', '%Hà Nội%', '%Hà Đông%');



-- ONLINE
-- add column with information about online tournaments (2 source columns: Location and Tournament name)
ALTER TABLE API07_TOURNAMENT_LOCATIONS
ADD COLUMN ONLINETOURNAMENTS VARCHAR (255) NULL;

UPDATE API07_TOURNAMENT_LOCATIONS
    SET ONLINETOURNAMENTS = 'online',
    -- locations with more than one country or any country were considered as online (they were nulled above)
    "UPDATED_LOCATION" = NULL 
    WHERE ("Location" 
    ILIKE ANY (
    '%Online%', 
    '%Onine%',
    '%Onlinr%',
    '%Onilne%',
    '%Onlie%',
    '%Onliine%',
    '%Onlline%',
    '%Onlnie%',
    '%youtube%',
    '%https%',
    '%.net%',
    '%.com%',
    '%twitch%',
    'Global%', 
    'International',
    '%Remote%',
    '%Servers%',
    '%ESL%'
)
    OR "Location" = 'SEA'
    OR 'TournamentName' ILIKE '%online%';