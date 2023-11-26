CREATE OR REPLACE TABLE API07TOURNAMENTBYID_LOCATONS_UPD AS
SELECT *, "Location" as UPDATEDLOCATION FROM API07TOURNAMENTBYID_COMPLETEDATASET_ORIGINAL;

-- Update locations 
UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET "Location" = REPLACE("Location", ';', ',');

-- troubled locations (not a country or city)
UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = null
-- locations with online/offline and country or city are considerd as offline
WHERE (UPDATEDLOCATION ILIKE ANY 
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
    OR UPDATEDLOCATION LIKE ANY 
        ('AMERICA',
        '%EMEA%'
        ))

AND UPDATEDLOCATION NOT IN (
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

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Azerbaijan'
WHERE UPDATEDLOCATION ILIKE '%Azerbaijan%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Argentina'
WHERE UPDATEDLOCATION ILIKE ANY ('%Argentina%', 'Argentinia', '%Buenos Aires%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Albania'
WHERE UPDATEDLOCATION ILIKE '%Albania%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Armenia'
WHERE UPDATEDLOCATION ILIKE '%Armenia%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Australia'
WHERE (UPDATEDLOCATION ILIKE ANY ('%Australia%', '%Sydney%', '%Victoria%', '%Brisbane%', '%Melbourne%', 'Bentley')
 OR UPDATEDLOCATION = 'Adelaide')
 AND UPDATEDLOCATION NOT IN ('Ciudad de Victoria, Philippines', 'Royal Victoria Dock, 1 Western Gateway, Royal Docks, London E16 1XL, UK');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Austria'
WHERE UPDATEDLOCATION ILIKE ANY ('%Austria%', '%Wien%', '%Vienna%', '%St. Pölten%') ;

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Bangladesh'
WHERE UPDATEDLOCATION ILIKE '%Bangladesh%' ;

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Bahamas'
WHERE UPDATEDLOCATION ILIKE '%Bahamas%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Bahrain'
WHERE UPDATEDLOCATION ILIKE ANY ('%Bahrain%', '%Riffa, Barhain%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Belarus'
WHERE UPDATEDLOCATION ILIKE '%Belarus%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Belgium'
WHERE UPDATEDLOCATION ILIKE ANY ('%Belgium%', '%Brussel%', '%Charleroi%', '%Ghent%', '%Mechelen%', '%Schaerbeek%')
AND UPDATEDLOCATION != 'Paris, France (Group Stage), London, UK (Quarterfinals), Brussels, Belgium (Semifinals), Berlin, Germany (Final)' ;

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Bosnia and Herzegovina'
WHERE UPDATEDLOCATION ILIKE '%Bosnia%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Brazil'
WHERE UPDATEDLOCATION ILIKE ANY ('%Brazil%', '%Bras%', '%Paulo%', '%Curitiba%', '%Niteroi%', '%Sao Paolo%')
AND UPDATEDLOCATION != 'Bellevue, Nebraska, USA';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Brunei Darussalam'
WHERE UPDATEDLOCATION ILIKE '%Brunei%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Bulgaria'
WHERE UPDATEDLOCATION ILIKE '%Bulgaria%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Cambodia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Cambodia%', '%Phnom Penh%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Canada'
WHERE UPDATEDLOCATION ILIKE ANY ('%Canada%', '%Alberta%', '%Toronto%', '%Montreal%', '%Montréal%', 
'%Vancouver%', '%BC%', '%Ontario%', '%QC%', '%Oakville%', '%Quebec%', '%Mississauga%', '%Ottawa%', '%Québec%')
AND UPDATEDLOCATION NOT IN ('Richmond, BC', 'Ontario, CA, USA', 'Ontario, California', 'Ontario, California, US', 'Ontario, California, USA');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Colombia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Colombia%', '%Bogotá%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Costa Rica'
WHERE UPDATEDLOCATION ILIKE '%Costa Rica%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Croatia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Croatia%', '%Osijek%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Czechia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Czech%', '%Prague%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Denmark'
WHERE UPDATEDLOCATION ILIKE ANY ('%Denmark%', '%Danemark%', '%Copenhagen%', '%Fredericia%') ;

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Dominican Republic'
WHERE UPDATEDLOCATION ILIKE ANY ('%Dominican Republic%', '%Domingo%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Ecuador'
WHERE UPDATEDLOCATION ILIKE '%Ecuador%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Egypt'
WHERE UPDATEDLOCATION ILIKE ANY ('%Egypt%', '%Cairo%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Estonia'
WHERE UPDATEDLOCATION ILIKE '%Estonia%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Faroe Islands'
WHERE UPDATEDLOCATION ILIKE '%Faroe Islands%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Finland'
WHERE UPDATEDLOCATION ILIKE ANY ('%Finland%', '%Helsinki%', '%Finalnd%', '%Turku%', '%Tempere%', '%Tampere%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'France'
WHERE (UPDATEDLOCATION ILIKE ANY ('%France%', 'Aubervilliers', 'Cappelle la Grande', '%Chartres%', '%Tours%', '%Brest%', '%Gardanne%', '%La Rochelle%',
 '%Le Kremlin-Bicetre%', '%Perpi%', '%Pari%', '%Lille', '%Lyon%', '%Marseille%',  '%Montpellier%', '%Nantes%', '%Noisy%', '%Versailles%', '%Poitiers%', '%Rennes%', '%Royan%') 
 OR UPDATEDLOCATION LIKE '%FRA%')
 AND UPDATEDLOCATION NOT LIKE '%s/Paris Las Vegas,  Las Vegas, NV'; 

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Georgia'
WHERE UPDATEDLOCATION = 'Tbilisi, Georgia';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Germany'
WHERE UPDATEDLOCATION ILIKE ANY ('%Germany%', 'Aachen', '%Berlin%', '%Cologne%', '%Essen%', '%Frankfurt%', '%Hamburg%', '%Zorneding%', '%Krefeld%', 
'%Deutschland%', '%Leipzig%', '%Munich%', '%Osnabrück%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Ghana'
WHERE UPDATEDLOCATION ILIKE '%Ghana%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Greece'
WHERE UPDATEDLOCATION ILIKE ANY ('%Greece%', '%Ilion, Athens%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Honduras'
WHERE UPDATEDLOCATION ILIKE '%Honduras%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Hong Kong'
WHERE  UPDATEDLOCATION ILIKE ANY ('%Mong Kok%', '%Hong Kong%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Hungary'
WHERE UPDATEDLOCATION ILIKE ANY ('%Hungary%', '%Budapest%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Chile'
WHERE UPDATEDLOCATION ILIKE ANY ('%Chile%', '%Caldera%');
 
UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'China'
WHERE UPDATEDLOCATION ILIKE ANY ('%China%', '%Beijing%', '%Changsha%', '%Changzhou%', '%Shenzhen%', '%Xian%','%Xiamen%', '%Suzhou%', '%Chine%',  '%Hangzhou%',
 '%Shandong%', '%Maca%', '%Wuhan%', '%Shanghai%', 'Xi%')
 AND UPDATEDLOCATION != 'Pak-China Friendship Center, Islamabad, Pakistan';  
 
UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Iceland'
WHERE UPDATEDLOCATION ILIKE '%Iceland%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'India'
WHERE UPDATEDLOCATION ILIKE ANY ('%India',  '%Hyderabad%', 'South Asia, Chennai');
-- tady druhé procento byt nesmi (Indiana - USA)

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Indonesia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Indonesia%', '%Jakarta%', '%Bandung%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Iran'
WHERE UPDATEDLOCATION ILIKE '%Iran%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Iraq'
WHERE UPDATEDLOCATION ILIKE '%Iraq%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Ireland'
WHERE UPDATEDLOCATION ILIKE ANY ('%Ireland%', '%Cork%', '%Dublin%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Israel'
WHERE UPDATEDLOCATION ILIKE ANY ('%Israel%', '%Tel Aviv%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Italy'
WHERE UPDATEDLOCATION ILIKE ANY ('%Italy%', 'Adria', '%Bologna%', '%Spezia%', '%Milan%', 'Napol%', '%Rimini%', '%Rome%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Japan'
WHERE UPDATEDLOCATION ILIKE ANY ('%Japan%', '%Chiba%', '%Tokyo%', '%Okinawa%', '%Saitama%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Kazakhstan'
WHERE UPDATEDLOCATION ILIKE ANY ('%Kazakhstan%', '%Almaty%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'South Korea'
WHERE UPDATEDLOCATION ILIKE ANY ('%South Korea%', 'Seoul, Korea', 'Busan, Korea', 'offline, Korea', 'Korea', '???, Korea', 'Incheon, Korea', 'Ulsan, Korea',
'Offline, Korea', 'Goyang, Korea', 'Seongnam, Korea', '%Seoul%', '%Busan%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Kosovo'
WHERE UPDATEDLOCATION ILIKE '%Kosovo%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Kuwait'
WHERE UPDATEDLOCATION ILIKE '%Kuwait%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Kyrgyzstan'
WHERE UPDATEDLOCATION ILIKE '%Kyrgyzstan%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Lao Peoples Democratic Republic'
WHERE UPDATEDLOCATION ILIKE '%Laos%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Latvia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Latvia%', '%Lativa%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Lebanon'
WHERE UPDATEDLOCATION ILIKE '%Lebanon%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Lithuania'
WHERE UPDATEDLOCATION ILIKE ANY ('%Lithuania%', '%Kaunas%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Luxembourg'
WHERE UPDATEDLOCATION ILIKE '%Luxembourg%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Macao'
WHERE UPDATEDLOCATION ILIKE ANY ('%Macao%', 'Macau%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Malaysia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Malaysia%', '%Subang%', '%Kuala%', '%Petaling%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Malta'
WHERE UPDATEDLOCATION ILIKE '%Malta%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Mexico'
WHERE UPDATEDLOCATION ILIKE '%Mexico%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Moldova'
WHERE UPDATEDLOCATION ILIKE '%Moldova%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Monaco'
WHERE UPDATEDLOCATION ILIKE '%Monaco%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Mongolia'
WHERE UPDATEDLOCATION ILIKE '%Mongolia%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Montenegro'
WHERE UPDATEDLOCATION ILIKE '%Montenegro%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Morocco'
WHERE UPDATEDLOCATION ILIKE '%Morocco%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Myanmar'
WHERE UPDATEDLOCATION ILIKE ANY ('%Myanmar%', '%Yangon%'); 

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Netherlands'
WHERE UPDATEDLOCATION ILIKE ANY ('%Netherlands%', '%Netherland%', '%Alphen aan den Rijn%', '%Utrecht%', '%Tilburg%', '%Amsterdam%', '%Arnhem%', 'Assen', '%, NL%', 
'%Holland%', '%Maastricht%', '%Rotterdam%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'New Zealand'
WHERE UPDATEDLOCATION ILIKE ANY ('%New Zealand%', 'ANZ', '%Christchurch%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'North Macedonia'
WHERE UPDATEDLOCATION ILIKE '%Macedonia%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'North Macedonia'
WHERE UPDATEDLOCATION ILIKE '%Macedonia%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Norway'
WHERE UPDATEDLOCATION ILIKE ANY ('%Norway%', '%Lillestrom%', '%Oslo%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Pakistan'
WHERE UPDATEDLOCATION ILIKE ANY ('%Pakistan%', '%Islamabad%', '%Karachi%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Panama'
WHERE UPDATEDLOCATION ILIKE '%Panam%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Paraguay'
WHERE UPDATEDLOCATION ILIKE '%Paraguay%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Peru'
WHERE UPDATEDLOCATION ILIKE ANY ('%Peru%', '%Lima%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Philippines'
WHERE UPDATEDLOCATION LIKE ANY ('%Manila%', '%Philippines%', '%Phillipines%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Poland'
WHERE UPDATEDLOCATION ILIKE ANY ('%Poland%', '%Katowice%', '%Gdańsk%', '%Warsaw%', '%Kraków%', '%Nadarzyn%', '%Next One Cup%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Portugal'
WHERE UPDATEDLOCATION ILIKE ANY ('%Portugal%', '%Lisbon%', '%Porto%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Puerto Rico'
WHERE UPDATEDLOCATION ILIKE '%Puerto Rico%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Qatar'
WHERE UPDATEDLOCATION ILIKE '%Qatar%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Romania'
WHERE UPDATEDLOCATION ILIKE ANY ('%Romania%', '%Bucharest%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Russian Federation'
WHERE UPDATEDLOCATION ILIKE ANY ('%Russia%', '%Belgorod%', '%Ufa%', '%Moscow%')
AND UPDATEDLOCATION NOT ILIKE '%King of Prussia%'; 

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Saudi Arabia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Saudi Arabia%', 'Al Khobar', '%Riyadh%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Serbia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Serbia%', '%Belgrade%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Singapore'
WHERE UPDATEDLOCATION ILIKE ANY ('%Singapore%', '%Singpore%', '%Singapore');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Slovakia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Slovakia%', '%Bratislava%', '%Slowakia%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Slovenia'
WHERE UPDATEDLOCATION ILIKE ANY ('%Slovenia%', '%Ljubljana%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'South Africa'
WHERE UPDATEDLOCATION ILIKE ANY ('%South Africa%', '%Pretoria%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Spain'
WHERE UPDATEDLOCATION ILIKE ANY ('%Spain%', 'A Coruña', '%Madrid%', '%Barcelona%', '%Daganzo de Arriba%', '%Valencia%', '%Malaga%', '%Mérida%', '%Pontevedra%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Sri Lanka'
WHERE UPDATEDLOCATION ILIKE '%Sri Lanka%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Sweden'
WHERE UPDATEDLOCATION ILIKE ANY ('%Sweden%', '%Jönköping%', '%Stockholm%', '%Gothenburg%', '%Lidköping%', '%Malmö%')
AND UPDATEDLOCATION != 'Jönköping, USA';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Switzerland'
WHERE UPDATEDLOCATION ILIKE ANy ('%Switzerland%', 'Bern', '%Bienne%', '%Zürich%', '%Zurich%', '%Winterthur%', '%Wangen%', '%Fribourg%', '%Swiss%', '%Swizerland%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Taiwan'
WHERE UPDATEDLOCATION ILIKE ANY ('%Taiwan%', '%Taipei%', '%Tapei%', '%Kaohsiung%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Thailand'
WHERE UPDATEDLOCATION ILIKE ANY ('%Thailand%', '%Bangkok%', '%Chiang Mai%', '%Rangsit%', 'Thai', '%Suphanburi%', '%Nonthaburi%', '%Rayong%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Tunisia'
WHERE UPDATEDLOCATION ILIKE '%Tunisia%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Turkiye'
WHERE UPDATEDLOCATION ILIKE '%Turkey%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Ukraine'
WHERE UPDATEDLOCATION ILIKE ANY ('%Ukraine%', '%Kyiv%', '%Kiev%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'United Arab Emirates'
WHERE UPDATEDLOCATION ILIKE ANy ('%Emirates%', '%Dubai%', '%UAE%', '%Abu Dhabi%');


UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'United States of America'
WHERE (UPDATEDLOCATION ILIKE ANY (
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

OR UPDATEDLOCATION LIKE ANY (
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

AND UPDATEDLOCATION != 'Vietnam - INDOORGAME';


UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'United Kingdom of Great Britain and Northern Ireland'
WHERE UPDATEDLOCATION ILIKE ANY ('%United Kingdom%', '%England%', '%Birmingham%', '%Edinburgh%', 'York', '%Stoke%', '%Glasgow%', '%Kettering%', '%Leicester%',
'%London%', '%Liverpool%', '%Manchester%', '%Helens%', '%Peterborough%', '%Scotland%')
OR UPDATEDLOCATION LIKE '%UK%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Uruguay'
WHERE UPDATEDLOCATION ILIKE '%Uruguay%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Uzbekistan'
WHERE UPDATEDLOCATION ILIKE '%Uzbekistan%';

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Venezuela'
WHERE UPDATEDLOCATION ILIKE ANy ('%Venezuela%', '%Carab%');

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
SET UPDATEDLOCATION = 'Vietnam'
WHERE UPDATEDLOCATION ILIKE ANY ('%Vietnam%', 'AOEVIET 76 Le Duc Tho Street', '%Hanoi%', '%Viet Nam%', '%Ho Chi%', '%Minh%', '%Hà Nội%', '%Hà Đông%');







-- ONLINE
--add collumn with information about online tournaments
ALTER TABLE API07TOURNAMENTBYID_LOCATONS_UPD
ADD COLUMN ONLINETOURNAMENTS VARCHAR (255) NULL;

UPDATE API07TOURNAMENTBYID_LOCATONS_UPD
    SET ONLINETOURNAMENTS = 'online',
    "UPDATEDLOCATION" = NULL 
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
    '%Servers%'
)
    OR "Location" IN ('SEA', '%ESL%'))
    AND NOT "Location" IN (
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
    'Online/Offline: Singapore'
    )
    OR 'TournamentName' ILIKE '%online%';