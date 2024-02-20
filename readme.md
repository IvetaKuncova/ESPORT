This is part of a project for our study in data analysis at Czechitas.cz - nonprofit organization for educating woman in IT.
Project blog: https://medium.com/@vtkncv/e-sport-data-analysis-project-summary-e7b64cd37c84

**PROJECT E-SPORT**

It is about data from https://www.esportsearnings.com/.

Data about GDP, population, internet are from from https://ourworldindata.org/.

You can see our code in python and SQL (Snowflake).

**1) PYTHON:**

**A)** There are scripts for downloading data from selected APIs (Documentation: https://www.esportsearnings.com/apidocs)

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

**B)** There is also script for scraping _Date of Birth_, but I strictly recommend not use it, unless you are aware of legal consequencis!

**2) SQL:**

There are querries we used for processing the data in _Snowflake_.

Because downloading data from one API took many hours, and as a result we had up to 20 files for each API, it was necessary to first union these files using the UNION function. We also started with basic data cleansing.
In the next phase, we started creating tables from the created datasets according to the designed data model.

We used functions as: CTE, SUBSELECTS, CREATE (TEMPORARY) TABLE, ALTER TABLE, UPDATE, ADD COLLUMN, DROP COLLUMN, INSERT VALUES, (LEFT) JOIN, UNION (ALL), WINDOW FUNCTIONS (RANK), CASE WHEN, DISTINCT, AGGREGATIONS (SUM, COUNT, MEDIAN, AVG, MIN, MAX, PERCENTILE_CONT),  Text functions: TRIM, REPLACE, TRANSLATE, LISTAGG, REGEXP_SUBSTR, CONCAT, LOWER, (I)LIKE (ANY), IFFNULL, TRANSLATE, CONCAT, Date functions: TO_DATE, DATE, YEAR.

**3) Correlation statistics - esport players**
There is a code in python Jupyter Notebook determining the degree of correlation (Kendall's Tau) between chosen indicators. This script also work with determining normality of distribution and linearity of data as a assumptions for statistical functions.