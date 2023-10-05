

#!/bin/bash

# Script to perform local security checks

function checks() {
	if [[ $2 == "" ]]
	then
	current_value="empty"
	else
	current_value=$2
	fi

	if [[ $3 == "" ]]
	then
	current_value="empty"
	else
	current_value=$3
	fi

	if [[ $2 != $3 ]]
	then
		echo "The $1 is not compliant. The policy should be: $2. The current value is $3. Remediation: $4"
	else
		echo "The $1 is compliant. Current value is: $3"
	fi
}

#Check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
#Checking password max
checks "Password Max Days" "365" "${pmax}"

#Check minimum days between password changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Min Days" "14" "${pmin}"

#Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
checks "Password Warn Age" "7" "${pwarn}"

#Check the SSH usePam config
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "${chkSSHPAM}"


#Check permissions on users home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ')
do

	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	checks "Home directory ${eachDir}" "drwx------" "${chDir}"
done

#IP Forwarding and ICMP Redirect checks
chkIP=$(sysctl net.ipv4.ip_forwarding | awk '{print $2}')
checks "IP Forwarding" "0" "${chkIP}" "Edit /etc/sysctl.conf and change the value to 0"

chkICMP=$(sysctl net.ipv4.conf.all.accept_redirects | awk ' { print $2 } ')
checks "ICMP redirects" "0" "${chkICMP}" "Edit /etc/sysctl.conf and change the value to 0"

#Ensuring permissions checks

#Crontab permissions
chkCronT=$(stat /etc/crontab | egrep -i "^Access" | head -n 1)
if [[ ${chkCronT} =  "Access: (0600/-rw-------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
then
p=0
else
p=1
fi
checks "Checking Cron tab permissions" "0" "${p}" "Run these commands as sudo: \n chown root:root /etc/crontab \n chmod og-rwx /etc/crontab \n"

#Cron hourly check
chkCronH=$(stat /etc/cron.hourly | egrep -i "^Access" | head -n 1)
 if [[ ${chkCronH} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
 then
 p=0
 else
 p=1
 fi
 checks "Checking Cron hourly permissions" "0" "${p}" "run these commands for /etc/cron.hourly as sudo: \n chown root:root /etc/cron.hourly \n chmod og-rwx /etc/cron.houlry \n"
#Cron daily check
  cronD_chk=$(stat /etc/cron.daily | egrep -i "^Access" | head -n 1)
  if [[ ${cronD_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
 checks "Checking Cron.daily permissions" "0" "${p}" "run these commands  as sudo: \n chown root:root /etc/cron.daily \n chmod og-rwx /etc/cron.daily \n"
#Cron weekly check
 cronW_chk=$(stat /etc/cron.weekly | egrep -i "^Access" | head -n 1)
  if [[ ${cronW_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
  checks "Checking cron.weekly permissions /etc/cron.weekly" "0" "${p}" "run these commands for /etc/cron.weekly as sudo: \n chown root:root /etc/cron.weekly \n chmod og-rwx /etc/cron.weekly \n"
#Cron monthly check
cronM_chk=$(stat /etc/cron.weekly | egrep -i "^Access" | head -n 1)
if [[ ${cronM_chk} =  "Access: (0700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
then
p=0
else
p=1
fi
checks " Checking cron.monthly permissions /etc/cron.monthly" "0" "${p}" "run these commands for /etc/cron.monthly as sudo: \n chown root:root /etc/cron.monthly \n chmod og-rwx /etc/cron.monthly"
#/etc/passwd check
 passwd_chk=$(stat /etc/passwd | egrep -i "^Access" | head -n 1)
 if [[ ${passwd_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
 then
 p=0
 else
 p=1
 fi
 checks " Checking passwd permissions /etc/passwd" "0" "${p}" "run these commands for /etc/passwd as sudo: \n chown root:root /etc/passwd \n chmod 644 /etc/passwd \n"
#/etc/shadow check
shadow_chk=$(stat /etc/shadow | egrep -i "^Access" | head -n 1)
  if [[ ${shadow_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking shadow permissions /etc/shadow" "0" "${p}" "run these commands for /etc/shadow as sudo: \n chown root:shadow /etc/shadow \n  chmod o-rwx,g-wx /etc/shadow  \n"
#/etc/group check
  group_chk=$(stat /etc/group | egrep -i "^Access" | head -n 1)
  if [[ ${group_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
 checks " Checking group permissions /etc/group" "0" "${p}" "run these commands for /etc/group as sudo: \n chown root:root /etc/group \n  chmod 644 /etc/group  \n"
#/etc/gshadow check
 gshadow_chk=$(stat /etc/gshadow | egrep -i "^Access" | head -n 1)
   if [[ ${gshadow_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
   then
   p=0
   else
   p=1
   fi
   checks " Checking gshadow permissions /etc/gshadow" "0" "${p}" "run these commands for /etc/gshadow as sudo: \n chown root:shadow /etc/gshadow \n  chmod o-rwx,g-wx /etc/gshadow  \n"
#/etc/passwd- check
 passwd1_chk=$(stat /etc/passwd- | egrep -i "^Access" | head -n 1)
  if [[ ${passwd1_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking passwd- permissions /etc/passwd-" "0" "${p}" "run these commands for /etc/passwd- as sudo: \n chown root:root /etc/passwd- \n chmod u-x,go-wx /etc/passwd \n"
#/etc/shadow- check
shadow1_chk=$(stat /etc/shadow | egrep -i "^Access" | head -n 1)
if [[ ${shadow1_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
then
p=0
else
P=1
fi
checks " Checking shadow- permissions /etc/shadow-" "0" "${p}" "run these commands for /etc/shadow- as sudo: \n chown root:shadow /etc/shadow- \n  chmod o-rwx,g-wx /etc/shadow-  \n"
#/etc/group- check
 group1_chk=$(stat /etc/group- | egrep -i "^Access" | head -n 1)
 if [[ ${group1_chk} =  "Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)" ]]
 then
  p=0
   else
 p=1
   fi
    checks " Checking group- permissions /etc/grou-p" "0" "${p}" "run these commands for /etc/group- as sudo: \n chown root:root /etc/group- \n  chmod u-x,go-wx /etc/group  \n"
#/etc/gshadow- check
 gshadow1_chk=$(stat /etc/gshadow- | egrep -i "^Access" | head -n 1)
  if [[ ${gshadow1_chk} =  "Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)" ]]
  then
  p=0
  else
  p=1
  fi
  checks " Checking gshadow- permissions /etc/gshadow-" "0" "${p}" "run these commands for /etc/gshadow- as sudo: \n chown root:shadow /etc/gshadow- \n  chmod o-rwx,g-wx /etc/gshadow-  \n"
#Ensuring no legacy + entries
legacy1=$(grep '^\+:' /etc/passwd)
checks " legacy entries check in /etc/passwd"  "${legacy1}" "Remove any legacy '+' entries from /etc/passwd if they exist."

legacy2=$(grep '^\+:' /etc/shadow)
checks " legacy entries check in /etc/shadow"  "${legacy2}" "Remove any legacy '+' entries from /etc/shadow if they exist."

legacy3=$(grep '^\+:' /etc/group)
checks " legacy entries check in /etc/group"  "${legacy3}" "Remove any legacy '+' entries from /etc/group if they exist."

#Ensuring root is the only UID 0 account
root_chk=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
checks " UID 0 check" "root" "${root_chk}" "Remove any users other than root with UID 0 or assign them a new UID if appropriate."
