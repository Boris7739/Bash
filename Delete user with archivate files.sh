#!/bin/bash
archive_dir='/archive'

usage(){ # функция которая выполняется если в аргументы передали не то что нужно. выводим на экран стандартный еррор 
echo "usage: ${0} [-dra] usre [USERN]..." >&2
echo ' -d DELETE' >&2
echo ' -r REMOVE' >&2
echo ' -a ARCHIVE' >&2
exit 1
}

if [[ "${UID}" -ne 0 ]] 
then
  echo "Your UID does not match root uid" >&2 
  echo "You aren't root"
  exit 1
else
  echo "You are root" 
fi
  
while getopts dra option # getopts принимает аргументы и складывает их в переменную оптион
do 
  case ${option} in 
    d) DELETE_USER='true' ;;
	r) REMOVE_OPTION='-r' ;;
	a) ARCHIVE='true' ;;
	?) usage ;;
  esac
done

shift "$(( OPTIND -1 ))" # меняет введеный ключ (./script2.sh -d -a lo в цикле влево)

# Если не было передано ни одного аргумента идет функция usage
if [[ "${#}" -lt 1 ]] # если мы передали меньше (-lt 1) аргумента "${#}" -считает кол-во аргументов. То использовать функцию для выхода из скрипта
then
  usage
fi

# цикл через все имена пользователей, указанные в качестве аргументов
for username in "${@}" # "${@}" проверяет все переданные параметры (./script2.sh -d -a lo)
do
  echo "Processing user ${username}" 
  userid=$(id -u ${username}) # записываем в переменную id юзера которого собираемся удалять/архивировать
  if [[ "${userid}" -lt 1000 ]] # созданные руками юзеры имеют айди от 1000. т. е мы проверяем что это не системный юзер
  then
    echo "Refusing to remove ${username} his have UID = ${userid}" >&2
	exit 1
  fi
  # IF ARG = ARCHIVE
  if [[ "${ARCHIVE}" = 'true' ]] # 3
  then
   # CHECK that archive is exist
    if [[ ! -d "${archive_dir}" ]] # 4 если не существует (!(логический оператор. только он и используется man test) директории (-d(есть список таких стандартных ключей. он содержит первые буквы названий типов файлов) которая задана переменной 
    then 
	  echo "Create ${archive_dir} dir"
	  # MAKE DIR
	  mkdir -p ${archive_dir}
	  if [[ "${?}" -ne 0 ]] ## ${?} - возвращает статус выполнения предыдущей команды
	  then 
		echo 'the ARCHIVE did not exec' >&2
		exit 1
	  fi
	fi # 4
    Home_dir="/home/${username}"
    archive_file="${archive_dir}/${username}.tgz"
    if [[ -d "${Home_dir}" ]] # если есть такая директория, то: 5
    then 
    # АРХИВИРУЕМ
      echo "archive ${Home_dir} to ${archive_file}"
	  tar -zcf ${archive_file} ${Home_dir} &> /dev/null
	  if [[ "${?}" -ne 0 ]] ## ${?} - возвращает статус выполнения предыдущей команды
	  then 
		echo 'the command did not archive' >&2
		exit 1
	  fi
    else # 5
	  echo "${Home_dir} does not exist." >&2
	  exit 1
	fi # 5
  fi # 3
  
  if [[ "${DELETE_USER}" = 'true' ]] # переменная на удаление юзера
  then
    userdel ${REMOVE_OPTION} ${username} 
	if [[ "${?}" -ne 0 ]] 
	then 
	  echo 'the command did not delete' >&2
	  exit 1
	fi
	echo 'the acc was deleted'
  fi
done
exit 0
