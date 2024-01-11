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
