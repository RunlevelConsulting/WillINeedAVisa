#!/bin/bash

#############################################################################################
#                                                                                           #
# Author:  Daniel Hughes                                                                    #
# Company: Runlevel Consulting Ltd.                                                         #
# Website: runlevelconsulting.co.uk                                                         #
#                                                                                           #
#############################################################################################



#############################################
## DATABASE CREDENTIALS                    ##
#############################################

# Modify the details below to suit your DB environment.
# If the database doesn't exist, it will be automatically created for you.

DB_USERNAME=''
DB_PASSWORD=''
DB_HOSTNAME=''
DB_DATABASE=''


# MySQL Command
MYSQL_CMD="mysql -u ${DB_USERNAME} -p${DB_PASSWORD} -h ${DB_HOSTNAME} ${DB_DATABASE}"



#############################################
## DEPENDENCY CHECKS / VALIDATION          ##
#############################################

# Check pup is installed
CHECK_PUP=$(which pup); STATUS_PUP=$(echo $?);
if [[ "${STATUS_PUP}" -ne 0 ]]; then
  echo -e "\nThis tool requires pup to be installed.\nPick up the binary for your system from: https://github.com/ericchiang/pup/releases\n"; exit 1;
fi


# Check jq is installed
CHECK_JQ=$(which jq); STATUS_JQ=$(echo $?);
if [[ "${STATUS_JQ}" -ne 0 ]]; then
  echo -e "\nThis tool requires jq to be installed.\nDownload jq from: https://stedolan.github.io/jq/\njq may also be available through your system's package manager.\n"; exit 2;
fi


# Check DB Credentials aren't empty
if [[ -z ${DB_USERNAME} || -z ${DB_PASSWORD} || -z ${DB_HOSTNAME} || -z ${DB_DATABASE} ]];  then
  echo -e "\nPlease input database credentials into the variables under the DATABASE CREDENTIALS section of this script.\n"; exit 3;
fi


# Does DB exist? Else create it and import SQL
if ! ${MYSQL_CMD} -e "USE ${DB_DATABASE}"; then
  echo -e "\nDatabase doesn't exist, creating and importing data...\n"

  # Create Database
  mysql -u ${DB_USERNAME} -p${DB_PASSWORD} -h ${DB_HOSTNAME} -e "CREATE DATABASE IF NOT EXISTS ${DB_DATABASE};"
  if [[ "$?" -ne 0 ]]; then
    echo -e "\nCouldn't create database!\nIt may be the case that your DB user lacks the privileges to create databases in which case you'll need to do this manually with a sufficiently privileged MySQL user.\n"; exit 4;
  fi

  # Import SQL file
  ${MYSQL_CMD} < $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/visaExtractDB.sql
  if [[ $? -ne 0 ]]; then echo -e "\nTable data failed to import. Does user '${DB_USERNAME}' have privileges to create tables on the ${DB_DATABASE} database?\n"; exit 5; fi

fi


# If DB does exist, ensure initial data exists
COUNT_COUNTRIES=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM Countries")
COUNT_COUNTRIESALIASES=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM CountriesAliases")
if [[ "${COUNT_COUNTRIES}" -eq 0 || "${COUNT_COUNTRIESALIASES}" -eq 0 ]];  then
  ${MYSQL_CMD} < $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/visaExtractDB.sql
fi


# If first argument of script is 'RANDOM' then only scan a single country
# If first argument of script is 'NOCACHE', delete entire cache and do a full run
# If first argument is a number, then only run script against that country ID
# Otherwise just do a full run using whatever caches exist
if [[ "${1}" == "RANDOM" ]]; then
  ORDER_BY="ORDER BY RAND() LIMIT 1"
elif [[ "${1}" == "NOCACHE" ]]; then
  rm -f /tmp/visaScan-Country-* > /dev/null 2>&1
  ORDER_BY="ORDER BY country ASC"
elif [[ "${1}" =~ ^-?[0-9]+$ ]]; then
  ADD_WHERE="WHERE id=${1}"
  rm /tmp/visaScan-Country-${1}.json > /dev/null 2>&1
else
  ORDER_BY="ORDER BY country ASC"
fi



#############################################
## GET LOCAL COPY OF COUNTRY DB TABLES     ##
#############################################

# Get all countries, country aliases and corresponding country IDs and store them to a local variable
# This allows us to check a country that appears in Wikipedia exists either in the "Countries" or "CountriesAliases" tables without having to hammer the DB
#
COUNTRIES_LOCAL=$(${MYSQL_CMD} -N -e "SELECT id, country FROM Countries;" | sed -e 's/^/|/g' -e 's/\t/|/g')
ALIASES_LOCAL=$(${MYSQL_CMD} -N -e "SELECT countryId, alias FROM CountriesAliases;" | sed -e 's/^/|/g' -e 's/\t/|/g')
ALLCOUNTRIES_LOCAL=$(echo -e "${COUNTRIES_LOCAL}\n${ALIASES_LOCAL}")



#############################################
## GET THINGS STARTED                      ##
#############################################

# For each entry in the 'Countries' table...
${MYSQL_CMD} -BNr -e "SELECT * FROM Countries ${ADD_WHERE} ${ORDER_BY};" | while IFS=$'\t' read DB_ID DB_COUNTRY DB_LINK;
do

  # Get all visa info for this particular country and store to a local variable
  # Breaking this down into an array by country instead of a monolithic variable with all countries totalling tens of thousands of lines speeds up the script considerably
  #
  VISAINFO_LOCAL[${DB_ID}]=$(${MYSQL_CMD} -N -e "SELECT countryFromId, countryToId, VisaInfo, additionalInfo FROM VisaInfo WHERE countryFromId=${DB_ID};" | sed -e 's/\t/,/g')

  # This file acts as a cache, if the data in this file is the same as the data pulled from the curl below, then we know nothing has changed and this country can be skipped
  COUNTRY_CACHE_FILE="/tmp/visaScan-Country-${DB_ID}.json"; touch "${COUNTRY_CACHE_FILE}";
  CHECK_CACHE_FILE=$(cat ${COUNTRY_CACHE_FILE})

  # Grab Wikipedia page and make it vaguely iterable
  #
  # 1. pup - grabs the first table with the class 'sortable'
  # 2. pup - converts it to JSON
  # 3. sed - jq hates selectors with a hyphen so get rid of those
  # 4. jq - Hone down onto the area we want and iterate
  # 5. tail - Remove first line of output, it's the table header row
  #
  FILTER=$(curl -s --compressed "${DB_LINK}"  | pup -i 0 '.sortable' | pup json{} | sed 's/data-src/src/g' | jq -c '.[0].children[0].children[1].children[0].children[0].children[]' | tail -n +2)

  # Stop script if this pull is identical to previous
  if [[ "${CHECK_CACHE_FILE}" == "${FILTER}" ]]; then
    echo -e "Skipping ${DB_COUNTRY} (${DB_ID}): Cached file matches latest pull - therefore there are no updates.\n"
  else


    while read i; do

      ########################################################################
      ## COUNTRY CAPTURE                                                    ##
      ########################################################################

      # Due to small differences in the layout of Wikipedia tables we have to try a few times to get the right field
      #
      GRABCOUNTRY=$(echo "${i}" | jq -r '.children[0].children[0].children[1].src');
      if [[ ${GRABCOUNTRY} == 'null' ]]; then	GRABCOUNTRY=$(echo "${i}" | jq -r '.children[0].children[1].children[0].children[1].src'); fi
      if [[ ${GRABCOUNTRY} == 'null' ]]; then	GRABCOUNTRY=$(echo "${i}" | jq -r '.children[0].children[0].children[0].children[1].src'); fi

      # Got to pipe this output, example output: //upload.wikimedia.org/wikipedia/en/thumb/0/05/Flag_of_Brazil.svg/22px-Flag_of_Brazil.svg.png
      # We need to extract the country name, this is awfully hacky but it does work
      #
      # 1. rev - Reverse the entire thing = gnp.gvs.lizarB_fo_galF-xp22/gvs.lizarB_fo_galF/50/0/bmuht/ne/aidepikiw/gro.aidemikiw.daolpu//
      # 2. cut - Extract everything before the first slash = gnp.gvs.lizarB_fo_galF-xp22
      # 3. rev - Unreverse it = 22px-Flag_of_Brazil.svg.png
      # 4. sed - Get rid of a few common suffixes
      # 5. grep - Extract everything between the words 'Flag_of_' and '.svg' = Brazil
      # 6. sed - Remove underscores (for names with multiple words) and remove the word 'the' from any names beginning with 'the' (e.g The Bahamas)
      #
      TOCOUNTRY=$(echo "${GRABCOUNTRY}" | rev | cut -d '/' -f1 | rev | sed -e 's/_%28civil%29//g' -e  's/_%28state%29//g' | grep -o -P '(?<=Flag_of_).*(?=.svg)' | sed -e 's/_/ /g' -e 's/^the //g');



      ########################################################################
      ## COUTNRY/ALIAS CHECK                                                ##
      ########################################################################

      # Check for country against local DB pull, if it's different then update or add
      ALLCOUNTRIES_CHECKFORSTRING="|${TOCOUNTRY}"
      echo "${ALLCOUNTRIES_LOCAL}" | grep -i -q "${ALLCOUNTRIES_CHECKFORSTRING}"$

      if [ $? -ne 0 ];then
        echo -e "Problem: ${TOCOUNTRY} doesn't exist - ${DB_LINK}\nPlease input ${TOCOUNTRY} into the CountriesAliases table in your database."; exit 6;
      else
        TOCOUNTRYID=$(echo "${ALLCOUNTRIES_LOCAL}" | grep -i "|${TOCOUNTRY}"$ | cut -d '|' -f2)
      fi



      ########################################################################
      ## VISA TYPE CAPTURE                                                  ##
      ########################################################################

      # Grab visa type (Visa Required, eVisa, etc), again variations in HTML mean it sometimes takes a few attempts
      # Sometimes there's a bit of malformed HTML so quickly remove that with sed
      # This section of the code is pretty horrible and the less said about it, the better.
      #
      VISATEXT=$(echo ${i} | jq -r '.children[1].text' | sed 's/&lt;$//gi') # Catches 99% of entries
      if [[ "${VISATEXT}" == null || "${VISATEXT}" == '' ]];  then		VISATEXT=$(echo ${i} | jq -r '.children[1].children[0].text' | sed 's/&lt;$//gi');   		fi # Some outputs will have an '!', these are display:none elements, we don't want these
      if [[ "${VISATEXT}" == *"!"* || "${VISATEXT}" == '' ]]; then		VISATEXT=$(echo ${i} | jq -r '.children[1].children[1].text' | sed 's/&lt;$//gi');   		fi # So change the extracted text
      if [[ "${VISATEXT}" == null || "${VISATEXT}" == '' ]]; then		VISATEXT=$(echo ${i} | jq -r '.children[1].children[1].children[0].text' | sed 's/&lt;$//gi'); 	fi # Still doesn't get anything?
      if [[ "${VISATEXT}" == '' ]]; then					VISATEXT=$(echo ${i} | jq -r '.children[1].children[1].text' | sed 's/&lt;$//gi');   		fi # This catches the last of them

      # I found that modifying the visa text can make the script a little slow.
      # So if an entry already has one of the four valid "VisaText" values, then the next section can be skipped altogether
      shopt -s nocasematch
      if [[ "${VISATEXT}" != "Visa Required" && "${VISATEXT}" != "Visa Not Required" && "${VISATEXT}" != "eVisa" && "${VISATEXT}" != "Admission Refused" ]]; then

        #############################################
        ## VISA TYPE FILTERING                     ##
        #############################################

        #  Only allows a few characters to go through for now until full validation later
        VISATEXT=$(echo "${VISATEXT}" | sed 's/"/\&#34;/g' | tr -d -c '[:alnum:]:/\-?=*()#&;_\\ ')


        # Sadly because we're dealing with user-created content, it tends to be full of inconsistencies
        # This is the part of the code you might need to add to every now and then, don't blame me for how hideous this looks
        # Also, a few rules are kind of one-or-the-other (e.g "Visa on arrival or E-Visa"), I err on the side of caution (eVisa)
        # These sed replaces use regex so don't forget to escape special characters such as brackets \( \) and slashes \/
        ########################################################################################################################################

        # Get rid of text that's never useful
        VISATEXT=$(echo ${VISATEXT} | sed -r 's/( \(Conditional\)| \(temporary\)|^Free )//gi')

        # eVisa Section
        if [[ ${VISATEXT} = "EVisa"* ]]; then       VISATEXT="eVisa";
        elif [[ ${VISATEXT} = "Electronic"* ]]; then  VISATEXT="eVisa";
        elif [[ ${VISATEXT} = "E-"* ]]; then  VISATEXT="eVisa";
        elif [[ ${VISATEXT} = *"e600"* ]]; then  VISATEXT="eVisa";       fi
        VISATEXT=$(echo ${VISATEXT} | sed -r 's/(Visa Waiver Program|eVisa\/eNTRI|ASAN Electronic Visa|On-line registration or eVisa|eVisa required|eVisitor|^eTA$|Online registration or eVisa|Visa On Arrival in advance|Visa on arrival or E-Visa|Reciprocity fee in advance|eVisa &amp; Visa on Arrival)/eVisa/gi')

        # Visa Section
        # Lots of different phrases refer to the same thing. Change them all to 'Visa'
        VISATEXT=$(echo ${VISATEXT} | sed -r 's/(Entry Permit|Entry Clearance|Visitor&#39;s Permit|^Permit|Tourist Card|Travel Certificate)/Visa/gi')

        # Visa Not Reqired
        if [[ ${VISATEXT} = *"reciprocity fee"* ]]; then      VISATEXT="Visa Not Required";
        elif [[ ${VISATEXT} = *"visa on arr"* ]]; then        VISATEXT="Visa Not Required";
        elif [[ ${VISATEXT} = "Visa not req"* ]]; then        VISATEXT="Visa Not Required";   fi
        VISATEXT=$(echo ${VISATEXT} | sed -r 's/(Freedom of movement|Multiple-entry visa on arrival|Visa is granted on arrival|Visa arrival|Visa not$)/Visa Not Required/gi')

        # Visa Required
        if [[ ${VISATEXT} = "Visa req"* ]]; then      VISATEXT="Visa Required"; fi # People actually misspell the word "required"...
        VISATEXT=$(echo ${VISATEXT} | sed -r 's/(Visa or eTA required|Special provisions|Admission partially refused \/ partially allowed|Affidavit of Identity required|Visa is required|Visa on arrival but prior approval required|Visa de facto required|Special authorization required|Disputed)/Visa Required/gi')

        # Admission Refused
        if [[ ${VISATEXT} = "Admission Refused"* ]];     then  VISATEXT="Admission Refused";
        elif [[ ${VISATEXT} = "Entry Not Permitted"* ]]; then  VISATEXT="Admission Refused";
        elif [[ ${VISATEXT} = "Travel banned"* ]]; then  VISATEXT="Admission Refused"; fi
        VISATEXT=$(echo ${VISATEXT} | sed -r 's/(Invalid passport|Not recognized)/Admission Refused/gi')

        # Random - This is where entries are just completely off and you have to add a manual exception
        if [[ ${VISATEXT} = "With "* ]]; then VISATEXT="Visa Required";       fi

       ########################################################################################################################################

        # Final Validation
        VISATEXT=$(echo "${VISATEXT}" | sed 's/"/\&#34;/g' | tr -d -c '[:alnum:] ')

      fi
      shopt -u nocasematch



      #############################################
      ## VISA INFO CAPTURE                       ##
      #############################################

      # Grabs info on the length of stay.
      # egrep - Grab any number if it's followed by the word Day(s) or Month(s)
      #
      INFO=$(echo ${i} | jq -r '.children[2].text' | egrep -i -o '^[[:digit:]]{1,3} (Day|Week|Month|Year)(s|)(;|,|\.|$)')

      # Validation
      INFO=$(echo "${INFO}" | sed 's/"/\&#34;/g' | tr -d -c '[:alnum:] ')



      #############################################
      ## VALIDATE AND ADD TO DB                  ##
      #############################################

      echo "${DB_COUNTRY} ($DB_ID) to ${TOCOUNTRY} ($TOCOUNTRYID) - ${VISATEXT} - ${INFO}"

      # Check against local DB pull, if it's different then update or add
      VISAINFO_CHECKFORSTRING="${DB_ID},${TOCOUNTRYID},${VISATEXT},${INFO}"
      echo "${VISAINFO_LOCAL[${DB_ID}]}" | grep -i -q "${VISAINFO_CHECKFORSTRING}"

      if [ $? -ne 0 ];then

        DOESITEXIST=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM VisaInfo WHERE countryFromId=\"${DB_ID}\" AND countryToId=\"${TOCOUNTRYID}\"")
        if [ ${DOESITEXIST} -eq 0 ]; then
          ${MYSQL_CMD} -N -e "INSERT INTO VisaInfo (countryFromId, countryToId, visaInfo, additionalInfo) VALUES ('${DB_ID}', '${TOCOUNTRYID}', '${VISATEXT}', '${INFO}')"
        else
          ${MYSQL_CMD} -N -e "UPDATE VisaInfo SET visaInfo='${VISATEXT}', additionalInfo='${INFO}' WHERE countryFromId='${DB_ID}' AND countryToId='${TOCOUNTRYID}'"
        fi

      fi

    done < <(echo "${FILTER}")

  # If cached data differs from latest pull, update the cache file
  echo "${FILTER}" > ${COUNTRY_CACHE_FILE};

  fi

done



#############################################
## CHECK INCONSISTENCIES AND NOTIFY        ##
#############################################

COUNT_INCONSISTENCIES=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM VisaInfo WHERE visaInfo != 'Visa required' AND visaInfo != 'Visa Not Required' AND visaInfo != 'eVisa' AND visaInfo != 'Admission Refused'")
if [ "${COUNT_INCONSISTENCIES}" -gt 0 ]; then

  # Find any times an incorrect Visa Type slipped through the net
  INCONSISTENCIES=$(${MYSQL_CMD} -N -e "SELECT DISTINCT visaInfo FROM VisaInfo WHERE visaInfo != 'Visa required' AND visaInfo != 'Visa Not Required' AND visaInfo != 'eVisa' AND visaInfo != 'Admission Refused'")

  DATE_FORMAT=$(date +%Y-%m-%d-%H-%M-%S)
  echo -e "Visa Script Ran At: ${DATE} \nInconsistencies were found, the VisaInfo column should consist only of the following entries: 'Visa Required', 'Visa Not Reqired', 'eVisa' and 'Admission Refused'.\n\nBelow is a list of inconsistencies found on the latest Wikipedia scan.\n${INCONSISTENCIES}\n\nPlease add the exceptions above into the 'VISA TYPE FILTERING' section of the scan script." >> /tmp/visaScan-Inconsistencies-${DATE_FORMAT}
  echo -e "\nThere were inconsistencies! Please review the contents of /tmp/visaScan-Inconsistencies-${DATE_FORMAT}\n"

fi
