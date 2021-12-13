#!/bin/bash
sed -i -e 's/\r$//' script.sh # -для запуска скрипта после винды

echo "Your UID is ${UID}"

UID_TO_TEST_FOR='1000'
if [[ "$UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
  echo "Your UID does not match ${UID_TO_TEST_FOR}"
  exit 1
fi

username=$(id -un)
if [[ "${?}" -ne 0 ]] ## ${?} - возвращает статус выполнения предыдущей команды
then 
  echo 'the id command did not exec'
  exit 1
fi
echo "Your username is ${username}"

read -p 'Type new username' USER
read -p 'Type new passwd' PASSWD
useradd -m ${USER}
echo ${PASSWD} | passwd --stdin ${USER}
passwd -e ${USER}

if [[ "${#}" -lt 1 ]] # ${#} - количество аргументов -lt - меньше чем (gt-больше чем..) - проверять количество аргументов во вставке
then 
  echo "используй функцию помощи при ошибке" 
  usage
fi


2>>&1 - перенаправление в 1 файл

if [[ "${1}" = 'start' ]] # - проверяет введенный аргумент, должен быть таким же как внутри ифа
then
  echo 'Starting'
elif [[ "${1}" = 'stop' ]]  # делает кучу условий.
then
  echo 'Stopping'  
fi

case "${1}" in 
  start) echo 'Starting'  ;; # тоже самое, только с кейс
  stop) echo 'Stopping';;
  *) # любые символы, ?- 1 символ, []- группа символов
    echo 'Supply a valid option.' >&2 
	exit 1
	;;
esac

log() {
  local var="${1}"
  if [[ "${var}" = 'true' ]] # проверка получаемой переменной. так понимаю переменная может быть любой, не только 1,2 а из глобал скрипта
  then
    echo 'function'
  fi
}
log 'true'

log 'Hello world'
sudo tail /var/log/massages # команда для записи логов
log -t my-scrypt 'Hello world' # добавляет тег к описанию в файлике
sudo tail /var/log/massages # команда для записи логов

while getops vl:s OPTION
do
  case ${OPTION} in
  v)
    verbose='true'
	echo 'Verbose mode on';;
  l)
    lenght="${OPTARG}";;
  esac
done
	
echo 'one/two/three' | cut -d '/' -f 3
grep '^first' file.sh # начинается с этого слова/символов
grep 't$' file.sh # заканчивается этом симвоом/словом
grep -v '^first,last$' file.sh # только не эти символы что после -v
awk -F ':' '{print "col1: " $1 "col3: " $3 }' #-F - поле-разделитель
awk '{print $1, $2}' file.sh # уберет все лишние пробелы и разделит стороку на столько скрочек сколько нужно.

netstat -tulpn ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
	#мы можем передать сюда арг; после разделения полей они преобр в переменные. ищем 4ю

| sort -n # сортирует по числам правильно
cat /var/log/secure |awk -F 'from ' '{print $2}' #файл с попытками входа в систему удачными и нет. 2 часть делит 'from ' на 2 части. и позволяет нам посмотреть 2ю часть с айпи.
# awk '{print $2}' если не писать -Ф то по умолчянию все делится по пробелам. работает лучше cut
cat /var/log/secure | awk -F ']:' '{print $2}'

awk '{print $(NF - 3)}' # = awk -F 'from ' '{print $2}'| awk '{print $1}'
grep Failed /var/log/secure |awk -F 'from' '{print $2}'| awk '{print $1}'|uniq -c |sort -nr | awk '{print $1, $2}'

tom and jery are best friends
[root@com2 user]# sed 's/friends/enemy/' script-test5.sh  #замена не записывается в файле а идет в стандрт выход s это указывает на разделитель(не обязателен вообще, особено с d)
tom and jery are best enemy
#../enemy/g - глобал - изменения везде все строчки
#../enemy/i - не чувств. к регистру
#../enemy/d - удаляет все строчки где есть слово допустим емеми
echo '/home/jason' |sed 's:/home/jason:/export/user/jason:' # : это разделитель
sed '/^$/d' script-test5 #- удалит все пустые строки

echo '10.9.8.12 server1' | sudo tee -a /etc/hosts # >> не запишет в файлик етс потому что к >> нет приписки судо. | не пускает дальше судо
# !!!создаем клюс ссш-кейген, ыыш-копи-айди - копируем ключ на нужный сервер, можем делать команды на другом сервере - ссш сервер1 хуамай

for SERVER in $(cat servers) do #для всех серверов записанных в файлике сделать переменная SERVER вызывается по очереди для записанных серверов в файлик
ssh ${SERVER} hostname
done

if [[ ! -e "${var}" ]]
then 
..