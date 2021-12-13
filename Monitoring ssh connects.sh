#!/bin/bash
if [[ "${UID}" -ne "0" ]]
then
  echo "Your UID does not match with 0"
  echo 'you are not root'
  exit 1
fi
limit='1'


grep 'Failed p' /var/log/secure |awk -F 'from' '{print $2}'| awk '{print $1}'|uniq -c |sort -nr | awk '{print $1, $2}' | while read count ip 
do
  if [[ "$count" -gt "${limit}" ]]
  then
    location=$(geoiplookup ${ip})
	echo "${count}" "${ip}" "${location}" 
	echo "${count}" "${ip}" "${location}" >> /etc/hosts.deny
  fi
done
exit 0
	
