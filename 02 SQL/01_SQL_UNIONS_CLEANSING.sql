-- We downloaded data from different APIs. Because it took dozens of hours, there are xx files for each API that need to be joined using UNION.

-- API PLAYER 

-- we know that rows need to be unique, so we use UNION to get rid of unwanted duplicates created when downloading data.

CREATE OR REPLACE TEMPORARY table TEMP_APIPLAYERBYIDCOMPLETETABLE AS
-- in the source data there were players with different records that differed only in the WorldRanking and CountryRanking columns. 
-- We had to remove such duplicates and we chosed smaller values for the players (higher/better in the rankings)
    SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", MIN("WorldRanking") as "WorldRanking", MIN("CountryRanking") as "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid"
    FROM
            ( 
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup001000-1999" -- 01
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking","TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup002000-5999" -- 02
            UNION 
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup006000-6999" -- 03
            UNION 
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup007000-7999" -- 04
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup008000-9098" -- 05
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup009099-35689" -- 06
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup035690-38532" -- 07
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup038533-68517_novecsv" -- 08
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup068518-73512" -- 09
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup073513-101790" -- 10
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup101791-104788" -- 11
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup104789-115464" -- 12
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup115465-120432" -- 13
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup120433-124001" -- 14
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01PlayerById_vystup124002-12531_novecsv" -- 15
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup125432-149985" -- 16
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "playerid" 
            FROM "01PlayerById_vystup_errorid" -- 17
            UNION
            SELECT "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "WorldRanking", "CountryRanking", "TotalUSDPrize", "TotalTournaments", "PlayerId" 
            FROM "01PlayerById_vystup_errorids2" -- 18
            )

   GROUP BY "NameFirst", "NameLast", "CurrentHandle", "CountryCode", "TotalUSDPrize", "TotalTournaments", "playerid";

-- basic data cleansing
UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "NameFirst" = TRIM("NameFirst", '-');

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "NameFirst" = TRIM("NameFirst", '"'); --"

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "NameFirst" = null
WHERE "NameFirst" IN ('-', '', '?', '.') OR lower("NameFirst") = 'null';

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "NameLast" = TRIM("NameLast", '-');

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "NameLast" = TRIM("NameLast", '‘');

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "NameLast" = null
WHERE "NameLast" IN ('-', '', '?', '.') OR lower("NameLast") = 'null';

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "CurrentHandle" = null
WHERE "CurrentHandle" IN ('null', '', '-');

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "CountryCode" = null
WHERE "CountryCode" IN ('null', '', '-');

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "WorldRanking" = null
WHERE "WorldRanking" IN ('', '-') OR lower("WorldRanking") = 'null';

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "CountryRanking" = null
WHERE "CountryRanking" IN ('', '-') OR lower("CountryRanking") = 'null';

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "TotalUSDPrize" = null
WHERE "TotalUSDPrize" IN ('', '-') OR lower("TotalUSDPrize") = 'null';

UPDATE TEMP_APIPLAYERBYIDCOMPLETETABLE
SET "TotalTournaments" = null
WHERE "TotalTournaments" IN ('', '-') OR lower("TotalTournaments") = 'null';

-- duplicate record, must be deleted
DELETE FROM TEMP_APIPLAYERBYIDCOMPLETETABLE
WHERE "WorldRanking" = '2443';

DELETE FROM TEMP_APIPLAYERBYIDCOMPLETETABLE
WHERE "CurrentHandle" ILIKE '%please delete%';

-- create final table without null rows
CREATE OR REPLACE table APIPLAYERBYIDCOMPLETETABLE AS 
    SELECT *
    FROM TEMP_APIPLAYERBYIDCOMPLETETABLE
    EXCEPT
    SELECT *
    FROM TEMP_APIPLAYERBYIDCOMPLETETABLE 
    WHERE "NameFirst" is null 
        AND "NameLast" is null 
        AND "CurrentHandle" is null 
        AND "CountryCode" is null 
        AND "WorldRanking" is null 
        AND "CountryRanking" is null 
        AND "TotalUSDPrize" is null 
        AND "TotalTournaments" is null;

-- ----------------------------------------------------------------------------

-- API GAME

CREATE OR REPLACE TABLE GAMEBYID_COMPLETE_DATASET AS
    SELECT * FROM (
        SELECT "GameName", "TotalUSDPrize", "TotalTournaments", "TotalPlayers", "GameId" as "gameid"
        FROM "04GameById_vystup_errorids"
        UNION
        SELECT "GameName", "TotalUSDPrize", "TotalTournaments", "TotalPlayers", "gameid"
        FROM "04LookupGameById_vystup0-1000")
    WHERE NOT
        ("GameName" = ''
        AND "TotalUSDPrize" = ''
        AND "TotalTournaments" = ''
        AND "TotalPlayers" = '');

-- ----------------------------------------------------------------------------

-- API TOURNAMENT

CREATE OR REPLACE TEMPORARY TABLE TEMP_TOURNAMENTBYID_COMPLETEDATASET AS
SELECT * FROM
    (SELECT "GameId", "TournamentName", date("StartDate") as "StartDate", date("EndDate") as "EndDate", "Location", "Teamplay", "TotalUSDPrize", "tournamentid"
    FROM "07TournamentById_vystup1000-1999"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07TournamentById_vystup10000-10975"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07TournamentById_vystup10976-11262"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07TournamentById_vystup11263-11844"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07TournamentById_vystup11845-12262"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07ToutnamentById_vystup12263-14358_novecsv"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid"
    FROM "07ToutnamentById_vystup14359-24358_novecsv"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid"
    FROM "07TournamentById_vystup2000-2999"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid"
    FROM "07ToutnamentById_vystup24359-52708_novecsv"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid"
    FROM "07TournamentById_vystup3000-3999"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07TournamentById_vystup4000-4999"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07TournamentById_vystup5000-5999"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid"
    FROM "07ToutnamentById_vystup52808-82806_novecsv"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid"
    FROM "07TournamentById_vystup6000-6999"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07TournamentById_vystup7000-7999"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07TournamentById_vystup8000-8999"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid"
    FROM "07TournamentById_vystup9000-9999"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid"
    FROM "07TournamnebtByID_errorids"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "TournamentById_vystup10975"
    UNION
    SELECT "GameId", "TournamentName", date("StartDate"), date("EndDate"), "Location", "Teamplay", "TotalUSDPrize", "tournamentid" 
    FROM "07TournamentsById_vystup_errorids2"
);

-- these tournaments were in the "tournament name" called as "please delete, duplicate" etc., but some turnaments with these words was not realy duplicates (just funny names for tournaments). 
-- So we decided safe variant with deleting selected tournaments Ids.
DELETE FROM TEMP_TOURNAMENTBYID_COMPLETEDATASET
WHERE "tournamentid" = 24694 
    OR "tournamentid" = 39324
    OR "tournamentid" = 52657
    OR "tournamentid" = 52742
    OR "tournamentid" = 52717
    OR "tournamentid" = 52713
    OR "tournamentid" = 52711
    OR "tournamentid" = 52547
    OR "tournamentid" = 52548
    OR "tournamentid" = 52658
    OR "tournamentid" = 52683
    OR "tournamentid" = 52700
    OR "tournamentid" = 44995
    OR "tournamentid" = 28872
    OR "tournamentid" = 28868
    OR "tournamentid" = 28876
    OR "tournamentid" = 42322
    OR "tournamentid" = 36924
    OR "tournamentid" = 33885
    OR "tournamentid" = 42491;


-- creating a final table  without null rows
CREATE OR REPLACE TABLE API07TOURNAMENTBYID_COMPLETEDATASET_ORIGINAL AS
    SELECT * FROM TEMP_TOURNAMENTBYID_COMPLETEDATASET
    EXCEPT
    SELECT * FROM TEMP_TOURNAMENTBYID_COMPLETEDATASET
    WHERE "GameId" is null  
        AND "TournamentName" is null
        AND "StartDate" is null
        AND "EndDate" is null
        AND "Location" is null
        AND "Teamplay" is null
        AND "TotalUSDPrize" is null;

-- correction of incorrect date
UPDATE API07TOURNAMENTBYID_COMPLETEDATASET_ORIGINAL
SET "StartDate" = '2020-05-07'
WHERE "StartDate" = '0202-05-07';


-- ---------------------------------------------------------------------

-- 08 TOURNAMENTS RESULTS FOR INDIVIDUAL PLAYERS

CREATE OR REPLACE TABLE TEMP_API08_COMPLETEDATASET AS
SELECT * FROM 
    (
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultByTournamentId_teamplay0newids" --1
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_1000-1999" --2
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_10k-14k" --3
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_14k-24k" --4
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_2000-2999" --5
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_24k-45k" --6
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_3000-3999" --7
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_4000-4999" --8
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_45k-52k" --9
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_5000-5999" --10
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_52k-64k" --11
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_6000-6999" --12
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_7000-7999" --13
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_8000-8999" --14
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_9000-9999" --15
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "CountryCode", "PlayerId", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst", "PrizeUSD"
    FROM "08TournamentResultsByTournamentId_ErrorIds1" --16
    )
;

-- basic data cleansing
UPDATE TEMP_API08_COMPLETEDATASET
SET "Ranking" = null
WHERE "Ranking" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "RankText" = null
WHERE "RankText" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "TeamId" = null
WHERE "TeamId" = 'NULL' OR "TeamId" = 0 ;

UPDATE TEMP_API08_COMPLETEDATASET
SET "TeamName" = null
WHERE "TeamName" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "CountryCode" = null
WHERE "CountryCode" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "ShowLastNameFirst" = null
WHERE "ShowLastNameFirst" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "NameFirst" = null
WHERE "NameFirst" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "NameLast" = null
WHERE "NameLast" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "CurrentHandle" = null
WHERE "CurrentHandle" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "PrizeUSD" = null
WHERE "PrizeUSD" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "PlayerId" = null
WHERE "PlayerId" = 'NULL';

UPDATE TEMP_API08_COMPLETEDATASET
SET "RankText" = null
WHERE "RankText" IN ('-', '', '?', '.') OR lower("RankText") = 'null';

UPDATE TEMP_API08_COMPLETEDATASET
SET "TeamName" = null
WHERE "TeamName" IN ('-', '', '?', '.') OR lower("TeamName") = 'null';

UPDATE TEMP_API08_COMPLETEDATASET
SET "NameFirst" = TRIM("NameFirst", '-');

UPDATE TEMP_API08_COMPLETEDATASET
SET "NameFirst" = TRIM("NameFirst", '"'); -- "

UPDATE TEMP_API08_COMPLETEDATASET
SET "NameFirst" = null
WHERE "NameFirst" IN ('-', '', '?', '.', '--') OR lower("NameFirst") = 'null';

UPDATE TEMP_API08_COMPLETEDATASET
SET "NameLast" = TRIM("NameLast", '-');

UPDATE TEMP_API08_COMPLETEDATASET
SET "NameLast" = TRIM("NameLast", '‘');

UPDATE TEMP_API08_COMPLETEDATASET
SET "NameLast" = null
WHERE "NameLast" IN ('-', '', '?', '.') OR lower("NameLast") = 'null';

UPDATE TEMP_API08_COMPLETEDATASET
SET "CurrentHandle" = null
WHERE "CurrentHandle" IN ('null', '', '-');

UPDATE TEMP_API08_COMPLETEDATASET
SET "CountryCode" = null
WHERE "CountryCode" IN ('', '-') OR lower("CountryCode") = 'null';


-- "If a placement is associated with an unknown player, the "CurrentHandle" will be "##UNKNOWN##". 
-- "PlayerId" in this instance is only used to return a unique row for each unknown player and can be discarded."
-- these ids were not unique and they maked trouble with real players IDs. For that reason we add 900 000 to them (max plays ID is about 135 000), and now we know, 
-- what the are exactly and we can easy filter them from real players by filtering < 900000.
UPDATE TEMP_API08_COMPLETEDATASET
SET "PlayerId" = "PlayerId"::int+900000
WHERE "CurrentHandle" = '##UNKNOWN##';

-- create final table and remove rows where all columns are null

CREATE OR REPLACE TABLE API08_COMPLETEDATASET AS
    SELECT * 
    FROM TEMP_API08_COMPLETEDATASET
EXCEPT
    SELECT * 
    FROM TEMP_API08_COMPLETEDATASET
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

CREATE OR REPLACE TEMPORARY TABLE TEMP_API09TOURNAMENTTEAMRESULTSBYTOURNAMENTID_COMPLETE_DATASET AS
SELECT * FROM 
    (
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "TournamentTeamId", "TournamentTeamName", "PrizeUSD", "UnknownPlayerCount"
    FROM "09TournamentTeamResultsByTournamentID_IVETA" --1
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "TournamentTeamId", "TournamentTeamName", "PrizeUSD", "UnknownPlayerCount"
    FROM "09TournamentTeamResultsByTournamentId_2IVETA" --2
    UNION
    SELECT "TournamentId", "Ranking", "RankText", "TeamId", "TeamName", "TournamentTeamId", "TournamentTeamName", "PrizeUSD", "UnknownPlayerCount"
    FROM "09TournamentTeamResultsBytournamentID_teamplay1newids_IVETA" --3
    );

-- data cleaning
UPDATE TEMP_API09TOURNAMENTTEAMRESULTSBYTOURNAMENTID_COMPLETE_DATASET
SET "RankText" = null
WHERE "RankText" IN ('-', '?', '.') OR lower("RankText") = 'null';

UPDATE TEMP_API09TOURNAMENTTEAMRESULTSBYTOURNAMENTID_COMPLETE_DATASET
SET "TournamentTeamName" = null
WHERE "TournamentTeamName" IN ('-', '?', '.')  OR lower("RankText") = 'null';

UPDATE TEMP_API09TOURNAMENTTEAMRESULTSBYTOURNAMENTID_COMPLETE_DATASET
SET "TeamId" = null
WHERE "TeamId" = 0;


-- create final table and remove rows where all columns are null
CREATE OR REPLACE TABLE API09TOURNAMENTTEAMRESULTSBYTOURNAMENTID_COMPLETE_DATASET AS
    SELECT * 
    FROM TEMP_API09TOURNAMENTTEAMRESULTSBYTOURNAMENTID_COMPLETE_DATASET
EXCEPT 
    SELECT *   
    FROM TEMP_API09TOURNAMENTTEAMRESULTSBYTOURNAMENTID_COMPLETE_DATASET
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

CREATE OR REPLACE TABLE TEMP_API10 AS
SELECT * FROM 
    (
    SELECT "TournamentId", "TournamentTeamId", "PlayerId", "CountryCode", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst"
    FROM "10TournamentTeamPlayersByTournamentId_1" --1
    UNION
    SELECT "TournamentId", "TournamentTeamId", "PlayerId", "CountryCode", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst"
    FROM "10TournamentTeamPlayersByTournamentId_2" --2
    UNION
    SELECT "TournamentId", "TournamentTeamId", "PlayerId", "CountryCode", "NameFirst", "NameLast", "CurrentHandle", "ShowLastNameFirst"
    FROM "10TournamentTeamPlayersByTournamentId_teamplay1newids" --3
    );

-- basic data cleansing
UPDATE TEMP_API10
SET "NameFirst" = TRIM("NameFirst", '"'); --"

UPDATE TEMP_API10
SET "NameFirst" = null
WHERE "NameFirst" IN ('-', '--', '?');

UPDATE TEMP_API10
SET "NameLast" = null
WHERE "NameLast" IN ('-', '?');

UPDATE TEMP_API10
SET "NameLast" = TRIM("NameLast", '-');


-- create final table and remove rows where all columns are null
CREATE OR REPLACE TABLE API10TOURNAMENTTEAMPLAYERSBYTOURNAMENTID_COMPLETE_DATASET AS
    SELECT * FROM TEMP_API10
EXCEPT
    SELECT * FROM TEMP_API10
    WHERE 
            "TournamentTeamId" is null
        AND "PlayerId" is null
        AND "CountryCode" is null
        AND "NameFirst" is null
        AND "NameLast" is null
        AND "CurrentHandle" is null
        AND "ShowLastNameFirst" is null;


-- -------------------------------------------------------------

-- To scrape players' birth dates, it was necessary to create an http address for each player. 
-- However, this address does not support certain characters, which we had to either replace or remove.
-- We then created a table of http addresses.

CREATE OR REPLACE TEMPORARY table POMOCNALINK AS
SELECT 
    "playerid", 
    "CurrentHandle",
    RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE("CurrentHandle", '._ ¡ÁÂÃÄÅÇÉÍÐÑÓÖØàáâãäåçèéêëìíîïñòóôõöøùúüýÿāăćČĐēęěİŁłńŇōŚśŜŠšũźŽžưạảấầậắếễệỉịỏỐốồổộờởủứữỳỹňşĺŨŸơǺÈÜûčūŹŻŰǍί"ΑΕΖΙΝΟΣΧΨΩαζουϹЅАБВЕЖИМНОПРСТФШЭавгеикморстухчэяёѕіเᏃᴺɟƧı!#$%&()*+,-./:;<>?@[]{}^_`|~²³¹’†′⁓™ℳ⑦☆♫⚡✨❤、あうえおかがくぐけこごさしじすぜそただちつてでとなにぬねのはぱひふぶへべぺぼまみむもやゆらりるろわアイカクスタデバプマミラワㅤ一丁七万三上不与东严中丶丸久么乌乐九了二于五亚京人今任企体余你佩侃來俊倒傻元光入全兩六兴冠冬冯冰冷凉凌凡凤凯出刀刘初别到剑劣勇勝北十千半卓单南博卧原厨古另叫叮可叶司同向吒吕君听周呵哈哦哩哲唐啊善喝喵嗜嘉嘘嘟囍团国坑坚垫執基塔墙墨夏多夜夢大天失奋奔奶如妖姑娘嫠子季孤宇安宝宮家宸宽宿小少尘就尹尾屁属岩川左已巴布帅希平幸幻幽広庭康弓张弹归影很徐微心忘快念思怠怪总恒悠悲情惊想慌慕懂成我战戦房打托扶拿指挚挽搁搬撬放教整文斗斩新无旧旬时昔星春昱晓晨晴智暑暖暗暮暴曲曼最月朔望朝朧本杀李杰极枉林果枪枫柒柠树核格桃桜梓梦梨棒榆樱橘正歪死毁毕毛気水永江汤汪沐没河波泼泽洋派流浅浩浪浮海涛涵清温渲演漫潇火灵烟烤焕無熊熙燈燕爱牛狗狸狼猪玉王玖环珠理瑶甜生用男疯疾白的皮盒盼真着瞬知石破磊祖神秀秉秋科空站竞章童端笑答米紅紫縱繁红纯罗翔老耐肥肯育胶臭航艾芬花苏若苦英范莫莺菊萧落蘑蘭虎虐虚虫虾蛋蛮蝴行街袁西见言诤请诺谜谨豆賴贺赖赛赫赵超越路跳蹦躺轨轩轻载辉辰运这进迷送逆逗造進遥邢邪邹郎郑郭都酒酱酷醉醒释野金钢银锁锋错长閻闪阳阴阿陆陈陌降随雨雪零雷雾霜青靓静韻项顾领风飞饼馬马驴骄高鬼魏鱼鲨鸡麓麦麻黄黑默黙龍龙龜강게고공괜구국권귤근길김깅꿀나남내노다달둘라러럭레렘로매맥문박발방배백별분상서소손송신심아안애약양열영오용원유윤이임자잔장재전절정조주진최치코콘킁탱팜표프하한핫현홍황=\γηνблнпфшщจᏌᴱẵọ ∩ぁぃいぉきぎずせぞっばびぷぽゃゅょよれをんィウケコッノハフブメルレンー下丨个主乃义之也乱予争云井亦介仔仙代们休会伟伦似位何佳依侠修倍假偶偷傲僧儿先克兒兔兰兽冉再冒军冻准击分利剧力劫势勒勺包化午华卫叁双叔变只号吃合后吐吞呀命咩品哟哥唯唱啥啪嘿四圆在地坤坦城域堂壢壹夕太头奇女妄妹委姛姜姬威字孙孝学孩孽宅客容寂寒寞寻尖尢尤尽居履山屿岁岛島崩崽工巧帝带席帮常干年幼庆底开弟弱强当形得德忆怀性恩恹悪惰意懒户手才扎执扬承技把投拔招掌排摂摳敏斌斯方既日旭旺明是昼晋晒木末机权杉条来杨杯某染柔柚查柳栀栎栖桀案桐桥森椒槌橋欣欧歌步殇比氏汉沉沛油洒洛涯渡港游潭澈濑点烦烬然照爆爷牙牢物狙独猜猫玮球琉琛琪琴瑞瑾璐瓜瓣电痕瘾皂盗省眠睡督睿砂砖碧確福禹离秘等筱简粪糖素索约级纳纸练终给维缘羊美羡群羽者肉胃腾自舞良色艺芒茉茶草荡莉莲菇菜萨蒼蓮薇藏虹蝶血衣袭裡要観觉解訫诚话语谦谷豪贤败贱躁输辞达远迪迭迹逍逸逼道遗酸里鉄鑫钧铁铛铭锥门间限隻雄雏電霖霸霾非面頭颜飘香駿骑骚骨魂魇魔魚鲁鵝鸟鸢鸣鸭鹿黎黒가감개건검경곰관기는늘니대더덕도동뜨렬론머면명모몬미민범베봉브비빈빛사산석선성세수순스승악언연예완우운웅은의인쟁좀종준중지집찮창처천철추캬콩킨탓태택퇴포플혁형호환훈️﻿６ϊКдйьอᎡᴹ❦〃ぇざどぴめ゜ガグゴチトドナネヤ丝乎乔仓伞传作使便像八兼冲凶加压吖员味咪噜噴回园壁士声奈好娇學定对将尔帕帽往怎恋愛戰抱揚故斬旅朽杂栄梧棍様欢欲武汁求沧泫涼深溃源滴炎焰煮特猎猖猛瑜璃甘異直看稚竹第绎義职聖背脑膏膨舍节芷药菌萌葩蓝薄蜂蜜見记貓費贝贼起跑过逊達那邰釣锦镜闭队险陶霞食鹅鹰鼻齐광규균꾼날덱드래록리말무봇살섭솔식와왕위을일제찬콜킬터투트티피헌홀희９őǷɪϻЛาᏩᴀ『オソホロ・世业乡供做停剣助勢吶咻圈巢度桑極歉残泪狂糕糞网翼胀袋说谁間闹顿鼠걀까롤릭메쓰알어잃펀험３ǾรᏆᴍᴛᴜげベリ养应式界茧部바커５ＲĿɴʙ์ᴇ商槍생ｙ\Ȉʟิᴏ彡ｚǝ้⓰ｅŖมｎแ』ƑǃɓτχГДЗЙХЧЯжзыю่ặẻềểỗự°·ĔŦʀιρวⓔ★ツ丂乾亮令仲伪凑凹則动劲勤卡又口台咖啄圣垃她奾妍姐娃娜幡建強彪彼悟拂撒收旋易曾札朱殘沒泉法泰澤煎片狮猩玩珊琳甲百絕羅肿芭莱萊萝营藤蘇补詩詹货贴车轮软还闷陵隨饭騒거교궁네당뚜롱링물보부쌀에엽함＿λϋⓖ▵ボ丘兵凸刹办取吧啡器因圾坎塞师座戏旦昂栉渣湿灣炼珩瓶绮能装裤贏辣钩锅關靠鸽계따람맞북후Ŋʍεⓞ係勁名嗆拙政更纱臨鈈震키？\Ǩύ巽～艮兑', '----aaaaaceidnoooaaaaaaceeeeiiiinoooooouuuyyaaccdeeeillnnosssssuzzzuaaaaaaeeeiioooooooouuuyynsluyoaeuucuzzuai'), 'Æ', 'ae'), 'ß', 'sz'), 'ð', 'eth' ), 'æ', 'ae' ), '-') as NICKNAME,
    "NameFirst",
    RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE("NameFirst", '._ ÁÅÇÈÉÍÐÓÖØÞàáâãäåçèéêëìíîïñòóôõöøùúüýþĀāăĄčĐđĒėěğĩīİŁłŅŐőřśŞşŠšũūŽžơưȘșţ̦̣̀́̂̌ẠạảấầẩậắếềễệịọốồổộợừửữỳņżặớờứÂÔÜēęĢģļň"⁬ΑΚАБЕКОгеёı渡?ιвнос​‎‏’辺﻿μдиртίайλοςΝВГДИМСлмỗụự神кь龙', '---aaceeidooodaaaaaaceeeeiiiinoooooouuuydaaaacddeeegiiillnoorsssssuuzzousstaaaaaaaaeeeeioooooouuuynzaoouaoueeggln'), 'Æ', 'ae'), 'ß', 'sz'), 'ð', 'eth' ), 'æ', 'ae' ), '-') AS KRESTNI,
    "NameLast",
    RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE("NameLast", '._ ÁÅÇÉÓÖØÚÜàáâãäåçèéêëìíîïñòóôõöøùúüýĀāăąĆćČčĎĐđĒēėęěğģīİļŁłńņňőŘřŚśŞşŠšťũūůűŹźŻżŽžơưșȚțɫ̛̣̀́̂̆̈̌ạấầậắếềểễệịọốồứừữỳ"ΜНШуёı/?\´&ḑ̌̃πбеиặỗờ‎‘’﻿ρйлнέоч#;\σвιακςĶķАБЕИКПРСТХЦаảгзмрстхыю​жкф', '---aaceooouuaaaaaaceeeeiiiinoooooouuuyaaaaccccdddeeeeeggiilllnnnorrsssssstuuuuzzzzzzousttlaaaaaeeeeeiooouuuy'), 'Æ', 'ae'), 'ß', 'sz'), 'ð', 'eth' ), 'æ', 'ae' ), '-') AS PRIJMENI,
    "CountryCode"
FROM APIPLAYERBYIDCOMPLETETABLE;


CREATE OR REPLACE table PLAYERLINK AS
SELECT 
    CASE 
    WHEN NICKNAME is null AND KRESTNI is null AND PRIJMENI is null THEN lower(CONCAT('https://www.esportsearnings.com/players/', "playerid", '-')) 
    WHEN NICKNAME is null AND KRESTNI is null THEN lower(CONCAT('https://www.esportsearnings.com/players/', "playerid", '-', PRIJMENI)) 
    WHEN KRESTNI is null AND PRIJMENI is null THEN lower(CONCAT('https://www.esportsearnings.com/players/', "playerid", '-', NICKNAME)) 
    WHEN NICKNAME is null AND PRIJMENI is null THEN lower(CONCAT('https://www.esportsearnings.com/players/', "playerid", '-', KRESTNI)) 
    WHEN KRESTNI is null THEN lower(CONCAT('https://www.esportsearnings.com/players/', "playerid", '-', NICKNAME, '-', PRIJMENI))
    WHEN PRIJMENI is null THEN lower(CONCAT('https://www.esportsearnings.com/players/', "playerid", '-', NICKNAME, '-', KRESTNI))
    WHEN NICKNAME is null THEN lower(CONCAT('https://www.esportsearnings.com/players/', "playerid", '-', KRESTNI, '-', PRIJMENI)) 
    ELSE lower(CONCAT('https://www.esportsearnings.com/players/', "playerid", '-', NICKNAME, '-', KRESTNI, '-', PRIJMENI))
    END as LINK,
    "playerid", 
    "CurrentHandle", 
    NICKNAME, 
    "NameFirst", 
    KRESTNI, 
    "NameLast", 
    PRIJMENI, 
    "CountryCode"
FROM POMOCNALINK;


-- ------------------------------------------------------------------------------
-- merging files with birth dates and creating a table with player ID and birth date
-- players with a date of birth greater than 2012 have been excluded, as such dates of birth are probably not filled in correctly 
-- (There was a real gap in the data between 2013 and 2016 and players born since 2017 would be 6 years old or younger, which is unlikely. 
-- There were also players born in 2023 in the data, which doesn't really make sense, and it is a misfilled data.)
CREATE OR REPLACE TABLE PLAYERIDDOB AS
SELECT * FROM
    (
    SELECT 
        "playerid", 
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
        FROM "DateOfBirth_errors_znovu_stazeno1"
        UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth_errors_znovu_stazeno_2"
        )
    JOIN PLAYERLINK p ON "Url"="LINK"
    WHERE "DateOfBirth" != '<unknown>' AND "DateOfBirth" != '' AND "DateOfBirth" is not null 
    )
WHERE "Year" <= 2012;

-- ---------------------------------------------------------

-- when downloading data from the API, various errors occurred during the download and some data had to be downloaded again
-- so we created lists of IDs to be re-downloaded in python. Sometimes this had to be repeated for newly downloaded (error) IDs.

CREATE OR REPLACE TABLE GAMEBYID_ERRORIDS AS
SELECT "gameid"
FROM "04LookupGameById_vystup0-1000"
WHERE "ErrorCode" != '';

CREATE OR REPLACE TABLE TOURNAMENTERRORIDS AS
    SELECT "tournamentid"
    FROM "07TournamentById_vystup1000-1999"
    WHERE "ErrorCode" != '' OR "ErrorCode" is not null
UNION
    SELECT "tournamentid" FROM "07ToutnamentById_vystup14359-24358_novecsv"
    WHERE "Error" != '' OR "Error" is not null
UNION
    SELECT "tournamentid" FROM "07ToutnamentById_vystup24359-52708_novecsv"
    WHERE "ErrorCode" != '' OR "Error" != '' OR "ErrorCode" is not null OR "Error" is not null
UNION
    SELECT "tournamentid" FROM "07ToutnamentById_vystup52808-82806_novecsv"
    WHERE "ErrorCode" != '' OR "Error" != '' OR "ErrorCode" is not null OR "Error" is not null
ORDER BY "tournamentid";


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
FROM "DateOfBirth_errors_znovu_stazeno1"
WHERE "Error" is not null AND "Error" != '';
