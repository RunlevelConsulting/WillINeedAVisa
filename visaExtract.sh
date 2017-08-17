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
  if [[ "$?" -ne 0 ]]; then echo -e "\nTable data failed to import. Does user '${DB_USERNAME}' have privileges to create tables on the ${DB_DATABASE} database?\n"; exit 5; fi

fi

# If DB does exist, ensure initial data exists
COUNT_COUNTRIES=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM Countries")
COUNT_COUNTRIESALIASES=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM CountriesAliases")
if [[ "${COUNT_COUNTRIES}" -eq 0 || "${COUNT_COUNTRIESALIASES}" -eq 0 ]];  then
  ${MYSQL_CMD} < $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/visaExtractDB.sql
fi














#############################################
## GET LOCAL COPY OF DB                    ##
#############################################

# We take a local copy of whatever currently exists in the database.
# This means we don't have to check every curl'd record against the live DB, only update or insert if it doesn't already exist on the local.
#
DB_LOCAL=$(${MYSQL_CMD} -N -e "SELECT countryFromId, countryToId, VisaInfo, additionalInfo FROM VisaInfo;" | sed 's/\t/,/g')



#############################################
## GET THINGS STARTED                      ##
#############################################

# For each entry in the 'Countries' table...
${MYSQL_CMD} -BNr -e "SELECT * FROM Countries $ADD ORDER BY country ASC;" | while IFS=$'\t' read DB_ID DB_COUNTRY DB_LINK;
do

  # Grab Wikipedia page and make it vaguely iterable
  #
  # 1. pup - grabs the first table with the class 'sortable'
  # 2. pup - converts it to JSON
  # 3. sed - jq hates selectors with a hyphen so get rid of those
  # 4. jq - Hone down onto the area we want and iterate
  # 5. tail - Remove first line of output, it's the table header row
  #
  FILTER=$(curl -s --compressed "${DB_LINK}"  | pup -i 0 '.sortable' | pup json{} | sed 's/data-src/src/g' | jq -c '.[0].children[0].children[1].children[0].children[0].children[]' | tail -n +2)


  while read i; do

    ########################################################################
    ## COUNTRY CAPTURE                                                    ##
    ########################################################################

    # Got to pipe this output, example output: //upload.wikimedia.org/wikipedia/en/thumb/0/05/Flag_of_Brazil.svg/22px-Flag_of_Brazil.svg.png
    # We need to extract the country name, this is awfully hacky but it does work
    #
    # 1. rev - Reverse the entire thing = gnp.gvs.lizarB_fo_galF-xp22/gvs.lizarB_fo_galF/50/0/bmuht/ne/aidepikiw/gro.aidemikiw.daolpu//
    # 2. cut - Extract everything before the first slash = gnp.gvs.lizarB_fo_galF-xp22
    # 3. rev - Unreverse it = 22px-Flag_of_Brazil.svg.png
    # 4. grep - Extract everything between the words 'Flag_of_' and '.svg' = Brazil
    # 5. sed - Remove underscores (for names with multiple words) and remove the word 'the' from any names beginning with 'the' (e.g The Bahamas)
    #
    COUNTRYFILTER="| rev | cut -d '/' -f1 | rev | grep -o -P '(?<=Flag_of_).*(?=.svg)' | sed -e 's/_/ /g' -e 's/^the //g'"

    # Due to small differences in the layout of Wikipedia tables we have to try a few times to get the right field
    #
    GRABCOUNTRY=$(echo "$i" | jq -r '.children[0].children[0].children[1].src'); TOCOUNTRY=$(eval echo "${GRABCOUNTRY}" ${COUNTRYFILTER})
    if [[ ${TOCOUNTRY} == '' ]]; then	GRABCOUNTRY=$(echo "$i" | jq -r '.children[0].children[1].children[0].children[1].src'); TOCOUNTRY=$(eval echo "$GRABCOUNTRY" ${COUNTRYFILTER}); fi
    if [[ ${TOCOUNTRY} == '' ]]; then	GRABCOUNTRY=$(echo "$i" | jq -r '.children[0].children[0].children[0].children[1].src'); TOCOUNTRY=$(eval echo "$GRABCOUNTRY" ${COUNTRYFILTER}); fi



    ########################################################################
    ## ALIAS CHECK                                                        ##
    ########################################################################

    # Check resulting country name exists against 'Countries' table
    # Some countries can be referred to by more than one name (e.g - Republic of China / People's Republic of China).
    # Others are countries in their own right but use the visa system of a larger associated state (e.g Niue -> New Zealand)
    # In these cases, we refer to the 'CountriesAliases' table and hope there's a corresponding entry pointing us to the correct 'Countries' row id.

    # Does country exist in 'Countries'?
    TOCOUNTRY_COUNT=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM Countries WHERE country=\"${TOCOUNTRY}\"")

    # If it does exist, grab ID
    if [ $TOCOUNTRY_COUNT -eq 1 ]; then
      TOCOUNTRYID=$(${MYSQL_CMD} -N -e "SELECT id FROM Countries WHERE country=\"${TOCOUNTRY}\"")
    fi

    # If not, check 'CountriesAliases', if still no luck, throw error
    if [ $TOCOUNTRY_COUNT -eq 0 ]; then
      ALIAS_COUNT=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM CountriesAliases WHERE alias=\"${TOCOUNTRY}\"")

      if [ $ALIAS_COUNT -eq 1 ]; then
        TOCOUNTRYID=$(${MYSQL_CMD} -N -e "SELECT countryId FROM CountriesAliases WHERE alias=\"${TOCOUNTRY}\"")
      else
        echo -e "Problem: $TOCOUNTRY doesn't exist - ${DB_LINK}\nPlease input ${TOCOUNTRY} into the CountriesAliases table in your database.}"; exit 6;
      fi

    fi



    ########################################################################
    ## VISA TYPE CAPTURE                                                  ##
    ########################################################################

    # Grab visa type (Visa Required, eVisa, etc), again variations in HTML mean it sometimes takes a few attempts
    # Sometimes there's a bit of malformed HTML so quickly remove that with sed
    # This section of the code is pretty horrible and the less said about it, the better.
    #
    VISATEXT=$(echo $i | jq -r '.children[1].text' | sed 's/&lt;$//gi') # Catches 99% of entries
    if [[ "$VISATEXT" == null || "$VISATEXT" == '' ]];  then		VISATEXT=$(echo $i | jq -r '.children[1].children[0].text' | sed 's/&lt;$//gi');   		fi # Some outputs will have an '!', these are display:none elements, we don't want these
    if [[ "$VISATEXT" == *"!"* || "$VISATEXT" == '' ]]; then		VISATEXT=$(echo $i | jq -r '.children[1].children[1].text' | sed 's/&lt;$//gi');   		fi # So change the extracted text
    if [[ "$VISATEXT" == null || "$VISATEXT" == '' ]]; then		VISATEXT=$(echo $i | jq -r '.children[1].children[1].children[0].text' | sed 's/&lt;$//gi');   	fi # Still doesn't get anything?
    if [[ "$VISATEXT" == '' ]]; then					VISATEXT=$(echo $i | jq -r '.children[1].children[1].text' | sed 's/&lt;$//gi');   		fi # This catches the last of them

    # Validation
    VISATEXT=$(echo "$VISATEXT" | sed 's/"/\&#34;/g' | tr -d -c '[:alnum:]:/\-?.=£*()[]#+&;_!@%\\ ')



    #############################################
    ## VISA INFO CAPTURE                       ##
    #############################################

    # Grabs info on the length of stay.
    # sed - Grab any number if it's followed by the word Day(s) or Month(s)
    #
    INFO=$(echo $i | jq -r '.children[2].text' | egrep -i -o '^[0-9]\w (Day(s|)|Month(s|))$')

    # Validation
    INFO=$(echo "$INFO" | sed 's/"/\&#34;/g' | tr -d -c '[:alnum:]:/\-?.=£*()[]#+&;_!@%\\ ')



    #############################################
    ## VISA TYPE FILTERING                     ##
    #############################################

    # Sadly because we're dealing with user-created content, it tends to be full of inconsistencies
    # This is the part of the code you might need to add to every now and then, don't blame me for how hideous this looks
    # Also, a few rules are kind of one-or-the-other (e.g "Visa on arrival or E-Visa"), I err on the side of caution (eVisa)

    # Get rid of text that's never useful
    VISATEXT=$(echo $VISATEXT | sed 's/ (Conditional)//gi')
    VISATEXT=$(echo $VISATEXT | sed 's/ (temporary)//gi')
    VISATEXT=$(echo $VISATEXT | sed 's/^Free //gi')

    # eVisa Section
    if [[ $VISATEXT = "EVisa"* ]]; then       VISATEXT="eVisa";       fi
    if [[ $VISATEXT = "Electronic"* ]]; then  VISATEXT="eVisa";       fi
    if [[ $VISATEXT = "E-"* ]]; then  VISATEXT="eVisa";       fi
    if [[ $VISATEXT = "e-"* ]]; then  VISATEXT="eVisa";       fi
    if [[ $VISATEXT = *"e600"* ]]; then  VISATEXT="eVisa";       fi
    VISATEXT=$(echo $VISATEXT |  sed -e 's/ASAN Electronic Visa/eVisa/gi' -e 's/On-line registration or eVisa/eVisa/gi' -e 's/eVisa required/eVisa/gi' -e 's/eVisitor/eVisa/gi' -e 's/^eTA$/eVisa/gi' -e 's/Online registration or eVisa/eVisa/gi' -e 's/Visa On Arrival in advance/eVisa/gi' -e 's/Visa on arrival or E-Visa/eVisa/gi' -e 's/Reciprocity fee in advance/eVisa/gi' -e 's/eVisa &amp; Visa on Arrival/eVisa/gi')

    # Visa Section
    # Lots of different phrases refer to the same thing. Change them all to 'Visa'
    VISATEXT=$(echo $VISATEXT | sed -e 's/Entry Permit/Visa/gi' -e 's/Entry Clearance/Visa/gi' -e 's/Visitor&#39;s Permit/Visa/gi' -e 's/^Permit/Visa/gi' -e 's/Tourist Card/Visa/gi' -e 's/Travel Certificate/Visa/gi')

    # Visa Not Reqired
    if [[ $VISATEXT = *"reciprocity fee"* ]]; then	VISATEXT="Visa Not Required";   fi
    if [[ $VISATEXT = *"Visa On Arr"* ]]; then	VISATEXT="Visa Not Required"; 	fi
    if [[ $VISATEXT = *"Visa on arr"* ]]; then	VISATEXT="Visa Not Required"; 	fi
    if [[ $VISATEXT = *"visa on arr"* ]]; then	VISATEXT="Visa Not Required"; 	fi
    if [[ $VISATEXT = "Visa not req"* ]]; then	VISATEXT="Visa Not Required"; 	fi
    VISATEXT=$(echo $VISATEXT | sed -e 's/Visa Waiver Program/Visa Not Required/gi' -e 's/Freedom of movement/Visa Not Required/gi' -e 's/Multiple-entry visa on arrival/Visa Not Required/gi' -e 's/Visa is granted on arrival/Visa Not Required/gi' -e 's/Visa arrival/Visa Not Required/gi' -e 's/Visa not$/Visa Not Required/gi')

    # Visa Required
    if [[ $VISATEXT = "Visa req"* ]]; then	VISATEXT="Visa Required"; fi # People actually misspell the word "required"...
    VISATEXT=$(echo $VISATEXT | sed -e 's/Visa or eTA required/Visa Required/gi' -e 's/Special provisions/Visa Required/gi' -e 's/Admission partially refused \/ partially allowed/Visa Required/gi' -e 's/Affidavit of Identity required/Visa Required/gi' -e 's/Visa is required/Visa Required/gi' -e 's/Visa on arrival but prior approval required/Visa Required/gi' -e 's/Visa de facto required/Visa Required/gi' -e 's/Special authorization required/Visa Required/gi' -e 's/Disputed/Visa Required/gi')

    # Entry Not Permitted
    if [[ $VISATEXT = "Entry Not Permitted "* ]]; then	VISATEXT="Entry Not Permitted";	fi
    VISATEXT=$(echo $VISATEXT | sed -e 's/Admission refused/Entry Not Permitted/gi' -e 's/Invalid passport/Entry Not Permitted/gi' -e 's/Not recognized/Entry Not Permitted/gi' -e 's/Travel Banned/Entry Not Permitted/gi')

    # Random - This is where entries are just completely off and you have to add a manual exception
    if [[ $VISATEXT = "With "* ]]; then	VISATEXT="Visa Required"; 	fi



    #############################################
    ## VALIDATE AND ADD TO DB                  ##
    #############################################

    echo "$DB_COUNTRY ($DB_ID) to $TOCOUNTRY ($TOCOUNTRYID) - $VISATEXT - $INFO"

    # Check against local DB pull, if it's different then update or add
    CHECKFORSTRING="${DB_ID},${TOCOUNTRYID},${VISATEXT},${INFO}"
    echo "${DB_LOCAL}" | grep -i -q "${CHECKFORSTRING}"

    if [ $? -ne 0 ];then

      DOESITEXIST=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM VisaInfo WHERE countryFromId=\"${DB_ID}\" AND countryToId=\"${TOCOUNTRYID}\"")
      if [ $DOESITEXIST -eq 0 ]; then
        ${MYSQL_CMD} -N -e "INSERT INTO VisaInfo (countryFromId, countryToId, visaInfo, additionalInfo) VALUES ('${DB_ID}', '${TOCOUNTRYID}', '${VISATEXT}', '${INFO}')"
      else
        ${MYSQL_CMD} -N -e "UPDATE VisaInfo SET visaInfo='${VISATEXT}', additionalInfo='${INFO}' WHERE countryFromId='${DB_ID}' AND countryToId='${TOCOUNTRYID}'"
      fi

    fi


  done < <(echo "${FILTER}")

done




#############################################
## CHECK INCONSISTENCIES AND NOTIFY        ##
#############################################

COUNT_INCONSISTENCIES=$(${MYSQL_CMD} -N -e "SELECT count(*) FROM VisaInfo WHERE visaInfo != 'Visa required' AND visaInfo != 'Visa Not Required' AND visaInfo != 'eVisa' AND visaInfo != 'Entry Not Permitted'")
if [ "${COUNT_INCONSISTENCIES}" -gt 0 ]; then

  # Find any times an incorrect Visa Type slipped through the net
  INCONSISTENCIES=$(${MYSQL_CMD} -N -e "SELECT DISTINCT visaInfo FROM VisaInfo WHERE visaInfo != 'Visa required' AND visaInfo != 'Visa Not Required' AND visaInfo != 'eVisa' AND visaInfo != 'Entry Not Permitted'")

  DATE_FORMAT=$(date +%Y-%m-%d-%H-%M-%S)
  echo -e "Visa Script Ran At: ${DATE} \nInconsistencies were found, the VisaInfo column should consist only of the following entries: 'Visa Required', 'Visa Not Reqired', 'eVisa' and 'Entry Not Permitted'.\n\nBelow is a list of inconsistencies found on the latest Wikipedia scan.\n${INCONSISTENCIES}\n\nPlease add the exceptions above into the 'VISA TYPE FILTERING' section of the scan script." >> /tmp/visaScan-${DATE_FORMAT}
  echo -e "\nThere were inconsistencies! Please review the contents of /tmp/visaScan-${DATE_FORMAT}\n"

fi
