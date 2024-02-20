# Python scripts for downloading data from https://www.esportsearnings.com/ APIs#

# For information about my E-sport project, you can read my blog: https://medium.com/@vtkncv/e-sport-part-2-python-acb60fb6d58b 

There are 12 scripts for 12 APIs
The Order (Number) of APIs is the same as on the original documentation: https://www.esportsearnings.com/apidocs
Output format: jsonl + csv

### APIs are divided into 3 categories: according to what you have to enter in URL of the request
A) ID
- core data for normalized database
B) ID, offset
- a summary overview
C) offset 
- a summary overview

Scripts in one category are the same, only the name of the main variable (player / game /tournament) or the name of a function, URL, file name etc. differs.

### No. API                                                 Category     Input
**01  Look up Player By Id                                 A             player ID**
02  Look up Player Tournaments                           B             player ID, offset
03  Look up Highest Earning Players                      C             offset
**04  Look up Game By Id                                   A             game ID**
05  Look up Highest Earning Players By Game              B             game ID, offset
06  Look up Recent Tournaments                           C             offset
**07  Look up Tournament By Id                             A             tournament ID**
**08  Look up Tournament Results By Tournament Id          A             tournament ID**
**09  Look up Tournament Team Results By Tournament Id     A             tournament ID**
**10  Look up Tournament Team Players By Tournament Id     A             tournament ID**
11  Look up Highest Earning Teams                        C             offset
12  Look up Highest Earning Teams By Game                B             game ID a offset


Used modules: 
- requests
- json
- csv
- datetime
- time
- urllib3


Notes:
This is my first attempt at coding in Python. If you have any suggestions on how to improve my scripts, I would love to read them.

***TO MAKE THIS SCRIPTS WORK, YOU MUST HAVE A VALID API KEY. YOU CAN GET AN API KEY BY REGISTERING HERE: https://www.esportsearnings.com/dev***