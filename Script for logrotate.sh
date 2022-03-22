#!/bin/bash
if [[ "${UID}" -ne 0 ]]
then
  echo "You mast be root for doing that"
  exit 1
fi
path='/etc/logrotate.d/server10.log' # Храняться настройки для Ротации логов
read -p 'Write path what would be logging: ' log # То, какой файл будем использовать


usage(){ 
echo 'Transfer the argument to script.'
echo "usage: ${0} [-h, -d, -w, -m] [-f FILE]" >&2
#echo ' -f path to log' >&2
echo ' -h hourly - каждый час;' >&2 
echo ' -d daily - каждый день;' >&2
echo ' -w weekly - каждую неделю;' >&2
echo ' -m monthly - каждый месяц;' >&2
exit 1
}

if [[ ! -e "${path}" ]] # Проверка на существование server10.log
then 
  echo "we have no file ${path} Please use -f option for indicate it. When print any other option."
  exit 1
fi
if [[ ! -e "${log}" ]] # Проверка на существование файла логов
then 
  echo "we have no file ${log} Please use -f option for indicate it"
  exit 1
fi

while getopts f:hdwm OPTION # : f- может принимат собственные аргументы. выступает отдельно. 
do
  case ${OPTION} in # специальная переменная для передоваемых аргументов
  f) path="$OPTARG";; # в нашем случае меняет лог файл с которым будет работать
  h) hourly='true' ;;
  d) daily='true' ;;
  w) weekly='true' ;;
  m) monthly='true' ;;
  ?) usage ;;
  esac
done
# shift "$(( OPTIND -1 ))"
if [[ "${#}" -lt 1 ]] # если мы передали меньше (-lt 1) аргумента "${#}" -считает колво аргументов, То использовать функцию дл\ выхода из скрипта
then
  echo '=====Use one of usage arguments.===== '
  usage
  exit 1
fi
if [[ "${#}" -gt 2 ]] # если мы передали больше (-gt 2) аргумента "${#}" -считает колво аргументов. То использовать функцию дл\ выхода из скрипта
then
  echo 'Use one of usage arguments '
  usage
  exit 1
fi
echo "${@} is arg"
read -p "Set OPTION maxage (write number) " time
for arg in "${@}"
do
  if [[ ${hourly} = 'true' ]]
  then 
    echo "${log}{" > ${path} # Добаляем название нашего лог файла в server10.log и открывающий тег
    echo 'hourly' >> ${path}
  fi
  echo '1'	
  if [[ "${dayly}" = 'true' ]]
  then 
    echo "${log}{" > ${path}
    echo 'daily' >> ${path}
  fi
  echo '2'
  if [[ "${weekly}" = 'true' ]]
  then 
    echo "${log}{" > ${path}
    echo 'weekly' >> ${path}
  fi
  echo '3'
  if [[ "${monthly}" = 'true' ]]
  then 
    echo "${log}{" > ${path}
    echo 'monthly' >> ${path}  
  fi
  echo 'Script done.'
  echo 'rotate 4' >> ${path}
  echo "maxage ${time}" >> ${path} 
  echo '}' >> ${path} # Добаляем закрывающий тег в конце
  count_string=$(wc -l < ${path})
  echo "${count_string}"
  if [[ "${count_string}" != '5' ]] # Проверка на добавление строк в файл
  then
    echo 'Check your file or restart you script with other params. There are something wrong.'
  fi   
done 
exit 0
