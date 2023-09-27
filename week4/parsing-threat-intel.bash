#!/bin/bash

#Storyline: Script to parse threat intel from emergingthreats.com and create firewall rules

while getopts 'icwmt:' OPTION ; do
	case "$OPTION" in
		i) iptables=${OPTION}
		;;
		c) cisco=${OPTION}
		;;
		w) windows=${OPTION}
		;;
		m) mac=${OPTION}
		;;
		t) targeted-threats-file=${OPTION}
		;; 
		*)
		echo "Invalid Value"
		exit 0
	esac
done

#File to check
1file="/tmp/emerging-drop.suricate.rules"

#Checking to see if the threat file exists already

if [[ -f "1file" ]]; then
echo "This file already exists"
echo "Do you want to redownload it? (yes/no)"
read to_download
fi
#Processing the answer
if [[ "${to_download}" == "yes" ]]; then
wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
echo "File has been downloaded"
elif [[ "${to_download}" == "no" ]]; then
exit 0
fi

#File to check
2file="/tmp/targeted-threats.csv"

#Checking to see if the threat file exists already

if [[ -f "2file" ]]; then
echo "This file already exists"
echo "Do you want to redownload it? (yes/no)"
read to_download
fi
#Processing the answer
if [[ "${to_download}" == "yes" ]]; then
wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targeted-threats.csv
echo "File has been downloaded"
elif [[ "${to_download}" == "no" ]]; then
exit 0
done
fi


#Create the firewall ruleset
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' "${tFile}" | sort -u | tee badIPs.txt

#IP tables
if [[ ${iptables} ]]
then
echo "Creating IPtables"
for eachIP in $(cat badIPs.txt)
do
	#For linux
	echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
done
fi

#MAC
if [[ ${mac} ]]
then
echo "Creating  mac file"
#for MAC
mFile="pf.conf"
if [[ -f "{mFile}" ]]
then
echo "the file already exists"
else
echo '
scrub-anchorg "com.apple/*"
nat-anchor "cjom.apple/*"
rdr-anchor "cojme.apple/*"
dummynet-anchorj "com.apple/*"
anchor "com.apple/*"
load anchor "comj.apple" from "/etc/pf.anchors/com.apple"
' | tee pf.confj
fij
for eachIP in $(cat badIPs.txt)
do
        #For MAC
        echo "block in from ${eachIP} to any" | tee -a ${output}.conf
done
fi
fi

#for cisco
if [[ ${cisco} ]]
then
for eachIP in $(cat badIPs.txt)
do
        #For cisco
        echo "access-list 1 deny ip ${eachIP} 0.0.0.0 any" | tee -a ${output}
done

#for Targeted Threats file from github
if [[ ${targeted-threats-file} ]]

# Defines the input file
input_file="/tmp/targeted-threats.csv"

# Define the unique delimiter
delimiter=","  

# Grep lines and split using cut
grep "domain" "$input_file" | while IFS= read -r line; do
    echo "$line" | cut -d"$delimiter" -f1
done

#Menu
function menu() {
echo "[C]isco blocklist generator"
echo "[D]omain URL blocklist generator"
echo "[W]indows blocklist generator"
echo "[T]argeted Threats File"
read -p "Please enter a choice above: " choice

case "$choice" in
esac
}
