#!/bin/bash

# Parse Apache Log

# Arguments using the pattern, they start at $1
APACHE_LOG="$1"

# Check if file exists
if [[ ! -f ${APACHE_LOG} ]]; then
    echo "Please specify the path to a log file"
    exit 1
fi

# Looking for web scanners
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-15s\n" }
{ printf format, $1}' | \
sort -u | \
tee badIPs.txt
echo "Generating IPtables"
for eachIP in $(cat badIPs.txt)
do
	#For linux
	echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
done

echo "All work is done"
