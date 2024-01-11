-- I downloaded data via python from different APIs. Because it took dozens of hours, there are up to 20 files for each API that need to be joined using UNION.
-- I knew rows need to be unique, so I used UNION to get rid of unwanted duplicates created when downloading data.
-- The Goal for this phase was to have 1 complete file per API.

-- ----------------------------------------------------------------------------
-- API 01 PLAYER 
CREATE OR REPLACE TEMPORARY table TEMP_01API_PLAYER_UNIONED AS
/*In the source data were some players with two rows which differed only in the WorldRanking or CountryRanking columns. 
I had to remove such duplicates and I chosed smaller (MIN) values for the players (higher/better in the rankings)
The duplicity was across more files, therefore it was necessery uninon all files at first and filter it after that.*/
    SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", MIN("WorldRanking") as "WorldRanking", MIN("CountryRanking") as "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId"
    FROM
            ( 
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_1000-1999" -- 01
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking","TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_2000-5999" -- 02
                UNION 
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_6000-6999" -- 03
                UNION 
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_7000-7999" -- 04
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_8000-9098" -- 05
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_9099-35689" -- 06
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_35690-38532" -- 07
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_38533-68517" -- 08
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_68518-73512" -- 09
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_73513-101790" -- 10
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_101791-104788" -- 11
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_104789-115464" -- 12
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_115465-120432" -- 13
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_120433-124001" -- 14
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_124002-12531" -- 15
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById_125432-149985" -- 16
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById__errorids1" -- 17
                UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01-API-LookupPlayerById__errorids2" -- 18
            )

   GROUP BY "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "TotalUSDPrize", "TotalTournaments", "PlayerId";

-- basic data cleansing
UPDATE TEMP_01API_PLAYER_UNIONED
SET "NameFirst" = TRIM("NameFirst", '-');

UPDATE TEMP_01API_PLAYER_UNIONED
SET "NameFirst" = TRIM("NameFirst", '"'); --" -- in Snowflake have '' and "" two different uses and can be used like this '"'

UPDATE TEMP_01API_PLAYER_UNIONED
SET "NameFirst" = null
WHERE "NameFirst" IN ('-', '', '?', '.') OR lower("NameFirst") = 'null';

UPDATE TEMP_01API_PLAYER_UNIONED
SET "NameLast" = TRIM("NameLast", '-');

UPDATE TEMP_01API_PLAYER_UNIONED
SET "NameLast" = TRIM("NameLast", '‘');

UPDATE TEMP_01API_PLAYER_UNIONED
SET "NameLast" = null
WHERE "NameLast" IN ('-', '', '?', '.') OR lower("NameLast") = 'null';

UPDATE TEMP_01API_PLAYER_UNIONED
SET "CurrentHandle" = null
WHERE "CurrentHandle" IN ('null', '', '-');

UPDATE TEMP_01API_PLAYER_UNIONED
SET "CountryCode" = null
WHERE "CountryCode" IN ('null', '', '-');

UPDATE TEMP_01API_PLAYER_UNIONED
SET "WorldRanking" = null
WHERE "WorldRanking" IN ('', '-') OR lower("WorldRanking") = 'null';

UPDATE TEMP_01API_PLAYER_UNIONED
SET "CountryRanking" = null
WHERE "CountryRanking" IN ('', '-') OR lower("CountryRanking") = 'null';

UPDATE TEMP_01API_PLAYER_UNIONED
SET "TotalUSDPrize" = null
WHERE "TotalUSDPrize" IN ('', '-') OR lower("TotalUSDPrize") = 'null';

UPDATE TEMP_01API_PLAYER_UNIONED
SET "TotalTournaments" = null
WHERE "TotalTournaments" IN ('', '-') OR lower("TotalTournaments") = 'null';

-- duplicate record, which must be deleted
DELETE FROM TEMP_01API_PLAYER_UNIONED
WHERE "WorldRanking" = '2443';
/* This one player has two rows with more than WorldRanking difference (TotalUSDPrize and TotalTournaments)
NameFirst	NameLast	CurrentHandle	CountryCode	WorldRanking	CountryRanking	TotalUSDPrize	TotalTournaments	PlayerId
Adam	    Zouhar	    neofrag	        cz	        2443	        10	            117432.53	    70	                52762
Adam	    Zouhar	    neofrag	        cz	        2417	        10	            119231.28	    71	                52762
*/

DELETE FROM TEMP_01API_PLAYER_UNIONED
WHERE "CurrentHandle" ILIKE '%please delete%';
/*
NameFirst  NameLast	CurrentHandle	          	PlayerId
please	   delete	please delete (duplicate)	59935
please	   delete	please delete	            9195
Please	   Delete	Please delete	            53229
Please	   Delete	Please delete	            65689
please	   delete	please delete (duplicate)	48580
please	   delete	duplicate please delete	    73341
*/

/* create final table without null rows (except collumn
"PlayerId", which is filled even if the player ID does not exists, because 
I was adding IDs automatically in the python scripts)*/
CREATE OR REPLACE table API01_PLAYER 
    SELECT *
    FROM TEMP_01API_PLAYER_UNIONED
    EXCEPT
    SELECT *
    FROM TEMP_01API_PLAYER_UNIONED 
    WHERE "NameFirst" is null 
        AND "NameLast" is null 
        AND "CurrentHandle" is null 
        AND "CountryCode" is null 
        AND "WorldRanking" is null 
        AND "CountryRanking" is null 
        AND "TotalUSDPrize" is null 
        AND "TotalTournaments" is null;

-- ----------------------------------------------------------------------------

-- API 04 GAME

CREATE OR REPLACE TABLE API04_GAME AS
    SELECT * FROM 
        (
        SELECT "GameName", "TotalUSDPrize", "TotalTournaments", "TotalPlayers", "GameId" 
        FROM "04-API-LookupGameById_errorids"
        UNION
        SELECT "GameName", "TotalUSDPrize", "TotalTournaments", "TotalPlayers", "GameId"
        FROM "04-API-LookupGameById_0-1000"
        )
    WHERE NOT
        ("GameName" = ''
        AND "TotalUSDPrize" = ''
        AND "TotalTournaments" = ''
        AND "TotalPlayers" = '');
-- In these files were not null values and also clensing was not needed.

-- ----------------------------------------------------------------------------

-- API 07 TOURNAMENT
CREATE OR REPLACE TEMPORARY TABLE TEMP_07API_TOURNAMENT_UNIONED AS
SELECT * FROM
    (SELECT "GameId", "TournamentName", date("StartDate") as "StartDate", date("EndDate") as "EndDate", "Location", "Teamplay", "TotalUSDPrize", "TournamentId"
    FROM "07-API-LookupTournamentById_1000-1999" -- 01
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_10000-10975" -- 02
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_10976-11262" -- 03
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_11263-11844" -- 04
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_11845-12262" -- 05
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07ToutnamentById_output12263-14358" -- 06
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId"
    FROM "07ToutnamentById_output14359-24358" -- 07
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId"
    FROM "07-API-LookupTournamentById_2000-2999" -- 08
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId"
    FROM "07ToutnamentById_output24359-52708" -- 09
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId"
    FROM "07-API-LookupTournamentById_3000-3999" -- 10
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_4000-4999" -- 11
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_5000-5999" -- 12
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId"
    FROM "07ToutnamentById_output52808-82806" -- 13
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId"
    FROM "07-API-LookupTournamentById_6000-6999" -- 14
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_7000-7999" -- 15
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_8000-8999" -- 16
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId"
    FROM "07-API-LookupTournamentById_9000-9999" -- 17
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId"
    FROM "07-API-LookupTournamentById_errorids" -- 18
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_10975" -- 19
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "TournamentId" 
    FROM "07-API-LookupTournamentById_errorids2" -- 20
);

-- These tournaments were in the "tournament name" called as "please delete, duplicate" etc., but some turnaments with these words was not realy duplicates (just funny names for tournaments). 
-- I decided safe variant with deleting selected tournaments Ids.
DELETE FROM TEMP_07API_TOURNAMENT_UNIONED
WHERE "TournamentId" IN (24694, 39324, 52657, 52742, 52717, 52713, 52711, 52547, 52548, 52658, 52683, 52700, 44995, 28872, 28868, 28876, 42322, 36924, 33885, 42491);
/*
TournamentName	                                                                                    TournamentId
Could you please delete this one? Already published: /6894-duel-of-the-century-viper-vs-jordan-bo21	24694
Please delete duplicate of https://www.esportsearnings.com/tournaments/23271-astronauts-3v3-cup-3	28868
Please Delete duplicate of https://www.esportsearnings.com/tournaments/22423-astronauts-3v3-cup-2	28872
Please delete duplicate of https://www.esportsearnings.com/tournaments/23272-astronauts-3v3-cup-4	28876
please delete (duplicate)	                                                                        33885
delete	                                                                                            36924
DUPLICATE - TO D*ELETE	                                                                            39324
WePlay! Clutch Island (DUPLICATE PAGE to be deleted!)	                                            42322
this tournament needs to b removed, seeing it is a duplicate of "2011 Major League Gaming Pr 
Circuit Providencoe (CoD: Black Ops All Star Free For All)" sorry about that	                    42491
King of the Hippo 8 - DUPLICATE	                                                                    44995
Delete	                                                                                            52547
Delete	                                                                                            52548
Delete	                                                                                            52658
Delete	                                                                                            52683
Delete	                                                                                            52700
Delete	                                                                                            52711
Delete	                                                                                            52713
Delete	                                                                                            52717
Delete	                                                                                            52742
Delete	                                                                                            52657
*/

-- creating a final table  without null rows
CREATE OR REPLACE TABLE API07_TOURNAMENT AS
    SELECT * FROM TEMP_07API_TOURNAMENT_UNIONED
    EXCEPT
    SELECT * FROM TEMP_07API_TOURNAMENT_UNIONED
    WHERE "GameId" is null  
        AND "TournamentName" is null
        AND "StartDate" is null
        AND "EndDate" is null
        AND "Location" is null
        AND "Teamplay" is null
        AND "TotalUSDPrize" is null;

-- correction of incorrect date
UPDATE API07_TOURNAMENT
SET "StartDate" = '2020-05-07'
WHERE "StartDate" = '0202-05-07';


-- ---------------------------------------------------------------------

-- 08 TOURNAMENTS RESULTS FOR INDIVIDUAL PLAYERS

CREATE OR REPLACE TABLE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED AS
SELECT * FROM 
    (
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_teamplay0newids" -- 1
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_1000-1999" -- 2
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_10k-14k" -- 3
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_14k-24k" -- 4
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_2000-2999" -- 5
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_24k-45k" -- 6
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_3000-3999" -- 7
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_4000-4999" -- 8
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_45k-52k" -- 9
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_5000-5999" -- 10
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_52k-64k" -- 11
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_6000-6999" -- 12
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_7000-7999" -- 13
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_8000-8999" -- 14
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_9000-9999" -- 15
        UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08-API-LookupTournamentResultsByTournamentId_ErrorIds1" -- 16
    )
;

-- basic data cleansing
UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "Ranking" = null
WHERE "Ranking" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "RankText" = null
WHERE "RankText" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "TeamId" = null
WHERE "TeamId" = 'NULL' OR "TeamId" = 0 ;

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "TeamName" = null
WHERE "TeamName" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "CountryCode" = null
WHERE "CountryCode" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "ShowLastNameFirst" = null
WHERE "ShowLastNameFirst" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "NameFirst" = null
WHERE "NameFirst" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "NameLast" = null
WHERE "NameLast" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "CurrentHandle" = null
WHERE "CurrentHandle" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "PrizeUSD" = null
WHERE "PrizeUSD" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "PlayerId" = null
WHERE "PlayerId" = 'NULL';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "RankText" = null
WHERE "RankText" IN ('-', '', '?', '.') OR lower("RankText") = 'null';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "TeamName" = null
WHERE "TeamName" IN ('-', '', '?', '.') OR lower("TeamName") = 'null';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "NameFirst" = TRIM("NameFirst", '-');

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "NameFirst" = TRIM("NameFirst", '"'); -- "

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "NameFirst" = null
WHERE "NameFirst" IN ('-', '', '?', '.', '--') OR lower("NameFirst") = 'null';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "NameLast" = TRIM("NameLast", '-');

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "NameLast" = TRIM("NameLast", '‘');

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "NameLast" = null
WHERE "NameLast" IN ('-', '', '?', '.') OR lower("NameLast") = 'null';

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "CurrentHandle" = null
WHERE "CurrentHandle" IN ('null', '', '-');

UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "CountryCode" = null
WHERE "CountryCode" IN ('', '-') OR lower("CountryCode") = 'null';


-- "If a placement is associated with an unknown player, the "CurrentHandle" will be "##UNKNOWN##". 
-- "PlayerId" in this instance is only used to return a unique row for each unknown player and can be discarded."
-- These ids were not unique and they maked trouble with real players IDs. For that reason I add 900 000 to them (max plays ID is about 135 000), 
-- and now I can distinguish them from original IDs, and I can easy filter them from real players by filtering < 900000.
UPDATE TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
SET "PlayerId" = "PlayerId"::int+900000
WHERE "CurrentHandle" = '##UNKNOWN##';


/* create final table without null rows (except collumn
"TournamentId", which is filled even if the tournament ID does not exists, because 
I was adding IDs automatically in the python scripts)*/
CREATE OR REPLACE TABLE API08_TOURNAMENT_RESULTS_INDIVIDUAL AS
    SELECT * 
    FROM TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
EXCEPT
    SELECT * 
    FROM TEMP_API08_TOURNAMENT_RESULTS_INDIVIDUAL_UNIONED
WHERE 
    "Ranking" is null
    AND "RankText" is null
    AND "TeamId" is null
    AND "TeamName" is null
    AND "CountryCode" is null
    AND "PlayerId" is null
    AND "NameFirst" is null
    AND "NameLast"  is null
    AND "CurrentHandle" is null
    AND "ShowLastNameFirst" is null
    AND "PrizeUSD" is null;

-- --------------------------------------------------------------------------------

-- 09 TOURNAMENTS RESULTS FOR TEAMS

CREATE OR REPLACE TEMPORARY TABLE TEMP_API09_TOURNAMENT_RESULTS_TEAM_UNIONED AS
SELECT * FROM 
    (
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "TournamentTeamId", "TournamentTeamName", "PrizeUSD", "UnknownPlayerCount"
    FROM "09TournamentTeamResultsByTournamentID" --1
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "TournamentTeamId", "TournamentTeamName", "PrizeUSD", "UnknownPlayerCount"
    FROM "09TournamentTeamResultsByTournamentId_2" --2
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "TournamentTeamId", "TournamentTeamName", "PrizeUSD", "UnknownPlayerCount"
    FROM "09TournamentTeamResultsBytournamentID_teamplay1newids" --3
    );

-- data cleaning
UPDATE TEMP_API09_TOURNAMENT_RESULTS_TEAM_UNIONED
SET "RankText" = null
WHERE "RankText" IN ('-', '?', '.') OR lower("RankText") = 'null';

UPDATE TEMP_API09_TOURNAMENT_RESULTS_TEAM_UNIONED
SET "TournamentTeamName" = null
WHERE "TournamentTeamName" IN ('-', '?', '.')  OR lower("RankText") = 'null';

UPDATE TEMP_API09_TOURNAMENT_RESULTS_TEAM_UNIONED
SET "TeamId" = null
WHERE "TeamId" = 0;


-- create final table and remove rows where all columns are null
CREATE OR REPLACE TABLE API09_TOURNAMENT_RESULTS_TEAM AS
    SELECT * 
    FROM TEMP_API09_TOURNAMENT_RESULTS_TEAM_UNIONED
EXCEPT 
    SELECT *   
    FROM TEMP_API09_TOURNAMENT_RESULTS_TEAM_UNIONED
    WHERE "Ranking" is null
        AND "RankText" is null
        AND "TeamId" is null
        AND "TeamName" is null
        AND "TournamentTeamId"  is null
        AND "TournamentTeamName" is null
        AND "PrizeUSD" is null
        AND "UnknownPlayerCount" is null;

-- -------------------------------------------------------------------------

-- 10 TOURNAMENT RESULTS FOR PLAYRES IN TEAMS

CREATE OR REPLACE TABLE TEMP_API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM_UNIONED AS
SELECT * FROM 
    (
    SELECT "TournamentId", "TournamentTeamId", "PlayerId", "CountryCode", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst"
    FROM "10-API_LookupTournamentTeamPlayersByTournamentId_1" -- 1
        UNION
    SELECT "TournamentId", "TournamentTeamId", "PlayerId", "CountryCode", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst"
    FROM "10-API_LookupTournamentTeamPlayersByTournamentId_2" -- 2
        UNION
    SELECT "TournamentId", "TournamentTeamId", "PlayerId", "CountryCode", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst"
    FROM "10-API_LookupTournamentTeamPlayersByTournamentId_teamplay1newids" -- 3
    );

-- basic data cleansing
UPDATE TEMP_API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM_UNIONED
SET "NameFirst" = TRIM("NameFirst", '"'); --"  -- in Snowflake have '' and "" two different uses and can be used like this '"'

UPDATE TEMP_API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM_UNIONED
SET "NameFirst" = null
WHERE "NameFirst" IN ('-', '--', '?');

UPDATE TEMP_API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM_UNIONED
SET "NameLast" = null
WHERE "NameLast" IN ('-', '?');

UPDATE TEMP_API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM_UNIONED
SET "NameLast" = TRIM("NameLast", '-');


-- create final table and remove rows where all columns are null
CREATE OR REPLACE TABLE API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM AS
    SELECT * FROM TEMP_API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM_UNIONED
EXCEPT
    SELECT * FROM TEMP_API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM_UNIONED
    WHERE 
            "TournamentTeamId" is null
        AND "PlayerId" is null
        AND "CountryCode" is null
        AND "NameFirst" is null
        AND "NameLast" is null
        AND "CurrentHandle" is null
        AND "ShowLastNameFirst" is null;


-- -------------------------------------------------------------
-- -------------------------------------------------------------
-- -------------------------------------------------------------


-- To scrape players' birth dates, I created an http address for each player. 
-- Http address does not support certain UTF-8 characters (symbols, none ASCII alphabets (Cyrilic, Japanese, Chinese) etc.), 
-- which I had to either replace or remove.

-- Statement to filter unwanted characters:
SELECT 
    LISTAGG(DISTINCT(REGEXP_SUBSTR("CurrentHandle", '[^0-9a-zA-Z]')), '') WITHIN GROUP(ORDER BY REGEXP_SUBSTR("CurrentHandle", '[^0-9a-zA-Z]')) 
    AS UNWANTED_NICKNAME
    LISTAGG(DISTINCT(REGEXP_SUBSTR("NameFirst", '[^0-9a-zA-Z]')), '') WITHIN GROUP(ORDER BY REGEXP_SUBSTR("NameFirst", '[^0-9a-zA-Z]')) 
    AS UNWANTED_FIRSTNAME
    LISTAGG(DISTINCT(REGEXP_SUBSTR("NameLast", '[^0-9a-zA-Z]')), '') WITHIN GROUP(ORDER BY REGEXP_SUBSTR("NameLast", '[^0-9a-zA-Z]')) 
    AS UNWANTED_LASTNAME
FROM API01_PLAYER;


-- creating tabel of http adressses:
-- Step one: handling unwanted characters
-- Unwanted characters are divided to 2 groups. Characters to substitude for another ones (e.g.: ě -> e) or charaters to delete (e.g.: お).
-- For these two groups i TRANSLATE function ideal.
-- There were also special characters, which should be replaced by groups of characters (REPLACE function)
-- ('Æ' -> 'ae', 'ß' -> 'sz', 'ð' -> 'eth', 'æ' -> 'ae')


CREATE OR REPLACE TEMPORARY table TEMP_LINK AS
SELECT 
    "PlayerId", 
    -- for correctness check, I added original collumns (without replacing/deleting changes), but hey are not necessery
    "CurrentHandle",
    RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE("CurrentHandle", '._ ¡ÁÂÃÄÅÇÉÍÐÑÓÖØàáâãäåçèéêëìíîïñòóôõöøùúüýÿāăćČĐēęěİŁłńŇōŚśŜŠšũźŽžưạảấầậắếễệỉịỏỐốồổộờởủứữỳỹňşĺŨŸơǺÈÜûčūŹŻŰǍί"ΑΕΖΙΝΟΣΧΨΩαζουϹЅАБВЕЖИМНОПРСТФШЭавгеикморстухчэяёѕіเᏃᴺɟƧı!#$%&()*+,-./:;<>?@[]{}^_`|~²³¹’†′⁓™ℳ⑦☆♫⚡✨❤、あうえおかがくぐけこごさしじすぜそただちつてでとなにぬねのはぱひふぶへべぺぼまみむもやゆらりるろわアイカクスタデバプマミラワㅤ一丁七万三上不与东严中丶丸久么乌乐九了二于五亚京人今任企体余你佩侃來俊倒傻元光入全兩六兴冠冬冯冰冷凉凌凡凤凯出刀刘初别到剑劣勇勝北十千半卓单南博卧原厨古另叫叮可叶司同向吒吕君听周呵哈哦哩哲唐啊善喝喵嗜嘉嘘嘟囍团国坑坚垫執基塔墙墨夏多夜夢大天失奋奔奶如妖姑娘嫠子季孤宇安宝宮家宸宽宿小少尘就尹尾屁属岩川左已巴布帅希平幸幻幽広庭康弓张弹归影很徐微心忘快念思怠怪总恒悠悲情惊想慌慕懂成我战戦房打托扶拿指挚挽搁搬撬放教整文斗斩新无旧旬时昔星春昱晓晨晴智暑暖暗暮暴曲曼最月朔望朝朧本杀李杰极枉林果枪枫柒柠树核格桃桜梓梦梨棒榆樱橘正歪死毁毕毛気水永江汤汪沐没河波泼泽洋派流浅浩浪浮海涛涵清温渲演漫潇火灵烟烤焕無熊熙燈燕爱牛狗狸狼猪玉王玖环珠理瑶甜生用男疯疾白的皮盒盼真着瞬知石破磊祖神秀秉秋科空站竞章童端笑答米紅紫縱繁红纯罗翔老耐肥肯育胶臭航艾芬花苏若苦英范莫莺菊萧落蘑蘭虎虐虚虫虾蛋蛮蝴行街袁西见言诤请诺谜谨豆賴贺赖赛赫赵超越路跳蹦躺轨轩轻载辉辰运这进迷送逆逗造進遥邢邪邹郎郑郭都酒酱酷醉醒释野金钢银锁锋错长閻闪阳阴阿陆陈陌降随雨雪零雷雾霜青靓静韻项顾领风飞饼馬马驴骄高鬼魏鱼鲨鸡麓麦麻黄黑默黙龍龙龜강게고공괜구국권귤근길김깅꿀나남내노다달둘라러럭레렘로매맥문박발방배백별분상서소손송신심아안애약양열영오용원유윤이임자잔장재전절정조주진최치코콘킁탱팜표프하한핫현홍황=\γηνблнпфшщจᏌᴱẵọ ∩ぁぃいぉきぎずせぞっばびぷぽゃゅょよれをんィウケコッノハフブメルレンー下丨个主乃义之也乱予争云井亦介仔仙代们休会伟伦似位何佳依侠修倍假偶偷傲僧儿先克兒兔兰兽冉再冒军冻准击分利剧力劫势勒勺包化午华卫叁双叔变只号吃合后吐吞呀命咩品哟哥唯唱啥啪嘿四圆在地坤坦城域堂壢壹夕太头奇女妄妹委姛姜姬威字孙孝学孩孽宅客容寂寒寞寻尖尢尤尽居履山屿岁岛島崩崽工巧帝带席帮常干年幼庆底开弟弱强当形得德忆怀性恩恹悪惰意懒户手才扎执扬承技把投拔招掌排摂摳敏斌斯方既日旭旺明是昼晋晒木末机权杉条来杨杯某染柔柚查柳栀栎栖桀案桐桥森椒槌橋欣欧歌步殇比氏汉沉沛油洒洛涯渡港游潭澈濑点烦烬然照爆爷牙牢物狙独猜猫玮球琉琛琪琴瑞瑾璐瓜瓣电痕瘾皂盗省眠睡督睿砂砖碧確福禹离秘等筱简粪糖素索约级纳纸练终给维缘羊美羡群羽者肉胃腾自舞良色艺芒茉茶草荡莉莲菇菜萨蒼蓮薇藏虹蝶血衣袭裡要観觉解訫诚话语谦谷豪贤败贱躁输辞达远迪迭迹逍逸逼道遗酸里鉄鑫钧铁铛铭锥门间限隻雄雏電霖霸霾非面頭颜飘香駿骑骚骨魂魇魔魚鲁鵝鸟鸢鸣鸭鹿黎黒가감개건검경곰관기는늘니대더덕도동뜨렬론머면명모몬미민범베봉브비빈빛사산석선성세수순스승악언연예완우운웅은의인쟁좀종준중지집찮창처천철추캬콩킨탓태택퇴포플혁형호환훈️﻿６ϊКдйьอᎡᴹ❦〃ぇざどぴめ゜ガグゴチトドナネヤ丝乎乔仓伞传作使便像八兼冲凶加压吖员味咪噜噴回园壁士声奈好娇學定对将尔帕帽往怎恋愛戰抱揚故斬旅朽杂栄梧棍様欢欲武汁求沧泫涼深溃源滴炎焰煮特猎猖猛瑜璃甘異直看稚竹第绎義职聖背脑膏膨舍节芷药菌萌葩蓝薄蜂蜜見记貓費贝贼起跑过逊達那邰釣锦镜闭队险陶霞食鹅鹰鼻齐광규균꾼날덱드래록리말무봇살섭솔식와왕위을일제찬콜킬터투트티피헌홀희９őǷɪϻЛาᏩᴀ『オソホロ・世业乡供做停剣助勢吶咻圈巢度桑極歉残泪狂糕糞网翼胀袋说谁間闹顿鼠걀까롤릭메쓰알어잃펀험３ǾรᏆᴍᴛᴜげベリ养应式界茧部바커５ＲĿɴʙ์ᴇ商槍생ｙ\Ȉʟิᴏ彡ｚǝ้⓰ｅŖมｎแ』ƑǃɓτχГДЗЙХЧЯжзыю่ặẻềểỗự°·ĔŦʀιρวⓔ★ツ丂乾亮令仲伪凑凹則动劲勤卡又口台咖啄圣垃她奾妍姐娃娜幡建強彪彼悟拂撒收旋易曾札朱殘沒泉法泰澤煎片狮猩玩珊琳甲百絕羅肿芭莱萊萝营藤蘇补詩詹货贴车轮软还闷陵隨饭騒거교궁네당뚜롱링물보부쌀에엽함＿λϋⓖ▵ボ丘兵凸刹办取吧啡器因圾坎塞师座戏旦昂栉渣湿灣炼珩瓶绮能装裤贏辣钩锅關靠鸽계따람맞북후Ŋʍεⓞ係勁名嗆拙政更纱臨鈈震키？\Ǩύ巽～艮兑', '----aaaaaceidnoooaaaaaaceeeeiiiinoooooouuuyyaaccdeeeillnnosssssuzzzuaaaaaaeeeiioooooooouuuyynsluyoaeuucuzzuai'), 'Æ', 'ae'), 'ß', 'sz'), 'ð', 'eth' ), 'æ', 'ae' ), '-') as NICKNAME, --`
    "NameFirst",
    RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE("NameFirst", '._ ÁÅÇÈÉÍÐÓÖØÞàáâãäåçèéêëìíîïñòóôõöøùúüýþĀāăĄčĐđĒėěğĩīİŁłŅŐőřśŞşŠšũūŽžơưȘșţ̦̣̀́̂̌ẠạảấầẩậắếềễệịọốồổộợừửữỳņżặớờứÂÔÜēęĢģļň"⁬ΑΚАБЕКОгеёı渡?ιвнос​‎‏’辺﻿μдиртίайλοςΝВГДИМСлмỗụự神кь龙', '---aaceeidooodaaaaaaceeeeiiiinoooooouuuydaaaacddeeegiiillnoorsssssuuzzousstaaaaaaaaeeeeioooooouuuynzaoouaoueeggln'), 'Æ', 'ae'), 'ß', 'sz'), 'ð', 'eth' ), 'æ', 'ae' ), '-') AS FIRSTNAME,
    "NameLast",
    RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE("NameLast", '._ ÁÅÇÉÓÖØÚÜàáâãäåçèéêëìíîïñòóôõöøùúüýĀāăąĆćČčĎĐđĒēėęěğģīİļŁłńņňőŘřŚśŞşŠšťũūůűŹźŻżŽžơưșȚțɫ̛̣̀́̂̆̈̌ạấầậắếềểễệịọốồứừữỳ"ΜНШуёı/?\´&ḑ̌̃πбеиặỗờ‎‘’﻿ρйлнέоч#;\σвιακςĶķАБЕИКПРСТХЦаảгзмрстхыю​жкф', '---aaceooouuaaaaaaceeeeiiiinoooooouuuyaaaaccccdddeeeeeggiilllnnnorrsssssstuuuuzzzzzzousttlaaaaaeeeeeiooouuuy'), 'Æ', 'ae'), 'ß', 'sz'), 'ð', 'eth' ), 'æ', 'ae' ), '-') AS LASTNAME,
FROM API01_PLAYER;

/*I created a table of http addresses. 
There were 8 combinations of FIRSTNAME, LASTNAME AND NICKNAME AND its missing variants,
and  names of players from Asia have Last name on the first place, 
which was taken in account in the case of http adresses 
(Special Collumn "ShowLastNameFirst", which was in data from APIs 08 and 10).
It took 10 combinations together */

CREATE OR REPLACE table PLAYER_URL AS
WITH "LastNameFirst" AS (
SELECT DISTINCT "PlayerId" 
FROM (
        SELECT "PlayerId" 
        FROM API08_TOURNAMENT_RESULTS_INDIVIDUAL
        WHERE "ShowLastNameFirst" = 1
            UNION
        SELECT "PlayerId" 
        FROM API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM
        WHERE "ShowLastNameFirst" = 1
    ))

SELECT 
    CASE 
    WHEN NICKNAME is null AND FIRSTNAME is null AND LASTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-')) 
    
    WHEN NICKNAME is null AND FIRSTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', LASTNAME))

    WHEN FIRSTNAME is null AND LASTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME)) 
    
    WHEN NICKNAME is null AND LASTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', FIRSTNAME)) 
    
    WHEN FIRSTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME, '-', LASTNAME))
    
    WHEN LASTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME, '-', FIRSTNAME))
    
    WHEN "PlayerId" IN (SELECT "PlayerId" FROM "LastNameFirst") AND
         NICKNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', LASTNAME, '-', FIRSTNAME)) 
    WHEN "PlayerId" NOT IN (SELECT "PlayerId" FROM "LastNameFirst") AND
         NICKNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', FIRSTNAME, '-', LASTNAME)) 
   
    WHEN "PlayerId" IN (SELECT "PlayerId" FROM "LastNameFirst") 
    -- set of players ids with Last-Name-First is much smaller then the opposite, therefore managing them first is quicker for processing
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME, '-', LASTNAME, '-', FIRSTNAME))
    ELSE lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME, '-', FIRSTNAME, '-', LASTNAME))
        
    END AS "URL",

    "PlayerId"
FROM TEMP_LINK AS TL
JOIN "LastNameFirst" AS L ON TL."PlayerId"=L."PlayerId" ;

-- ------------------------------------------------------------------------------

/* Merging files with birth dates and creating a table with player ID and birth date:
Players with a date of birth greater than 2012 have been excluded, because such dates of birth are probably not filled in correctly 
(There was a real gap in the data between 2013 and 2016. Players born since 2017 would be 6 years old or younger, which is unlikely. 
There were also players born in 2023 in the data, which doesn't really make sense, and it is a misfilled data.) */

CREATE OR REPLACE TABLE PlayerDOB AS
SELECT * FROM
    (
    SELECT 
        "PlayerId", 
        TO_DATE("DateOfBirth", 'MMMM DD, YYYY') as "DateOfBirth", 
        YEAR(TO_DATE("DateOfBirth", 'MMMM DD, YYYY')) as "Year"
    FROM
        (
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth1"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth2"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth3"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateodBirth4"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateodBirth5"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateodBirth6"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateodBirth7"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth08"
            UNION
        SELECT "Url", "DateOfBirth"
            FROM "DateOfBirth09"
        UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth10"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth_errors_1"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth_errors_2"
        )
    JOIN PLAYER_URL p ON "Url"="URL"
    WHERE "DateOfBirth" NOT IN ('<unknown>', '') AND "DateOfBirth" is not null 
    )
WHERE "Year" <= 2012;

-- ---------------------------------------------------------

-- When downloading data from the API, various errors occurred during the download and some data had to be downloaded again
-- I created lists of IDs to be re-downloaded in python. Sometimes this had to be repeated for newly downloaded (error) IDs.

CREATE OR REPLACE TABLE GAMEBYID_ERRORIDS AS
SELECT "GameId"
FROM "04-API-LookupGameById_0-1000"
WHERE "ErrorCode" != '';

CREATE OR REPLACE TABLE TOURNAMENTERRORIDS AS
    SELECT "TournamentId"
    FROM "07-API-LookupTournamentById_1000-1999"
    WHERE "ErrorCode" != '' OR "ErrorCode" is not null
UNION
    SELECT "TournamentId" FROM "07ToutnamentById_14359-24358_novecsv"
    WHERE "Error" != '' OR "Error" is not null
UNION
    SELECT "TournamentId" FROM "07ToutnamentById_24359-52708_novecsv"
    WHERE "ErrorCode" != '' OR "Error" != '' OR "ErrorCode" is not null OR "Error" is not null
UNION
    SELECT "TournamentId" FROM "07ToutnamentById_52808-82806_novecsv"
    WHERE "ErrorCode" != '' OR "Error" != '' OR "ErrorCode" is not null OR "Error" is not null
ORDER BY "TournamentId";


CREATE OR REPLACE TABLE DOB_ERRORS AS
SELECT * FROM
        (
        SELECT "Url", "DateOfBirth", NULL as "Error"
        FROM "DateOfBirth1"
        UNION
        SELECT "Url", "DateOfBirth", NULL as "Error"
        FROM "DateOfBirth2"
        UNION
        SELECT "Url", "DateOfBirth", "Error"
        FROM "DateOfBirth3"
        UNION
        SELECT "Url", "DateOfBirth", "Error"
        FROM "DateodBirth4"
        UNION
        SELECT "Url", "DateOfBirth", "Error"
        FROM "DateodBirth5"
        UNION
        SELECT "Url", "DateOfBirth", "Error"
        FROM "DateodBirth6"
        UNION
        SELECT "Url", "DateOfBirth", "Error"
        FROM "DateodBirth7"
        UNION
        SELECT "Url", "DateOfBirth", "Error"
        FROM "DateOfBirth08"
        UNION
        SELECT "Url", "DateOfBirth", "Error"
        FROM "DateOfBirth09"
        UNION
        SELECT "Url", "DateOfBirth", "Error"
        FROM "DateOfBirth10"
        )
WHERE "Error" is not null AND "Error" != '';


CREATE OR REPLACE TABLE DOB_ERRORS_2 AS
SELECT "Url", "Error"
FROM "DateOfBirth_errors_1"
WHERE "Error" is not null AND "Error" != '';
