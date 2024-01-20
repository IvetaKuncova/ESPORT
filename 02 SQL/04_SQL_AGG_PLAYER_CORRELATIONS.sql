--  AGGREGATED DENORMALIZED TABLE FOR THE STATISTICS OF PLAYER CORRELATIONS IN PYTHON AND TABLEAU
CREATE OR REPLACE TABLE PLAYER_GDP_POP_INT AS
SELECT 
    C_COUNTRY AS GPI_COUNTRY, 
    C_CONTINENT AS GPI_CONTINENT, 
    COUNT(DISTINCT P_PLAYER_ID)::int as GPI_CNT_PLAYER_ID, 
    AVG(GDP_GDP_PER_CAPITA_USD)::float as GPI_AVG_GDP_PER_CAPITA, 
    AVG(POP_POPULATION)::float as GPI_AVG_POPULATION, 
    AVG(POP_POPULATION_AGED15_19+POP_POPULATION_AGED20_29)::float as GPI_AVG_POPULATION_AGED_15TO29, 
    ((COUNT(DISTINCT P_PLAYER_ID)*1000000)/AVG(POP_POPULATION))::float as GPI_CNT_PLAYERS_ON_1MIL_POP,
    AVG(I_SHARE_OF_INDIVID_USING_INTERNET)::float as GPI_AVG_SHARE_OF_INDIVIDUALS_USING_INTERNET
FROM PLAYER a
LEFT JOIN COUNTRY c ON upper(P_COUNTRY2CODE)=C_COUNTRY2CODE
LEFT JOIN GDP_PER_CAPITA g ON C_COUNTRY2CODE=GDP_COUNTRY2CODE
LEFT JOIN POPULATION p ON POP_COUNTRY2CODE=C_COUNTRY2CODE
LEFT JOIN INTERNET s ON I_COUNTRY2CODE=C_COUNTRY2CODE
WHERE 
    GDP_GDP_PER_CAPITA_USD is not null 
    -- ALL TABLES NEED TO BE UNIFIED FOR THE SAME PERIOD 1997-2021 (TABLES GDP, POP, INT ARE UP TO 2021)
    AND GDP_YEAR >= 1997 
    AND POP_YEAR >= 1997 
    AND I_YEAR >= 1997
    AND P_PLAYER_ID IN 
        -- SELECT A PLAYER_ID OF EACH TOURNAMENT TO BE HELD BETWEEN 1997 and 2021
        (SELECT DISTINCT TRI_PLAYER_ID AS PLAYERID
        FROM TOURNAMENT_RESULTS_INDIVIDUAL
        WHERE TRI_TOURNAMENT_ID IN 
            (SELECT DISTINCT T_TOURNAMENT_ID FROM TOURNAMENT WHERE YEAR(T_END_DATE) BETWEEN 1997 AND 2021)
            AND TRI_PLAYER_ID < 900000
        UNION
        SELECT DISTINCT TRP_PLAYER_ID AS PLAYERID
        FROM TOURNAMENT_RESULTS_PLAYER_IN_TEAM
        WHERE TRP_TOURNAMENT_ID IN 
        	(SELECT DISTINCT T_TOURNAMENT_ID FROM TOURNAMENT WHERE YEAR(T_END_DATE) BETWEEN 1997 AND 2021))
GROUP BY C_COUNTRY, C_CONTINENT;

-- ---------------------------------------------------------------------------
-- ---------------------------------------------------------------------------
-- similar results, but here are also countries with 0 players, which cannot be retrieved from select above, even if LEFT JOIN is present (i tested it).
-- Also I added RANKS
WITH CTE_POP AS (
SELECT POP_COUNTRY2CODE, POP_YEAR, POP_POPULATION, (POP_POPULATION_AGED15_19+POP_POPULATION_AGED20_29) AS "POP15-29"
FROM POPULATION
WHERE POP_YEAR >= 1997),

CTE_INT AS (
SELECT I_COUNTRY2CODE, I_YEAR, I_SHARE_OF_INDIVID_USING_INTERNET
FROM INTERNET
WHERE I_YEAR >= 1997),

CTE_GDP AS (
SELECT GDP_COUNTRY2CODE, GDP_YEAR, GDP_GDP_PER_CAPITA_USD
FROM GDP_PER_CAPITA
WHERE GDP_YEAR >= 1997),

CTE_PLA AS (
SELECT P_COUNTRY2CODE, P_PLAYER_ID
FROM PLAYER
WHERE P_PLAYER_ID IN 
        -- SELECT A PLAYER_ID OF EACH TOURNAMENT TO BE HELD BETWEEN 1997 and 2021
        (SELECT DISTINCT TRI_PLAYER_ID AS PLAYERID
        FROM TOURNAMENT_RESULTS_INDIVIDUAL
        WHERE TRI_TOURNAMENT_ID IN 
        (SELECT DISTINCT T_TOURNAMENT_ID FROM TOURNAMENT WHERE YEAR(T_END_DATE) BETWEEN 1997 AND 2021)
        AND TRI_PLAYER_ID < 900000
        UNION
        SELECT DISTINCT TRP_PLAYER_ID AS PLAYERID
        FROM TOURNAMENT_RESULTS_PLAYER_IN_TEAM
        WHERE TRP_TOURNAMENT_ID IN 
        (SELECT DISTINCT T_TOURNAMENT_ID FROM TOURNAMENT WHERE YEAR(T_END_DATE) BETWEEN 1997 AND 2021)) 
),

CTE_ONE AS (
SELECT 
C_CONTINENT,
C_COUNTRY, 
COUNT(DISTINCT P_PLAYER_ID) AS CNT_PLAYER, 
AVG(GDP_GDP_PER_CAPITA_USD) AS GDP,
AVG(POP_POPULATION) AS POP, 
AVG("POP15-29") AS "POP15-29", 
AVG(I_SHARE_OF_INDIVID_USING_INTERNET) AS "INT"
FROM COUNTRY
LEFT JOIN CTE_PLA ON C_COUNTRY2CODE=P_COUNTRY2CODE
LEFT JOIN CTE_GDP ON GDP_COUNTRY2CODE=C_COUNTRY2CODE
LEFT JOIN CTE_POP ON POP_COUNTRY2CODE=C_COUNTRY2CODE
LEFT JOIN CTE_INT ON I_COUNTRY2CODE=C_COUNTRY2CODE
GROUP BY C_CONTINENT, C_COUNTRY, AVG_TECH
),

CTE_TWO AS (
SELECT 
C_CONTINENT,
C_COUNTRY, 
CNT_PLAYER, 
CNT_PLAYER*1000000/POP AS CNT_PLAYER_MIL_POP,
GDP,
POP, 
"POP15-29", 
"INT"
FROM CTE_ONE
)

SELECT 
C_CONTINENT,
C_COUNTRY, 
CNT_PLAYER, 
RANK() OVER (ORDER BY CNT_PLAYER DESC NULLS LAST) AS RANK_PLAYER,
CNT_PLAYER_MIL_POP,
RANK() OVER (ORDER BY CNT_PLAYER_MIL_POP DESC NULLS LAST) AS RANK_PLAYER_POP,
GDP,
RANK() OVER (ORDER BY GDP DESC NULLS LAST) AS RANK_GDP,
POP, 
RANK() OVER (ORDER BY POP DESC NULLS LAST) AS RANK_POP,
"POP15-29", 
"INT",
RANK() OVER (ORDER BY "INT" DESC NULLS LAST) AS RANK_INT
FROM CTE_TWO;