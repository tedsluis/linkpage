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

# Generated static head of index.tmp
sed -e '/START/q' index.html > index.tmp

# Generate dynamic part of index.tmp
echo '' >> index.tmp
echo '<div class="tab">' >> index.tmp
declare -A SECTION_HASH
declare -A URL_HASH
declare -A TEXT_HASH
declare -A TITLE_HASH
# Read INI file
SECTION=""
COUNT_SECTIONS=0
COUNT_URLS=0
COUNT_SKIPPED=0
COUNT_UNMATCH=0
echo ""
echo "Read url.ini:"
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
		echo "    <button class=\"tablinks\" onclick=\"openTab(event, '$SECTION')\">$SECTION</button>" >> index.tmp
		COUNT_SECTIONS=$(($COUNT_SECTIONS + 1))
	elif [[ $LINE =~ ^# ]] || [[ $LINE =~ ^\s*$ ]]; then
	        COUNT_SKIPPED=$(($COUNT_SKIPPED + 1))
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
			COUNT_URLS=$(($COUNT_URLS + 1))
		else
			COUNT_UNMATCH=$(($COUNT_UNMATCH + 1)) 
		fi
	fi
done < url.ini
echo "number of sections: $COUNT_SECTIONS"
echo "number of URLs: $COUNT_URLS"
echo "number of lines skipped: $COUNT_SKIPPED"
echo "number of lines that didn't match: $COUNT_UNMATCH"
echo '</div>' >> index.tmp
echo '' >> index.tmp

# Generated tab pages
COLOR_NUMBER=0
echo ""
echo "URLs per section:"
for SECTION in $( echo "${!SECTION_HASH[@]}" | tr " " "\n" | sort | tr "\n" " ")
do
	echo -n "$SECTION"
	COLUMN_COUNTER=0
	COUNT_URLS=0
	echo "    <div id=\"$SECTION\" class=\"tabcontent\">" >> index.tmp
        echo '        <div class="divTable blueTable">' >> index.tmp
	for URL in $(echo "${!URL_HASH[@]}" | tr " " "\n" | sort | tr "\n" " ")
	do
		if [[ "$SECTION" == "${URL_HASH[$URL]}" ]]; then
			COLUMN_COUNTER=$(($COLUMN_COUNTER + 1))
			if [[ $COLUMN_COUNTER -eq 1 ]]; then
				echo '            <div class="divTableRow">' >> index.tmp
			fi
			echo "                <div class=\"divTableCell\" title=\"${TITLE_HASH[$URL]}\" style=\"background-color:${COLOR_ARRAY[$COLOR_NUMBER]}\" onclick=\"window.open('${URL}', '_blank');\">${TEXT_HASH[$URL]}</div>" >> index.tmp
			echo -n "."
			COUNT_URLS=$(($COUNT_URLS + 1))
			COLOR_NUMBER=$(($COLOR_NUMBER + 1))
			if [[ $COLOR_NUMBER -gt $MAX_COLORS ]]; then
				COLOR_NUMBER=0
			fi
			if [[ $COLUMN_COUNTER -eq $MAX_COLUMNS ]]; then
				COLUMN_COUNTER=0
				echo '            </div>' >> index.tmp
			fi
		fi
	done
	echo "($COUNT_URLS)"
	if [[ $COLUMN_COUNTER -ne 0 ]]; then
		echo '            </div>' >> index.tmp
	fi
	echo '    </div>' >> index.tmp
	echo '</div>' >> index.tmp
done
echo '' >> index.tmp

# Generate static tail of index.tmp
sed -n -e '/END/,$p' index.html >> index.tmp

# Move index.tmp to index.html
mv -f index.tmp index.html

echo ""
echo "New index.html generated!"
