#!/bin/bash
TO="UTF-8"; FILE=$1
FROM=$(chardetect $FILE | cut -d' ' -f2)
if [[ $FROM = "binary" ]]; then
 echo "Skipping binary $FILE..."
 exit 0
fi
iconv -f $FROM -t $TO -o $FILE.tmp $FILE; ERROR=$?
if [[ $ERROR -eq 0 ]]; then
  echo "Converting $FILE..."
  mv -f $FILE.tmp $FILE
else
  echo "Error on $FILE"
fi
