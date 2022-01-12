#!/bin/bash
path0='/home/user/server.log'
count=$(cat count_lenght.txt)
log=$(wc -l < $path0)
def="$(($log - $count))"
echo "New row in log: $def"
echo "$log" > count_lenght.txt
cat ${path0} | tail -$def | grep 'Error'
mail=$(cat ${path0} | tail -$def | grep 'Error' | wc -l)
echo "$mail"


if [[ "$mail" != 0 ]]
then
  cat ${path0} | tail -$def | grep 'Error' | mail -v -s "Send Error" bgamaniuk@gmail.com
else
  echo 'all good'
fi
