#!/bin/bash 
serverlist='/home/user/hostfile'
usage(){ 
echo "usage: ${0} [-nsv] [-f FILE] command" >&2
echo "executes command as a single command on every server"
echo ' -f List of servers' >&2
echo ' -n ничего не выполняет, просто выводит на экран dry_run' >&2 
echo ' -s Using sudo on remoute server' >&2
echo ' -v Like verbose mode - Display server name before executes command' >&2
exit 1
}

if [[ "${UID}" -eq 0 ]]
then
  echo "DO NOT exec script as root. Use option -s instead" >&2
  usage
fi

while getopts f:nsv OPTION # : f- может принимат собственные аргументы. выступает отдельно. 
do
  case ${OPTION} in # специальная переменная для передоваемых аргументов
  f) serverlist="${OPTARG}" ;; # в нашем случае меняет файлик с хостнемами
  n) dry_run='true' ;;
  s) sudo='sudo' ;;
  v) verbose='true' ;;
  ?) usage ;;
  esac
done
shift "$((OPTIND -1 ))"
# Если не было переданно ни одного аргумента идет функция usage
if [[ "${#}" -lt 1 ]] # если мы передали меньше (-lt 1) аргумента "${#}" -считает колво аргументов. То использовать функцию дл\ выхода из скрипта
then
  usage
fi
# все, что остается в командной строке, должно быть обработано как одна команда
command="${@}"

for SERVER in $(cat ${serverlist}) 
do #для всех серверов записанных в файлике сделать переменная SERVER вызывается по очереди для записанных серверов в файлик
  if [[ "${verbose}" = 'true' ]]
  then
    echo "${SERVER}"
	echo 'Ecxec Verbose Mode:'
  fi
  echo 'say something2'
  if [[ "${dry_run}" = 'true' ]]
  then 
    echo "dry_run: ${SERVER} ${sudo} ${command}"
    echo 'Ecxec Dry Run:'
  else
    ssh ${SERVER} ${sudo} ${command}
    echo 'Ecxec command:'
    echo "exit status ${?}"
    if [[ "${?}" -ne 0 ]] ## ${?} - возвращает статус выполнения предыдущей команды
    then 
      echo 'the id command did not exec' >&2
    fi
  fi
done
echo 'Finish script.'
exit 0
