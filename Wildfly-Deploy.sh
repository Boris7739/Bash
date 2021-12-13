#!/bin/bash 
if [[ "${UID}" -ne 0 ]]
then
  echo "You mast be root for doing that"
  exit 1
fi

read -p "Set your file .war to deploy: " war
read -p "what would we do? Deploy[d]/Undeploy[u] " act
if [[ "${act}" = 'd' ]]
then 
  echo 'deploy'
  cd /opt/wildfly/bin/
  echo "Processing..."
  ./jboss-cli.sh --connect --user=linuxize --password=linuxizelinuxize --command="deploy ${war}"
 
elif [[ "${act}" = 'u' ]]
then
  cd /opt/wildfly/bin/
  echo "Processing..."
  ./jboss-cli.sh --connect --user=linuxize --password=linuxizelinuxize --command="undeploy ${war}"
  echo 'undeploy'
else
  echo 'Choose option'
  exit 1
fi
if [[ "${?}" -ne 0 ]] ## ${?} - возвращает статус выполнения предыдущей команды
then 
  echo "Wildfly don't start. Please try again." >&2
  exit 1
fi