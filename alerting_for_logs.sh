#!/bin/bash
path0='/home/user/server.log' # Лог файл который нужно мониторить
count=$(cat count_lenght.txt) # Нужно до скрипта создать файл count_lenght.txt - он будет хранить только пердыдущее(до запуска скрипта) значение числа строчек в файле server.log. count_lenght.txt - изначально содержит 0 строчек 
log=$(wc -l < $path0) # забираем число строчек
def="$(($log - $count))" # Минусуем от старого числа из count_lenght.txt
echo "New row in log: $def"
echo "$log" > count_lenght.txt # Перезаписываем новое число в count_lenght.txt
cat ${path0} | tail -$def | grep 'Error' # Показываем новые строчки из server.log (фильтруем по ошибкам)
mail=$(cat ${path0} | tail -$def | grep 'Error' | wc -l) # Записываем число новых ошибок в переменную
echo "$mail"


if [[ "$mail" != 0 ]]
then
  cat ${path0} | tail -$def | grep 'Error' | mail -v -s "Send Error" bgamaniuk@gmail.com
else
  echo 'all good'
fi
