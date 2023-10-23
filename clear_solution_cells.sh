#!/bin/bash

if [ $# -lt 1 ]; then
        echo "$0 INPUT_FILENAME"
        exit
fi

INPUT=$1
OUTPUT=${INPUT%_*}.ipynb


if [ -f $OUTPUT ]; then
    # set shell to ignore case when matching y/n options
    shopt -s nocasematch
    while true; do
        read -p  "The script will overwrite ${OUTPUT}. Do you want to continue [Y/n]? " ovwr_opt
        if [ "$ovwr_opt" == "n" ]; then
            exit
        elif [ "$ovwr_opt" == "y" ]; then
            echo "Ovewriting $OUTPUT"
            break
        else
            echo "Invalid option."
        fi
    done
    # Go back to regular case matching
    shopt -u nocasematch
fi


KEYWORD="#SOLUTION"

echo $INPUT "to" $OUTPUT

cat $INPUT | jq "del(.cells[] | select(any(.source[]; contains(\"${KEYWORD}\"))))" | sed -e 's/_complete//' > $OUTPUT