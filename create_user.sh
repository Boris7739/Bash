#!/bin/bash
UID_TO_TEST_FOR='0'
if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
  echo "Your UID does not match ${UID_TO_TEST_FOR}" >&2 # not used things just for example
  echo "You aren't root"
  exit 1
else
  echo "You are root" 
fi
echo "prodoljaem"
read -p 'Username: ' user
mkdir /home/$user
adduser $user  -b /home/$user
read -p "Type to add group for new user[Wirte 'n' to skip]: " group
if  [[ $group = 'n' ]]
then
  echo "add group was skip"
else
  usermod -aG $group $user
fi
if [[ "${?}" -ne 0 ]]
then 
  echo 'the command did not exec (Try type REAL group)' >&2
  exit 1
fi
echo "User create"
passwd=$(date +%s%N | sha256sum |head -c48)
echo ${passwd} | passwd --stdin ${user}
passwd -e ${user}
if [[ "${?}" -ne 0 ]] 
then 
  echo 'the command did not exec' >&2
  exit 1
fi
echo "Password added"
read -p 'Is this user have sudo privileges [0-NO 1-YES]: ' sudofile 
if  [[ "$sudofile" = 1 ]]
then 
  echo "${user} ALL=(ALL) ALL" >> /etc/sudoers
  echo "${user} have root rights"
else
  echo "${user} have no root rights"
fi
echo -e "User: ${user} \n
Password: ${passwd} \n
Group: ${group} \n
Sudofile: ${sudofile}"

