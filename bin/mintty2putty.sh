#!/bin/sh

transline()
{
    color=$(echo $1 | cut -d '=' -f 2)
    echo '"Colour'$2'"="'$color'"' | awk -F'"' '{print $2"\\"$4"\\"}'
}
cat $1 | while read line
do
    case $line in
        ForegroundColour*)
            transline $line 0
            transline $line 1
            transline $line 5
        ;;
        BackgroundColour*)
            transline $line 2
            transline $line 3
            transline $line 4
        ;;
        Black*)
            transline $line 6
        ;;
        BoldBlack*)
            transline $line 7
        ;;
        Red*)
            transline $line 8
        ;;
        BoldRed*)
            transline $line 9
        ;;
        Green*)
            transline $line 10
        ;;
        BoldGreen*)
            transline $line 11
        ;;
        Yellow*)
            transline $line 12
        ;;
        BoldYellow*)
            transline $line 13
        ;;
        Blue*)
            transline $line 14
        ;;
        BoldBlue*)
            transline $line 15
        ;;
        Magenta*)
            transline $line 16
        ;;
        BoldMagenta*)
            transline $line 17
        ;;
        Cyan*)
            transline $line 18
        ;;
        BoldCyan*)
            transline $line 19
        ;;
        White*)
            transline $line 20
        ;;
        BoldWhite*)
            transline $line 21
        ;;
    esac;
done

# 1. trans mintty color to putty
# sh mintty2putty.sh dracula.minttyrc > dracula.putty

# 2. trans putty color to putty tray
#cat dracula.putty | awk -F'"' '{print $2"\\"$4"\\"}' > dracula.puttytray

