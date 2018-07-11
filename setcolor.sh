#!/bin/bash
ARR[1]="violet"
ARR[2]="aquamarine"
ARR[3]="yellow"
ARR[4]="blue"
ARR[5]="red"
ARR[6]="purple"
ARR[7]="orange"
ARR[8]="green"
ARR[9]="maroon"
ARR[10]="mediumslateblue"
ARR[11]="palegoldenrod"
ARR[12]="lightcyan"
ARR[13]="olive"
rm index.html
touch index.html
COLORNUMBER=1
while read LINE; do
    if (($COLORNUMBER > 13)); then 
        COLORNUMBER=1;
    fi
    if [[ $LINE = *"class=\"divTableCell\" style=\"background-color:"* ]]; then
        COLOR=${ARR[$COLORNUMBER]}
        echo "$COLORNUMBER:$COLOR:$LINE"
        LINE=$(echo $LINE | sed -e "s/background-color:orange\"/background-color:${COLOR}\"/")
        echo "Replaced:$LINE"
        COLORNUMBER=$((COLORNUMBER+1))
    else
        echo "Keep:$LINE"
    fi
    echo "$LINE" >> index.html
done <index.html.org
