#!/bin/bash

# Maximum numbers of columns per row
MAX_COLUMNS=4

# Define colors
COLOR_ARRAY[0]="lime"
COLOR_ARRAY[1]="violet"
COLOR_ARRAY[2]="aquamarine"
COLOR_ARRAY[3]="yellow"
COLOR_ARRAY[4]="blue"
COLOR_ARRAY[5]="red"
COLOR_ARRAY[6]="orange"
COLOR_ARRAY[7]="darkviolet"
COLOR_ARRAY[8]="green"
COLOR_ARRAY[9]="pink"
COLOR_ARRAY[10]="mediumslateblue"
COLOR_ARRAY[11]="goldenrod"
COLOR_ARRAY[12]="navajowhite"
COLOR_ARRAY[13]="olive"
COLOR_ARRAY[14]="moccasin"
COLOR_ARRAY[15]="lightgreen"
COLOR_ARRAY[16]="lavender"
MAX_COLORS=$(( ${#COLOR_ARRAY[@]} - 1 )) 

# Generated static head of index.html
sed -e '/START/q' index.org > index.html

# Generate dynamic part of index.html
echo '' >> index.html
echo '<div class="tab">' >> index.html
declare -A SECTION_HASH
declare -A URL_HASH
declare -A TEXT_HASH
declare -A TITLE_HASH
# Read INI file
SECTION=""
while IFS='' read -r LINE || [[ -n "$LINE" ]]
do
	URL=""
	TEXT=""
	TITLE=""
	if [[ $LINE =~ ^\[(.+)\]$ ]]; then
		SECTION=${BASH_REMATCH[1]}
		SECTION=$(echo $SECTION | sed 's/[ ]/-/'g)
		SECTION_HASH+=( [$SECTION]="" )
		# Generate tabs
		echo "    <button class=\"tablinks\" onclick=\"openTab(event, '$SECTION')\">$SECTION</button>" >> index.html
	elif [[ $LINE =~ ^# ]] || [[ $LINE =~ ^\s*$ ]]; then
	       echo "Skip line."	
	else
		# Generate URL, TEXT and TITLE
		IFS=';' read -ra FIELD <<< "$LINE"
		if [[ ${!FIELD[@]} =~ 0 ]] && [[ ${FIELD[0]} =~ ^.+$ ]]; then
                        URL=${FIELD[0]}
			URL_HASH+=( [$URL]=$SECTION )
			if [[ ${!FIELD[@]} =~ 1 ]] && [[ ${FIELD[1]} =~ ^.+$ ]]; then
                        	TEXT=${FIELD[1]}
			else
				TEXT=$URL
			fi
			if [[ $TEXT != $URL ]]; then
				TITLE=($URL)
			fi
			if [[ ${!FIELD[@]} =~ 2 ]] && [[ ${FIELD[2]} =~ ^.+$ ]]; then
				TITLE="${FIELD[2]} $TITLE"
			fi
			TEXT_HASH+=( [$URL]=$TEXT )
			TITLE_HASH+=( [$URL]=$TITLE )
			echo "URL=$URL TEXT=$TEXT TITLE=$TITLE"
		else
			echo "geen match: LINE=$LINE, FIELD=${!FIELD[@]}, FIELD1=${FIELD[0]}" 
		fi
	fi
done < url.ini
echo '</div>' >> index.html
echo '' >> index.html

# Generated tab pages
COLOR_NUMBER=0
for SECTION in $( echo "${!SECTION_HASH[@]}" | tr " " "\n" | sort | tr "\n" " ")
do
	COLUMN_COUNTER=0
	echo "    <div id=\"$SECTION\" class=\"tabcontent\">" >> index.html
        echo '        <div class="divTable blueTable">' >> index.html
	echo "SECTION=$SECTION"
	for URL in $(echo "${!URL_HASH[@]}" | tr " " "\n" | sort | tr "\n" " ")
	do
		if [[ "$SECTION" == "${URL_HASH[$URL]}" ]]; then
			COLUMN_COUNTER=$(($COLUMN_COUNTER + 1))
			echo "COLUMN_COUNTER=$COLUMN_COUNTER SECTION=$SECTION URL=$URL SECTION=${URL_HASH[$URL]} COLOR_NUMBER=$COLOR_NUMBER COLOR=${COLOR_ARRAY[$COLOR_NUMBER]}";
			if [[ $COLUMN_COUNTER -eq 1 ]]; then
				echo '            <div class="divTableRow">' >> index.html
			fi
			echo "                <div class=\"divTableCell\" title=\"${TITLE_HASH[$URL]}\" style=\"background-color:${COLOR_ARRAY[$COLOR_NUMBER]}\" onclick=\"window.open('${URL}', '_blank');\">${TEXT_HASH[$URL]}</div>" >> index.html
			COLOR_NUMBER=$(($COLOR_NUMBER + 1))
			if [[ $COLOR_NUMBER -gt $MAX_COLORS ]]; then
				COLOR_NUMBER=0
			fi
			if [[ $COLUMN_COUNTER -eq $MAX_COLUMNS ]]; then
				COLUMN_COUNTER=0
				echo '            </div>' >> index.html
			fi
		fi
	done
	if [[ $COLUMN_COUNTER -ne 0 ]]; then
		echo '            </div>' >> index.html
	fi
	echo '    </div>' >> index.html
	echo '</div>' >> index.html
done
echo '' >> index.html

# Generate static tail of index.html
sed -n -e '/END/,$p' index.org >> index.html
