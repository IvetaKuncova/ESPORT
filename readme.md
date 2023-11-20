This is part of a couple project for my study in data analysis at Czechitas.cz - nonprofit organization for educating woman in IT.

PROJECT E-SPORT
It is about data from https://www.esportsearnings.com/
Data about GDP, population, internet are from from https://ourworldindata.org/

You can see my code in python and SQL (Snowflake).

A) PYTHON:
1) There are scripts for downloading data from selected APIs (Documentation: https://www.esportsearnings.com/apidocs)

The code consists of several parts:
- Importing libraries
- Setting global variables
- Timing information about the script's execution
- Creating a session to handle HTTP exceptions
- A function to get data from the API
- A function to save data in JSONL format
- A function to convert JSONL to CSV format (Keboola does not accept JSON format)
- Output timing information
- ANSI codes are used in the code for colored outputs, for example: "\u001b[35m"

The code had to be written in the way that it could run for xx hours without interruption (typically overnight) and save the data continuously. If an error occurred, such as "Empty response" or "Bad gateway", the code had to either skip the given ID or try to download it again.

2) There is also script for scraping Date of Birth, but I strictly recommend not use it, unless you are aware of legal consequencisy!

3) Correlation statistics - esport players
There is a code in python Jupyter Notebook determining the degree of correlation (Kendall's Tau) between chosen indicators. This script also work with determining normality of distribution and linearity of data as a assumptions for statistical functions.

B) SQL:
There are querries we used for processing the data in Snowlfake.

Because downloading data from one API took many hours, and as a result we had up to 20 files for each API, it was necessary to first union these files using the UNION function. We also started with basic data cleansing.
In the next phase, we started creating tables from the created datasets according to the designed data model.

