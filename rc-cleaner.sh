#!/bin/bash


FORMATFILE=image/png
TMPFILE=/tmp/recently-used.xbel

# for next update
# if [[ -z "$1" ]]; then
#     #echo "Please enter specific format pattern to be removed from list"
#     exit 1
# fi

# check toolkit
if [ ! -f $(which xmlstarlet) ]; then  
    #echo "\nxmlstarlet not found! \nPlease install xmlstarlet package first.\n"; 
    exit 1 
fi

# find xbel
if [ -f ~/.local/share/recently-used.xbel ]; then
    #echo "recently-used.xbel found" 
    RUX=~/.local/share/recently-used.xbel 
    #echo "Location: $RUX \n"
    
    #echo "Create backup ..."
    cp $RUX $RUX.backup
    sleep 1
    if [ -f $RUX.backup ]; then
        # echo Backup created
        echo
    else
        #echo "Something wrong, can't create a backup" 
        exit 1
    fi

    #removing recent file
    # #echo "\nLooking for $FORMATFILE from recently list ..."
    DIRTCOUNT=$(cat $RUX | grep $FORMATFILE | wc -l)
    
    if [ $DIRTCOUNT > 0 ]; then
        #echo "Found $(( $DIRTCOUNT / 2 )) PNG recent files in list"
        #echo "Clearing now ..."
        cat $RUX | xmlstarlet ed -d '//xbel/bookmark[info[metadata[mime:mime-type[@type="image/png"]]]]' > $TMPFILE
        cat $TMPFILE > $RUX
        sleep 1
        #echo "\nDone"

        zenity --notification --text="Clearing $(( $DIRTCOUNT / 2 )) PNG(s) from list, done"
        exit 0
    else
        #echo "No $FORMATFILE found in list. \nExit now"
        exit 1
    fi


    
else
    zenity --timeout 15 --notification --text="recently-used.xbel not found, this script is useless"
    exit 1
fi