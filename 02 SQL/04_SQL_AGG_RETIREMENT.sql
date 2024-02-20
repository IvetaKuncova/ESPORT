-- AGGREGATED DENORMALIZED TABLES FOR PLAYERS RETIREMENT STATISTICS IN TABLEAU

/* ===== temporary table 1 ===== */
CREATE OR REPLACE TEMPORARY TABLE TEMP01_PLA_GAME_YEAR AS
-- join of the select below with the TOURNAMENT table for collums YEAR OF TOURNAMENT and GAME_ID
SELECT 
TOURNAMENT_ID::int AS TOURNAMENT_ID, 
PLAYER_ID::int AS PLAYER_ID, 
SUM(PRIZE::float) AS SUM_PRIZE, 
YEAR(T_END_DATE)::int as YEAR_OF_TOURNAMENT, 
T_GAME_ID::int AS GAME_ID
FROM
    (
    -- union of TOURNAMENT_RESULTS_INDIVIDUAL and TOURNAMENT_RESULTS_PLAYER_IN_TEAM tables
    SELECT 
        TRI_PLAYER_ID::int AS PLAYER_ID,
        TRI_PRIZE_USD::float AS PRIZE,
        TRI_TOURNAMENT_ID::int AS TOURNAMENT_ID
    FROM TOURNAMENT_RESULTS_INDIVIDUAL
    -- PLAYER_IDs greater than 900,000 are not real IDs, 
    -- they only serve as a placeholder to keep track of the number of players and their winnings when the player is unknown.
    WHERE TRI_PLAYER_ID < 900000 
    
    UNION ALL

    SELECT 
        TRP_PLAYER_ID::int AS PLAYER_ID,
        TRP_PRIZE_USD_FOR_PLAYER::float AS PRIZE,
        TRP_TOURNAMENT_ID::int AS TOURNAMENT_ID
    FROM TOURNAMENT_RESULTS_PLAYER_IN_TEAM
    ) AS AAA -- 315 520

JOIN TOURNAMENT ON AAA.TOURNAMENT_ID=T_TOURNAMENT_ID
GROUP BY TOURNAMENT_ID, PLAYER_ID, YEAR_OF_TOURNAMENT, GAME_ID; -- 306 591

/* ===== temporary table 2 ===== */
-- WHAT IS THE AVERAGE, MEDIAN AND QUANTILE VALUE FOR A GAME?    
CREATE OR REPLACE TEMPORARY TABLE TEMP02_AVG_MED_QUA_PERGAME AS
WITH cte AS (
SELECT PLAYER_ID, GAME_ID, SUM(SUM_PRIZE) as SUM2_PRIZE
FROM TEMP01_PLA_GAME_YEAR
GROUP BY PLAYER_ID, GAME_ID) 

SELECT 
GAME_ID, 
AVG(SUM2_PRIZE) as AVG_PRIZE_FOR_GAME, 
MEDIAN(SUM2_PRIZE) as MED_PRIZE_FOR_GAME, 
PERCENTILE_CONT( 0.9 ) WITHIN GROUP (ORDER BY SUM2_PRIZE) as QUA09_PRIZE_FOR_GAME
FROM cte
GROUP BY GAME_ID
ORDER BY GAME_ID; -- 853

/* ===== temporary table 3 ===== */
-- Dividing players_id into 2 categories >= OR < than AVG, MED, QUA.
-- Merge TABLE with TEMP01_PLA_GAME_YEAR and TEMP02_AVG_MED_QUA_PERGAME
-- add columns if PRIZE >= AVG, MED, AUA PER GAME

CREATE OR REPLACE TEMPORARY TABLE TEMP03_PLAYER_GAME_AVG_MED_QUA AS
WITH CTE_UNIK AS (
SELECT pp.GAME_ID, pp.PLAYER_ID, SUM(pp.SUM_PRIZE) AS SUM2_PRIZE
FROM TEMP01_PLA_GAME_YEAR pp
GROUP BY pp.GAME_ID, pp.PLAYER_ID)

SELECT c.GAME_ID, PLAYER_ID, SUM2_PRIZE,
    CASE WHEN SUM2_PRIZE >= QUA09_PRIZE_FOR_GAME THEN 1
        ELSE 0
        END as ISMORETHAN_QUA,
    CASE WHEN SUM2_PRIZE >= AVG_PRIZE_FOR_GAME THEN 1
        ELSE 0
        END as ISMORETHAN_AVG, 
    CASE WHEN SUM2_PRIZE >= MED_PRIZE_FOR_GAME THEN 1
        ELSE 0
        END as ISMORETHAN_MED
FROM CTE_UNIK c
JOIN TEMP02_AVG_MED_QUA_PERGAME a ON a.GAME_ID = c.GAME_ID
WHERE SUM2_PRIZE is not null
ORDER BY PLAYER_ID, c.GAME_ID, SUM2_PRIZE DESC;

-- 79 527 rows

/* the TEMP03_PLAYER_GAME_AVG_MED_QUA table shows that MEDIAN is not suitable for our purposes,
because it divides the players ca into two halves (48.8 % and 51.2 %). 
The average and quantile are relatively similar, the quantile is more in line with our idea, 
so we only work with the quantile below.
The average divides the players into 82.8 % and 17.2 %
The quantile divides the players into 89.4 % and 10.6 %
Percentages should be viewed with the understanding that this is a rough preview that does not take into account fact, 
that the players are always in the source table broken down by a game. */

-- QUANTILE
-- SELECT COUNT(PLAYER_ID)
-- FROM TEMP03_PLAYER_GAME_AVG_MED_QUA
-- WHERE ISMORETHAN_QUA = 1; -- 8 216 = 10,6 %
-- SELECT COUNT(PLAYER_ID)
-- FROM TEMP03_PLAYER_GAME_AVG_MED_QUA
-- WHERE ISMORETHAN_QUA = 0; -- 69 081 = 89,37 %

-- AVERAGE
-- SELECT COUNT(PLAYER_ID)
-- FROM TEMP03_PLAYER_GAME_AVG_MED_QUA
-- WHERE ISMORETHAN_AVG = 1; -- 13 295 = 17,2 %
-- SELECT COUNT(PLAYER_ID)
-- FROM TEMP03_PLAYER_GAME_AVG_MED_QUA
-- WHERE ISMORETHAN_AVG = 0; -- 64 002 = 82,8 %

-- MEDIAN
-- SELECT COUNT(PLAYER_ID)
-- FROM TEMP03_PLAYER_GAME_AVG_MED_QUA
-- WHERE ISMORETHAN_MED = 1; -- 39 607 = 51,24 %
-- SELECT COUNT(PLAYER_ID)
-- FROM TEMP03_PLAYER_GAME_AVG_MED_QUA
-- WHERE ISMORETHAN_MED = 0; -- 37 690 = 48,76 %


/* ===== table 1 ===== */

CREATE OR REPLACE TABLE WHOSEARLYERRETIRED_KVA AS
WITH CTE_WHOSEARLYERRETIRED_QUA AS (
SELECT 
    T4_GAME_ID::int AS GAME_ID,
    T4_GAME_NAME AS GAME_NAME,  
    T4_RANK_PRIZE_USD::int AS RANK_PRIZE_USD,
    T4_RANK_CNT_TOURNAMENTS::int AS RANK_CNT_TOURNAMENTS,
    T4_RANK_CNT_PLAYERS::int AS RANK_CNT_PLAYERS,
    T4_ISMORETHAN_QUA::int AS ISMORETHAN_QUA,
    COUNT(DISTINCT T4_PLAYER_ID::int) AS CNT_PLAYER,
    SUM(T4_SUM2_PRIZE_USD)::float AS SUM_PRIZE_USD,
    AVG(T4_CNT_YEAR_OF_TOURNAMENT)::float AS AVG_YEARS
FROM 
------------------------------------------------------------------  b
    (
    SELECT
        T3_GAME_ID AS T4_GAME_ID,
        T3_GAME_NAME AS T4_GAME_NAME,
        T3_RANK_PRIZE_USD AS T4_RANK_PRIZE_USD,
        T3_RANK_CNT_TOURNAMENTS AS T4_RANK_CNT_TOURNAMENTS,
        T3_RANK_CNT_PLAYERS AS T4_RANK_CNT_PLAYERS,
        COUNT(DISTINCT T3_TOURNAMENT_ID) AS T4_CNT_TOURNAMENTS, -- how many tournaments has played each player
        COUNT(DISTINCT T3_YEAR_OF_TOURNAMENT) AS T4_CNT_YEAR_OF_TOURNAMENT, -- how many years the player played
        -- here is not correct to COUNT PLAYERS. I needed to know, how many years !every! player played tournaments
        T3_PLAYER_ID AS T4_PLAYER_ID,
        SUM(T3_SUM_PRIZE_USD) AS T4_SUM2_PRIZE_USD,
        ISMORETHAN_QUA AS T4_ISMORETHAN_QUA
    FROM
------------------------------------------------------------------  a
        (
        SELECT 
            t1.TOURNAMENT_ID AS T3_TOURNAMENT_ID,
            t1.YEAR_OF_TOURNAMENT AS T3_YEAR_OF_TOURNAMENT,
            t1.PLAYER_ID AS T3_PLAYER_ID,
            SUM(t1.SUM_PRIZE) AS T3_SUM_PRIZE_USD,
            t1.GAME_ID AS T3_GAME_ID,
            t2.G_GAME_NAME AS T3_GAME_NAME,
            t2.G_RANK_PRIZE_USD AS T3_RANK_PRIZE_USD,
            t2.G_RANK_CNT_TOURNAMENTS AS T3_RANK_CNT_TOURNAMENTS,
            t2.G_RANK_CNT_PLAYERS AS T3_RANK_CNT_PLAYERS
        FROM TEMP01_PLA_GAME_YEAR t1 
        JOIN GAME t2 ON t2.G_GAME_ID=T3_GAME_ID
        GROUP BY     
            T3_GAME_ID,
            T3_GAME_NAME,
            T3_RANK_PRIZE_USD,
            T3_RANK_CNT_TOURNAMENTS,
            T3_RANK_CNT_PLAYERS,
            T3_TOURNAMENT_ID,
            T3_YEAR_OF_TOURNAMENT,
            T3_PLAYER_ID
        ) t3 -- 306 541
------------------------------------------------------------------  a
    JOIN TEMP03_PLAYER_GAME_AVG_MED_QUA t5 ON t5.GAME_ID=T4_GAME_ID AND t5.PLAYER_ID=T4_PLAYER_ID    
    GROUP BY
        T4_GAME_ID,
        T4_GAME_NAME,
        T4_RANK_PRIZE_USD,
        T4_RANK_CNT_TOURNAMENTS,
        T4_RANK_CNT_PLAYERS,
        T4_PLAYER_ID,
        T4_ISMORETHAN_QUA
    ) t4 -- 79 504
------------------------------------------------------------------  b
GROUP BY 
    GAME_ID,
    GAME_NAME,
    RANK_PRIZE_USD,
    RANK_CNT_TOURNAMENTS,
    RANK_CNT_PLAYERS,
    ISMORETHAN_QUA
ORDER BY GAME_ID, ISMORETHAN_QUA
) -- 1031

SELECT 
    GAME_ID AS W_GAME_ID, 
    GAME_NAME AS W_GAME_NAME, 
    RANK_PRIZE_USD AS W_RANK_PRIZE_USD,
    RANK_CNT_TOURNAMENTS AS W_RANK_CNT_TOURNAMENTS,
    RANK_CNT_PLAYERS AS W_RANK_CNT_PLAYERS,
    ISMORETHAN_QUA AS W_ISMORETHAN_QUA,  
    CNT_PLAYER AS W_CNT_PLAYERS, 
    AVG_YEARS AS W_AVG_CNT_YEARS, 
    SUM_PRIZE_USD AS W_SUM_PRIZE_USD
FROM CTE_WHOSEARLYERRETIRED_QUA
WHERE W_GAME_ID IN 
        (SELECT DISTINCT GAME_ID FROM
            (
            SELECT GAME_ID, SUM(CNT_PLAYER) AS SUM_PLAYERS
            FROM CTE_WHOSEARLYERRETIRED_QUA
            GROUP BY GAME_ID
            HAVING SUM_PLAYERS >=100
            )
        );

-- 252 rows
        
/* ===== table 2 ===== */
/* it was necessary (for the desired visualizations in Tableau) to transform the table that each column is split into two, 
depending on whether W_ISMORETHAN_QUA = 1 or 0. */
CREATE OR REPLACE TABLE WHOSEARLYERRETIRED_KVA_ROWS AS
SELECT
    W_GAME_ID, 
    W_GAME_NAME, 
    SUM(IFNULL(CTN_PLAYERS_0,0)) AS CTN_PLAYERS_0,
    SUM(IFNULL(CTN_PLAYERS_1,0)) AS CTN_PLAYERS_1,
    SUM(IFNULL(SUM_PRIZE_USD_1,0)) AS SUM_PRIZE_USD_1,
    SUM(IFNULL(W_AVG_CNT_YEARS_0,0)) AS W_AVG_CNT_YEARS_0,
    SUM(IFNULL(W_AVG_CNT_YEARS_1,0)) AS W_AVG_CNT_YEARS_1
FROM
    (SELECT 
        W_GAME_ID, 
        W_GAME_NAME,
        0 AS CTN_PLAYERS_0, 
        W_CNT_PLAYERS AS CTN_PLAYERS_1,
        0 AS SUM_PRIZE_USD_0,
        W_SUM_PRIZE_USD AS SUM_PRIZE_USD_1, 
        0 AS W_AVG_CNT_YEARS_0,
        W_AVG_CNT_YEARS AS W_AVG_CNT_YEARS_1 
    FROM WHOSEARLYERRETIRED_KVA 
    WHERE W_ISMORETHAN_QUA = 1
    UNION
    SELECT 
        W_GAME_ID, 
        W_GAME_NAME,
        W_CNT_PLAYERS AS CTN_PLAYERS_0, 
        0 AS CTN_PLAYERS_1,
        W_SUM_PRIZE_USD AS SUM_PRIZE_USD_0, 
        0 AS SUM_PRIZE_USD_1,
        W_AVG_CNT_YEARS AS W_AVG_CNT_YEARS_0,
        0 AS W_AVG_CNT_YEARS_1
    FROM WHOSEARLYERRETIRED_KVA 
    WHERE W_ISMORETHAN_QUA = 0)
GROUP BY W_GAME_ID, W_GAME_NAME
ORDER BY W_GAME_ID;

/* ===== table 3 ===== */
-- table of maximum age of players for games

CREATE OR REPLACE TABLE WHOSEARLYERRETIRED_MAXAGE AS
WITH CTE_PDAK AS (
-- table with players, their's dates of birth, age on the year, when tournament has been held, and category of a player in Quantile
SELECT 
    pp.TOURNAMENT_ID, 
    pp.YEAR_OF_TOURNAMENT, 
    pp.GAME_ID, 
    pp.PLAYER_ID, 
    P_BIRTH_YEAR AS YEAR_OF_BIRTH, 
    pp.YEAR_OF_TOURNAMENT - P_BIRTH_YEAR AS AGE_ON_TOURNAMENT_YEAR, 
    pp.SUM_PRIZE, 
    CASE WHEN pp.SUM_PRIZE >= QUA09_PRIZE_FOR_GAME THEN 1
    	ELSE 0
    	END as ISMORETHAN_QUA
FROM TEMP01_PLA_GAME_YEAR pp
JOIN PLAYER ON pp.PLAYER_ID = P_PLAYER_ID
JOIN TEMP02_AVG_MED_QUA_PERGAME a ON a.GAME_ID = pp.GAME_ID
WHERE P_BIRTH_YEAR is not null
)
-- selecting games and it's average years, when players were playing it on tournaments and  maximum age of players for the game
SELECT 
    x.GAME_ID::int AS W_GAME_ID, 
    G_GAME_NAME AS W_GAME_NAME, 
    x.ISMORETHAN_QUA::int AS W_ISMORETHAN_QUA,  
    COUNT(DISTINCT x.PLAYER_ID)::int as W_CTN_PLAYERS, 
    AVG(CNT_AGE)::float as W_AVG_CNT_YEARS, 
    MAX(MAX_AGE)::int as W_MAX_AGE,
    AVG(AVG_AGE) as W_AVG_AGE, 
    MIN(MIN_AGE) as W_MIN_AGE
FROM
    -- selecting players and their's max age and number of years they have played tournaments
    (
    SELECT 
        GAME_ID, 
        PLAYER_ID, 
        COUNT(DISTINCT AGE_ON_TOURNAMENT_YEAR) as CNT_AGE, 
        MAX(AGE_ON_TOURNAMENT_YEAR) as MAX_AGE, 
        AVG(AGE_ON_TOURNAMENT_YEAR) as AVG_AGE, 
        MIN(AGE_ON_TOURNAMENT_YEAR) as MIN_AGE, 
        SUM(SUM_PRIZE) as SUM2_PRIZE, 
        ISMORETHAN_QUA
    FROM CTE_PDAK 
    GROUP BY GAME_ID, PLAYER_ID, ISMORETHAN_QUA 
    ) x 
JOIN GAME g ON G_GAME_ID=x.GAME_ID
GROUP BY x.GAME_ID, G_GAME_NAME, x.ISMORETHAN_QUA
ORDER BY x.GAME_ID, G_GAME_NAME, x.ISMORETHAN_QUA DESC;

/* ===== table 4 ===== */
-- just a control table for a distribution of players in their years played 
CREATE OR REPLACE TABLE WHOSEARLIERRETIRED_PLAYERSBYYEARS AS
SELECT 
    x.ISMORETHAN_QUA::int AS ISMORETHAN_QUA,
    CNT_YEARS,
    COUNT(DISTINCT x.PLAYER_ID)::int as CTN_PLAYERS
FROM
    (
    SELECT 
        tityp.GAME_ID, 
        tityp.PLAYER_ID, 
        tityp.CNT_YEARS, 
        SUM(SUM2_PRIZE) AS SUM3_PRIZE, 
        ISMORETHAN_QUA, 
        tityp.CNT_TOURNAMENTS
    FROM
        (
        SELECT 
            GAME_ID, 
            PLAYER_ID, 
            COUNT(DISTINCT YEAR_OF_TOURNAMENT) AS CNT_YEARS, 
            COUNT(DISTINCT TOURNAMENT_ID) AS CNT_TOURNAMENTS
        FROM TEMP01_PLA_GAME_YEAR
        GROUP BY GAME_ID, PLAYER_ID
        ) tityp
     JOIN TEMP03_PLAYER_GAME_AVG_MED_QUA tg ON tg.GAME_ID=tityp.GAME_ID AND tg.PLAYER_ID=tityp.PLAYER_ID
     GROUP BY tityp.GAME_ID, tityp.PLAYER_ID, tityp.CNT_YEARS, tityp.CNT_TOURNAMENTS, ISMORETHAN_QUA
   ) x 
GROUP BY ISMORETHAN_QUA, CNT_YEARS
ORDER BY ISMORETHAN_QUA, CNT_YEARS DESC;

/*
ISMORETHAN_KVA	CNT_YEARS	CTN_PLAYERS
1	            22	        1
1	            17	        3
1	            16	        5
1	            14	        13
(...)
0	            3	        3710
1	            3	        1365
0	            2	        11060
1	            2	        1476
0	            1	        47842
1	            1	        1917
*/

/* ===== bonus select  ===== */
-- how old are the players today (result on 11/2023)
SELECT COUNT(DISTINCT P_PLAYER_ID) as CNT_PLAYERS, DATEDIFF( YEAR, P_DATE_OF_BIRTH, CURRENT_DATE()) AS AGE 
FROM PLAYER
WHERE P_DATE_OF_BIRTH is not null
GROUP BY AGE
ORDER BY CNT_PLAYERS DESC;

/*
CNT_PLAYERS	    AGE
1091	        24
1045	        23
987	            22
950	            25
888	            26
875	            21
762	            27
676	            28
621	            29
593	            20
567	            30
507	            31
(...)
1	            70
1	            12
1	            75
1	            67
1	            71
*/ 

-- how old the players are when they are still actively playing (range)

    SELECT AVG(MINAGE) AS AVG_MIN_AGE, AVG(MAXAGE) AS AVG_MAX_AGE
    FROM
        (SELECT DISTINCT PLAYER_ID, MIN(AGEINYEAROFTOURNAMENT) AS MINAGE, MAX(AGEINYEAROFTOURNAMENT) AS MAXAGE
        FROM
            (SELECT PLAYER_ID, YEAR(T_END_DATE) AS YEAROFTOURNAMENT,
            DATEDIFF(YEAR, P_DATE_OF_BIRTH, T_END_DATE) AS AGEINYEAROFTOURNAMENT 
            FROM
                (SELECT TRI_PLAYER_ID AS PLAYER_ID, TRI_TOURNAMENT_ID AS TOURNAMENT_ID
                FROM TOURNAMENT_RESULTS_INDIVIDUAL
                UNION ALL
                SELECT TRP_PLAYER_ID AS PLAYER_ID, TRP_TOURNAMENT_ID AS TOURNAMENT_ID
                FROM TOURNAMENT_RESULTS_PLAYER_IN_TEAM)
            LEFT JOIN TOURNAMENT ON TOURNAMENT_ID=T_TOURNAMENT_ID
            JOIN PLAYER ON PLAYER_ID=P_PLAYER_ID
            WHERE P_DATE_OF_BIRTH is not null
            ORDER BY PLAYER_ID
            )
        GROUP BY PLAYER_ID
        )
;

/*
AVG_MIN_AGE	AVG_MAX_AGE
20.809902	23.535710
*/
----------------
SELECT 
t01.GAME_ID::int AS GAME_ID,
G_GAME_NAME AS GAME_NAME,
G_RANK_PRIZE_USD,
COUNT(DISTINCT t01.TOURNAMENT_ID::int) AS CNT_TOURNAMENTS, 
COUNT(DISTINCT t01.YEAR_OF_TOURNAMENT) AS CNT_YEARS,
COUNT(DISTINCT t01.PLAYER_ID::int) AS CNT_PLAYERS
FROM TEMP01_PLA_GAME_YEAR t01
JOIN GAME g ON t01.GAME_ID=G_GAME_ID
GROUP BY t01.GAME_ID, GAME_NAME, G_RANK_PRIZE_USD
ORDER BY CNT_YEARS DESC;

/*
GAME_ID GAME_NAME                       G_RANK_PRIZE_USD    CNT_TOURNAMENTS     CNT_YEARS   CNT_PLAYERS
179	    Age of Empires II	            56	                1246	            24	        1203
204	    Super Smash Bros. Melee	        45	                2298	            22	        1706
152	    StarCraft: Brood War	        27	                515	                21	        631
166	    Super Street Fighter II Turbo	347	                50	                20	        114
178	    Age of Mythology	            197	                241	                20	        190
158	    WarCraft III	                35	                1456	            19	        672
510	    Age of Empires	                137	                146	                19	        279
194	    Marvel vs. Capcom 2	            318	                26	                18	        68
167	    Street Fighter III: 3rd Strike	288	                42	                18	        108
177	    Age of Empires III	            223	                144	                16	        123
162	    Counter-Strike	                18	                535	                15	        2675
330	    Super Smash Bros.	            259	                107	                15	        214
195	    Capcom vs. SNK 2	            353	                20	                14	        38
151	    StarCraft II	                8	                7175	            14	        2168
532	    iRacing.com	                    53	                121	                14	        859
205	    Super Smash Bros. Brawl	        169	                329	                14	        494
(...)
*/