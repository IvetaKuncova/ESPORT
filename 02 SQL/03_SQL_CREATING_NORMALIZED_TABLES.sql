/* ===== BLOCK: Block 1 ===== */

-- creating a table of PLAYERS
-- join with Date of birth table
CREATE OR REPLACE TABLE PLAYER AS 
SELECT 
    P."playerid"::int AS P_PLAYER_ID, 
    "NameFirst" AS P_NAME_FIRST, 
    "NameLast" AS P_NAME_LAST, 
    "CurrentHandle" AS P_NICK_NAME, 
    "DateOfBirth"::date AS P_DATE_OF_BIRTH, 
    "Year"::int AS P_BIRTH_YEAR, 
    UPPER("CountryCode") AS P_COUNTRY2CODE, 
    "WorldRanking"::int AS P_WORLD_RANK, 
    "CountryRanking"::int AS P_COUNTRY_RANK, 
    "TotalUSDPrize"::float AS P_PRIZE_USD, 
    "TotalTournaments"::int AS P_CNT_TOURNAMENTS
FROM API01_PLAYER AS P
FULL JOIN PlayerDOB AS D ON P."PlayerId"=D."PlayerId"
ORDER BY P_PLAYER_ID;

-- the code for kosovo ‘xk’ is replaced by ‘ko’ in the PLAYER table, because that way it can be correctly linked to the COUNTRY table (ISO 3166)
UPDATE PLAYER
SET P_COUNTRY2CODE = 'KO' 
WHERE P_COUNTRY2CODE = 'XK';

/* ===== BLOCK: Block 2 ===== */

-- creating a table of GAMES
CREATE OR REPLACE TABLE GAME AS
-- add RANK to the table according to three indicators - number of players, number of tournaments and total prize
WITH CTE_GAME AS (
SELECT 
    "GameId"::int AS G_GAME_ID,
    "GameName" AS G_GAME_NAME,
    "TotalUSDPrize"::float AS G_PRIZE_USD,
    "TotalTournaments"::int AS G_CNT_TOURNAMENTS,
    "TotalPlayers"::int AS G_CNT_PLAYERS,
    RANK() OVER(ORDER BY G_PRIZE_USD DESC NULLS LAST) AS G_RANK_PRIZE_USD,
    RANK() OVER(ORDER BY G_CNT_TOURNAMENTS DESC NULLS LAST) AS G_RANK_CNT_TOURNAMENTS,
    RANK() OVER(ORDER BY G_CNT_PLAYERS DESC NULLS LAST) AS G_RANK_CNT_PLAYERS
FROM API04_GAME
ORDER BY G_GAME_ID)

-- add the total RANK for the game to the table (created by adding all three basic ranks and ordering them from the lowest one)
SELECT 
    G_GAME_ID,
    G_GAME_NAME,
    G_PRIZE_USD,
    G_CNT_TOURNAMENTS,
    G_CNT_PLAYERS,
    G_RANK_PRIZE_USD,
    G_RANK_CNT_TOURNAMENTS,
    G_RANK_CNT_PLAYERS,
    RANK() OVER(ORDER BY (G_RANK_PRIZE_USD + G_RANK_CNT_TOURNAMENTS + G_RANK_CNT_PLAYERS) ASC NULLS LAST) AS G_RANK_ALL
FROM CTE_GAME
ORDER BY G_GAME_ID ASC;

/* ===== BLOCK: Block 3 ===== */

-- creation of a country codebook
CREATE OR REPLACE TABLE COUNTRY AS
SELECT 
    "CountryLAT" AS C_COUNTRY,
    "English_short_name" AS C_COUNTRY_UTF8,
    "Alpha2code" AS C_COUNTRY2CODE,
    "Alpha3code" AS C_COUNTRY3CODE,
    "Continent" AS C_CONTINENT
FROM COUNTRYCODES_IVETA
ORDER BY C_COUNTRY;

/* ===== BLOCK: Block 4 ===== */

-- creation of the GDP PER CAPITA table
CREATE OR REPLACE TEMPORARY TABLE TEMP_GDP_PER_CAPITA AS
SELECT 
    "Code" AS GDP_COUNTRY3CODE,
    "Year"::int AS GDP_YEAR,
    "GDP_per_capita_PPP_constant_2017_international"::float AS GDP_GDP_PER_CAPITA_USD
FROM "gdp-per-capita-worldbank"
ORDER BY GDP_COUNTRY3CODE, GDP_YEAR;

-- change the Kosovo code OWID_KOS to KOS so that it can be paired with the COUNTRY table (ISO 3166)
UPDATE TEMP_GDP_PER_CAPITA
SET GDP_COUNTRY3CODE = 'KOS'
WHERE GDP_COUNTRY3CODE = 'OWID_KOS';

CREATE OR REPLACE TABLE GDP_PER_CAPITA AS
SELECT 
    C_COUNTRY2CODE AS GDP_COUNTRY2CODE,
    GDP_YEAR,
    GDP_GDP_PER_CAPITA_USD
FROM TEMP_GDP_PER_CAPITA
LEFT JOIN COUNTRY ON GDP_COUNTRY3CODE= C_COUNTRY3CODE
WHERE GDP_COUNTRY3CODE is not null AND GDP_COUNTRY3CODE != 'OWID_WRL'
ORDER BY GDP_COUNTRY2CODE, GDP_YEAR;

/* ===== BLOCK: Block 5 ===== */

-- creation of Population table
CREATE OR REPLACE TEMPORARY TABLE TEMP_POPULATION AS
SELECT
    "Country_name" AS POP_COUNTRY,
    "Year"::int AS POP_YEAR,
    "Population"::int AS POP_POPULATION,
    "Population_aged_15_to_19_years"::int AS POP_POPULATION_AGED15_19,
    "Population_aged_20_to_29_years"::int AS POP_POPULATION_AGED20_29
FROM "population-and-demography"
-- omitting rows containing summaries for certain areas (rows that are not for individual countries)
WHERE 
    NOT POP_COUNTRY LIKE '%UN%'
    AND NOT POP_COUNTRY ILIKE '%developed%'
    AND NOT POP_COUNTRY ILIKE '%income%'
    AND NOT POP_COUNTRY ILIKE '%countries%'
    AND NOT POP_COUNTRY ILIKE '%developing%'
    AND NOT POP_COUNTRY = 'World'
ORDER BY POP_COUNTRY, POP_YEAR;

-- edit country names to be linked to the COUNTRY table
UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Congo-Kinshasa'
WHERE POP_COUNTRY = 'Congo';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Bonaire, Sint Eustatius and Saba'
WHERE POP_COUNTRY = 'Bonaire Sint Eustatius and Saba';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Virgin Islands (British)'
WHERE POP_COUNTRY = 'British Virgin Islands';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Brunei Darussalam'
WHERE POP_COUNTRY = 'Brunei';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Cabo Verde'
WHERE POP_COUNTRY = 'Cape Verde';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Cote dIvoire'
WHERE POP_COUNTRY = $$Cote d'Ivoire$$; --'

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Congo-Kinshasa'
WHERE POP_COUNTRY = 'Democratic Republic of Congo';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Timor-Leste'
WHERE POP_COUNTRY = 'East Timor';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Lao Peoples Democratic Republic'
WHERE POP_COUNTRY = 'Laos';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Micronesia'
WHERE POP_COUNTRY = 'Micronesia (country)';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Russian Federation'
WHERE POP_COUNTRY = 'Russia';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Saint Martin'
WHERE POP_COUNTRY = 'Saint Martin (French part)';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Sint Maarten'
WHERE POP_COUNTRY = 'Sint Maarten (Dutch part)';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Syrian Arab Republic'
WHERE POP_COUNTRY = 'Syria';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'Turkiye'
WHERE POP_COUNTRY = 'Turkey';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'United Kingdom of Great Britain and Northern Ireland'
WHERE POP_COUNTRY = 'United Kingdom';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'United States of America'
WHERE POP_COUNTRY = 'United States';

UPDATE TEMP_POPULATION
SET POP_COUNTRY = 'United States Minor Outlying Islands'
WHERE POP_COUNTRY = 'United States Virgin Islands';

CREATE OR REPLACE TABLE POPULATION AS
SELECT
    C_COUNTRY2CODE AS POP_COUNTRY2CODE,
    POP_YEAR,
    POP_POPULATION,
    POP_POPULATION_AGED15_19 + POP_POPULATION_AGED20_29 AS POP_POPULATION_AGED15_29
FROM TEMP_POPULATION
LEFT JOIN COUNTRY ON POP_COUNTRY = C_COUNTRY
ORDER BY POP_COUNTRY, POP_YEAR;

/* ===== BLOCK: Block 6 ===== */

-- creating an Internet table
CREATE OR REPLACE TEMPORARY TABLE TEMP_INTERNET AS
SELECT
    "Entity" AS I_COUNTRY,
    "Code" AS I_COUNTRY3CODE,
    "Year"::int AS I_YEAR,
    "Individuals_using_the_Internet_of_population"::float AS I_SHARE_OF_INDIVID_USING_INTERNET
FROM "share-of-individuals-using-the-internet"
WHERE I_COUNTRY3CODE is not null AND I_COUNTRY3CODE != 'OWID_WRL'
ORDER BY I_COUNTRY, I_YEAR;

-- change the Kosovo code OWID_KOS to KOS so that it can be paired with the COUNTRY table  (ISO 3166)
UPDATE TEMP_INTERNET
SET I_COUNTRY3CODE = 'KOS'
WHERE I_COUNTRY3CODE = 'OWID_KOS';

-- edit country names if someone decides to pair them to the COUNTRY table  (ISO 3166)

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Virgin Islands (British)'
WHERE I_COUNTRY = 'British Virgin Islands';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Brunei Darussalam'
WHERE I_COUNTRY = 'Brunei';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Congo-Kinshasa'
WHERE I_COUNTRY = 'Congo';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Cabo Verde'
WHERE I_COUNTRY = 'Cape Verde';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Cote dIvoire'
WHERE I_COUNTRY = $$Cote d'Ivoire$$; --'

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Congo-Kinshasa'
WHERE I_COUNTRY = 'Democratic Republic of Congo';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Timor-Leste'
WHERE I_COUNTRY = 'East Timor';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Lao Peoples Democratic Republic'
WHERE I_COUNTRY = 'Laos';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Micronesia'
WHERE I_COUNTRY = 'Micronesia (country)';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Russian Federation'
WHERE I_COUNTRY = 'Russia';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Syrian Arab Republic'
WHERE I_COUNTRY = 'Syria';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'Turkiye'
WHERE I_COUNTRY = 'Turkey';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'United States of America'
WHERE I_COUNTRY = 'United States';

UPDATE TEMP_INTERNET
SET I_COUNTRY = 'United States Minor Outlying Islands'
WHERE I_COUNTRY = 'United States Virgin Islands';

CREATE OR REPLACE TABLE INTERNET AS
SELECT
    C_COUNTRY2CODE AS I_COUNTRY2CODE,
    I_YEAR,
    I_SHARE_OF_INDIVID_USING_INTERNET
FROM TEMP_INTERNET
LEFT JOIN COUNTRY ON I_COUNTRY3CODE=C_COUNTRY3CODE
WHERE I_COUNTRY3CODE is not null AND I_COUNTRY3CODE != 'OWID_WRL'
ORDER BY I_COUNTRY, I_YEAR;

/* ===== BLOCK: Block 7 ===== */

-- create Tournament table
CREATE OR REPLACE TABLE TOURNAMENT AS
SELECT
    "TournamentId"::int AS T_TOURNAMENT_ID,
    "TournamentName" AS T_TOURNAMENT_NAME,
    "StartDate"::date AS T_START_DATE,
    "EndDate"::date AS T_END_DATE,
    "Location" AS T_LOCATION,
    UPDATEDLOCATION AS T_COUNTRY,
    C_COUNTRY2CODE AS T_COUNTRY2CODE, 
    "ONLINETOURNAMENTS" AS T_ONLINE,
    "GameId"::int AS T_GAME_ID,
    "TotalUSDPrize"::float AS T_PRIZE_USD,
    "Teamplay"::boolean AS T_WAS_IT_TEAM_PLAY
FROM API07_TOURNAMENT_LOCATONS
LEFT JOIN COUNTRY ON T_COUNTRY=C_COUNTRY
ORDER BY T_TOURNAMENT_ID, T_GAME_ID;

/* ===== BLOCK: Block 8 ===== */

-- creating results table for individual player tournaments

CREATE OR REPLACE TABLE TOURNAMENT_RESULTS_INDIVIDUAL AS
SELECT 
    "TournamentId"::int AS TRI_TOURNAMENT_ID,
    "PlayerId"::int AS TRI_PLAYER_ID,
    "Ranking"::int AS TRI_RANKING,
    "RankText" AS TRI_RANK_TEXT,
    "PrizeUSD"::float AS TRI_PRIZE_USD
FROM API08_TOURNAMENT_INDIVIDUAL_RESULTS
ORDER BY TRI_TOURNAMENT_ID,TRI_PLAYER_ID;

/* ===== BLOCK: Block 10 ===== */

-- creating table TOURNAMENT_TEAM
CREATE OR REPLACE TABLE TOURNAMENT_TEAM AS
SELECT 
    DISTINCT "TournamentTeamId"::int AS TT_TOURNAMENT_TEAM_ID,
    "TournamentTeamName" AS TT_TOURNAMENT_TEAM_NAME
FROM API09_TOURNAMENT_TEAM_RESULTS
ORDER BY TT_TOURNAMENT_TEAM_ID;

/* ===== BLOCK: Block 11 ===== */

-- creation of results table for team tournaments

CREATE OR REPLACE TABLE TOURNAMENT_RESULTS_TEAM AS
WITH CTE_CNTPLAYERS AS (
SELECT 
    "TournamentId"::int AS TOURNAMENT_ID,
    "TournamentTeamId"::int AS TOURNAMENT_TEAM_ID,
    IFNULL(COUNT(DISTINCT "PlayerId"),0)::int AS CNT_PLAYER_ID
FROM API10_TOURNAMENT_PLAYER_IN_TEAM_RESULTS
GROUP BY TOURNAMENT_ID, TOURNAMENT_TEAM_ID
ORDER BY TOURNAMENT_ID, TOURNAMENT_TEAM_ID, CNT_PLAYER_ID
)

SELECT 
    dev."TournamentId"::int AS TRT_TOURNAMENT_ID,
    dev."TeamId"::int AS TRT_TEAM_ID,
    dev."TeamName" AS TRT_TEAM_NAME,
    dev."TournamentTeamId"::int AS TRT_TOURNAMENT_TEAM_ID,
    dev."Ranking"::int AS TRT_TEAM_RANKING,
    dev."RankText" AS TRT_TEAM_RANK_TEXT,
    dev."PrizeUSD"::float AS TRT_TEAM_PRIZE_USD,
    dev."UnknownPlayerCount"::int AS TRT_CNT_UNKNOWN_PLAYERS,
    c.CNT_PLAYER_ID::int AS TRT_CNT_KNOWN_PLAYERS
FROM API09_TOURNAMENT_TEAM_RESULTS dev
LEFT JOIN CTE_CNTPLAYERS c ON TRT_TOURNAMENT_TEAM_ID=c.TOURNAMENT_TEAM_ID
ORDER BY TRT_TOURNAMENT_ID, TRT_TEAM_ID, TRT_TOURNAMENT_TEAM_ID;

/* ===== BLOCK: Block 12 ===== */

-- creating a table of results of individual players in teams
CREATE OR REPLACE TABLE TOURNAMENT_RESULTS_PLAYER_IN_TEAM AS
WITH CTE_CNTPLAYERS AS (
SELECT 
    "TournamentId"::int AS TOURNAMENT_ID,
    "TournamentTeamId"::int AS TOURNAMENT_TEAM_ID,
    IFNULL(COUNT(DISTINCT "PlayerId"),0)::int AS CNT_PLAYER_ID
FROM "API10_TOURNAMENT_PLAYER_IN_TEAM_RESULTS" 
GROUP BY TOURNAMENT_ID, TOURNAMENT_TEAM_ID
ORDER BY TOURNAMENT_ID, TOURNAMENT_TEAM_ID, CNT_PLAYER_ID
)

SELECT 
    des."TournamentId"::int AS TRP_TOURNAMENT_ID,
    des."TournamentTeamId"::int AS TRP_TOURNAMENT_TEAM_ID,
    des."PlayerId"::int AS TRP_PLAYER_ID,
    (dev."PrizeUSD"::float / (dev."UnknownPlayerCount"::int + c.CNT_PLAYER_ID)) AS TRP_PRIZE_USD_FOR_PLAYER
FROM "API10_TOURNAMENT_PLAYER_IN_TEAM_RESULTS" des
LEFT JOIN "API09_TOURNAMENT_TEAM_RESULTS" dev ON dev."TournamentTeamId"=des."TournamentTeamId"
JOIN CTE_CNTPLAYERS c ON c.TOURNAMENT_TEAM_ID=des."TournamentTeamId"
ORDER BY TRP_TOURNAMENT_ID, TRP_TOURNAMENT_TEAM_ID, TRP_PLAYER_ID;

/* ===== BLOCK: Block 13 ===== */

-- adding records about players who are in API08_TOURNAMENT_INDIVIDUAL_RESULTS and API10_TOURNAMENT_PLAYER_IN_TEAM_RESULTS tables
-- but the are not not in PLAYER table
INSERT INTO PLAYER        
    (P_PLAYER_ID,
    P_NAME_FIRST,
    P_NAME_LAST,
    P_NICK_NAME,
    P_COUNTRY2CODE,
    P_PRIZE_USD)
-- select player detail data from table API08_TOURNAMENT_INDIVIDUAL_RESULTS (detailed data are not in normalized TOURNAMENT_RESULTS_INDIVIDUAL table)
SELECT 
    DISTINCT "PlayerId"::int AS PLAYER_ID,
    "NameFirst" AS NAME_FIRST,
    "NameLast" AS NAME_LAST,
    "CurrentHandle" AS NICK_NAME,
    "CountryCode" AS COUNTRY2CODE,
    SUM("PrizeUSD")::float AS PRIZE_USD
    FROM API08_TOURNAMENT_INDIVIDUAL_RESULTS
    -- select id of players who are in TOURNAMENT_RESULTS_INDIVIDUAL table but not in PLAYERS table
        WHERE PLAYER_ID IN 
        (SELECT * FROM
            (SELECT DISTINCT TRI_PLAYER_ID AS PLAYERID
            FROM TOURNAMENT_RESULTS_INDIVIDUAL
            EXCEPT
            (SELECT DISTINCT P_PLAYER_ID AS PLAYERID
            FROM PLAYER)
            )
        )
        -- PLAYER_IDs greater than 900,000 are not real IDs, 
        -- they only serve as a placeholder to keep track of the number of players and their winnings when the player is unknown.
        AND PLAYER_ID < 900000
    GROUP BY PLAYER_ID,NAME_FIRST,NAME_LAST,NICK_NAME,COUNTRY2CODE
UNION
    -- select player detail data from table API10_TOURNAMENT_PLAYER_IN_TEAM_RESULTS (detailed data are not in normalized TOURNAMENT_RESULTS_PLAYER_IN_TEAM table)
    SELECT 
        DISTINCT "PlayerId"::int AS PLAYER_ID,
        "NameFirst" AS NAME_FIRST,
        "NameLast" AS NAME_LAST,
        "CurrentHandle" AS NICK_NAME,
        "CountryCode" AS COUNTRY2CODE,
        SUM(TRP_PRIZE_USD_FOR_PLAYER)::float AS PRIZE_USD
    FROM "API10_TOURNAMENT_PLAYER_IN_TEAM_RESULTS"
    LEFT JOIN TOURNAMENT_RESULTS_PLAYER_IN_TEAM ON PLAYER_ID=TRP_PLAYER_ID
    -- select id of players who are in  TOURNAMENT_RESULTS_PLAYER_IN_TEAM table but not in PLAYERS table
        WHERE PLAYER_ID IN (
        SELECT * FROM
        (SELECT DISTINCT TRP_PLAYER_ID AS PLAYERID
        FROM TOURNAMENT_RESULTS_PLAYER_IN_TEAM)
        EXCEPT
        (SELECT DISTINCT P_PLAYER_ID AS PLAYERID
        FROM PLAYER)
        ) 
    GROUP BY PLAYER_ID, NAME_FIRST, NAME_LAST, NICK_NAME, COUNTRY2CODE
ORDER BY PLAYER_ID, NAME_FIRST, NAME_LAST, NICK_NAME, COUNTRY2CODE;

/* ===== BLOCK: Block 16 ===== */

/* update TOURNAMENTs table: add the tournaments that:
1) are in the TOURNAMENT_RESULTS_INDIVIDUAL and TOURNAMENT_RESULTS_TEAM tables, 
2) THEY'RE NOT IN THE TOURNAMENT TABLE */

INSERT INTO TOURNAMENT        
(T_TOURNAMENT_ID,
T_PRIZE_USD)
-- select available data from TOURNAMENT RESULTS 
SELECT * FROM
    (
    SELECT TRI_TOURNAMENT_ID::int AS T_TOURNAMENT_ID, SUM(TRI_PRIZE_USD)::float AS T_PRIZE_USD
    FROM TOURNAMENT_RESULTS_INDIVIDUAL
    GROUP BY T_TOURNAMENT_ID
    UNION ALL
    SELECT TRT_TOURNAMENT_ID::int AS T_TOURNAMENT_ID, SUM(TRT_TEAM_PRIZE_USD)::float AS T_PRIZE_USD
    FROM TOURNAMENT_RESULTS_TEAM
    GROUP BY T_TOURNAMENT_ID
    )
WHERE T_TOURNAMENT_ID IN 
    (
    SELECT DISTINCT T_TOURNAMENT_ID FROM
        (
        SELECT TRI_TOURNAMENT_ID::int AS T_TOURNAMENT_ID
        FROM TOURNAMENT_RESULTS_INDIVIDUAL
        GROUP BY T_TOURNAMENT_ID
        UNION ALL
        SELECT TRT_TOURNAMENT_ID::int AS T_TOURNAMENT_ID
        FROM TOURNAMENT_RESULTS_TEAM
        GROUP BY T_TOURNAMENT_ID
        )
        EXCEPT
        SELECT T_TOURNAMENT_ID
        FROM TOURNAMENT
    );










