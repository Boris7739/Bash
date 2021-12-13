#!/bin/bash
if [[ "${UID}" -ne 0 ]]
then
  echo "You mast be root for doing that"
  exit 1
fi
touch /home/user/file100.log
echo '============================================================'
date >> /home/user/file100.log
echo 'Stopping wildfly..' >> /home/user/file100.log
systemctl stop wildfly >> /home/user/file100.log
if [[ "${?}" -ne 0 ]] ## ${?} - возвращает статус выполнения предыдущей команды
then 
  echo "Wildfly don't stop. Please try again." >> /home/user/file100.log
  exit 1
fi

echo 'Clear tmp folders..' >> /home/user/file100.log
cd /opt/wildfly/standalone/tmp/
rm -rvf /opt/wildfly/standalone/tmp/ >> /home/user/file100.log
echo 'Starting Wildfly...' >> /home/user/file100.log
systemctl start wildfly
echo 'end'
if [[ "${?}" -ne 0 ]] ## ${?} - возвращает статус выполнения предыдущей команды
then 
  echo "Wildfly don't restart. Please try again." >> file1.log
  exit 1
fi