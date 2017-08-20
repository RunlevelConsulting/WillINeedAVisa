# Will I Need A Visa? (WillINeedAVisa.com)

## Overview

I've been fortunate enough to travel to numerous countries around the world and I noticed there wasn't a clean and simple website out there which allowed me to quickly check the visa requirements of any country I might want to travel to. 

I wanted to create a website that fulfilled the following criteria:

 - Is useful and accurate
 - Quick to build
 - Is automated and requires no - or very minimal - maintenance
 - Answers a specific question an individual may type into Google

This seems to fit the bill. All the website data is pulled from Wikipedia and is therefore maintained by their contributors which is the best bet to keep the information relevant. The script that maintains Will I Need A Visa does what it can to filter out human-created anomalies and maintain consistency in the information provided.

The Will I Need A Visa website, database structure and maintenance scripts are all completely open source for anyone to use.

Will I Need A Visa uses the following languages: **BASH, sed, PHP,  HTML, CSS, Javascript (inc. AJAX & JQuery) and SQL**

&nbsp;

## Dependencies

 | Tool     | Purpose | Available From   |
| :------- | :---- | :--- |
| jq     | JSON Parser    |  Package Manager or https://github.com/stedolan/jq  |
| pup    | HTML Parser   |  https://github.com/ericchiang/pup/releases   |
| curl | Pulls Web Data |  Package Manager    |
| Webserver with PHP | Display Webpages |  Package Manager    |
| MySQL Client/Server | Store Visa Data |  Package Manager    |
> **NOTE:** Ensure all commands and binaries are located in one of your $PATH directories and are executable.


&nbsp;


## Getting Started

#### 1. Add Database Credentials To Extraction Script

##### **visaExtract.sh**

```bash
#############################################
## DATABASE CREDENTIALS                    ##
#############################################

DB_USERNAME=''
DB_PASSWORD=''
DB_HOSTNAME=''
DB_DATABASE=''

```

> **NOTE:** This script will attempt to run **_CREATE DATABASE ${DB_DATABASE};_**
> Ensure the credentials have the privileges to do this. Otherwise create the database manually for the first run.

#### 2. Add Database Credentials To Website

##### **site/inc/dbCredentials.inc.php**

```php
<?php
$DB_USERNAME='';
$DB_PASSWORD='';
$DB_HOSTNAME='';
$DB_DATABASE='';
?>
```
> **NOTE:** These credentials only need read-access so you may wish to use different credentials to those above.

#### 3. Run the script!
```bash
./visaExtract.sh
```

This will import the **visaExtractDB.sql** file which creates all the tables and data needed for the script to get started.
It will then begin iterating through each country's Wikipedia page, extracting the visa info and storing it to the DB. 



&nbsp;


## Script Arguments and Caching

Visa requirements for countries are constantly changing and as such, the **visaExtract.sh** script needs to be run periodically. 
A full script run can potentially be managing around 40,000 rows of data (~200 countries with visa requirements for ~200 other countries). This can be resource-intensive, so various measures have been added to cache data, minimise database queries and skip processes unless absolutely necessary - there are also arguments that can be added to break the process down further.

#### Caching
Every time a country is scanned it will create a local file: **/tmp/visaScan-Country-_COUNTRYID_.json**. This file contains content pulled from the previous curl of the Wikipedia page. 
If you run the **visaExtract.sh** script a second time, the code to update the DB will only run where the cached file and the curl data differ (i.e - The Wikipedia page has been updated since your last run).

Running ``` ./visaExtract.sh NOCACHE ``` will delete all cache files and do a full scan of all countries on Wikipedia.

Running  ``` ./visaExtract.sh <COUNTRYID> ``` will delete the cache file for that particular country ID and do a new scan of that country only.

#### Random

Running ```./visaExtract.sh RANDOM``` will scan a single, random country. This is a useful command to run as a **cron job** as all your records will all eventually be updated depending on how frequently it runs.

&nbsp;

## Script Inconsistencies and Maintenance

The script only allows 4 visa statuses: **Visa Required**, **Visa Not Required**, **eVisa** and **Admission Refused**.

As Wikipedia is contributed to by users, the data input can sometimes be non-standard or misspelt and the script can't tell which of the 4 categories that entry should be applied to. These are referred to as **Inconsistencies**. 

If inconsistencies are found, it will create a local file: **/tmp/visaScan-Inconsistencies-_TIMESTAMP_**. This file will list the data that couldn't be classified. 

#### Fixing Inconsistencies

The **visaExtract.sh** script contains a section headed **_VISA TYPE FILTERING_**. It contains a number of _sed_ and _if_ statements which replace one string with another.

For example in the **Admission Refused** section, we have the following _sed_ statement:
```
VISATEXT=$(echo ${VISATEXT} | sed -r 's/(Invalid passport|Not recognized)/Admission Refused/gi')
 ```

So any visa statuses found containing _Invalid passport_ or _Not recognized_ (case-insensitive) will be replaced with _Admission Refused_.

Let's imagine a country's visa status on Wikipedia is "_Not Allowed_", this is basically another way of saying _Admission Refused_, so we simply add this to our _sed_ statement:
```
VISATEXT=$(echo ${VISATEXT} | sed -r 's/(Not Allowed|Invalid passport|Not recognized)/Admission Refused/gi')
```

So it's simply a case of adding inconsistencies as they arise into the _sed_ statements separated by a pipe.


&nbsp;

## Credits

##### **HTML/CSS Front-End Design**:

Olivia Ng (https://github.com/oliviale) 
##### **Everything Else**: 

Daniel Hughes (https://github.com/RunlevelConsulting)
