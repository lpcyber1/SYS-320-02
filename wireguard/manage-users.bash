
#!/bin/bash

#Storyline: Script to manage users and other VPN functions

file="wg0.conf"
check_user_in_file() {

#Check if a user is in the wg0.conf file
echo "What is the name? " 
read name

if grep -q "$name" "$file"; then
	echo "This peer is in the file"
else
	echo "This peer is NOT in the file or there was a misinput"
fi

}

#Function to add or delete user
add_or_delete_user() {
while getopts 'hdau:' OPTION ; do
	case "$OPTION" in
		d) u_del=${OPTION}
		;;
		a) u_add=${OPTION}
		;;
		u) t_user=${OPTION}
		;;
		h)
			echo ""
			echo "Usage: ($basename $0) [-a] | [-d] -u username"
			echo ""
			exit 1
		;;

		*)
			echo "Invalid value"
			exit 1
		;;
	esac
done

# Check to see if the -a and the -d are empty or if they are both specified throw an error
if [[  (${u_del} == "" && ${u_add} == "") || (${u_del} != "" && ${u_add} != "")  ]]
then
	echo "Please specify -a or -d and the -u and username"
fi


# Check to see if -u is specified
if [[ (${u_del} != "" || ${u_add} != "" && ${t_user} == "") ]]
then
	echo "Please specify a user with -u"
        echo "Usage: ($basename $0) [-a] | [-d] -u username"
	exit 1
fi

#Delete a user
if [[ ${udel} ]]
then
	echo "Deleting user..."
	sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf
fi

# Add a user
if [[ ${u_add} ]]
then
	echo "Create the user..."
	bash peer.bash ${t_user}
fi

}

#List open network sockets
list_open_network_sockets() {
while getopts 'tcpudplnh:' OPTION ; do
        case "$OPTION" in
                tcp) tcp_list=$OPTION
                ;;
                udp) udp_list=$OPTION
                ;;
                l) listeing_list=$OPTION
                ;;
		n) num_add=$OPTION
		;;
                z)
                        echo ""
                        echo "Usage: ./manage-users.bash -tcp -udp -l -n"
                        echo ""
                        exit 1
                ;;

                *)
                        echo "Invalid value"
                        exit 1
                ;;
        esac
done

#List tcp sockets
if [[ ${tcp_list} ]]
then
	netstat -t
fi

#List udp sockets
if [[ ${udp_list} ]]
then
	netstat -u
fi

#List only listening sockets
if [[ ${listening_list} ]]
then
	netstat -l
fi

#Show numerical addresses instead of resolving hostnames and portnumbers
if [[ ${num_add} ]]
then
	netstat -n
fi

}

#Check if any user besides root has UID of 0
check_uid() {
# Use awk to check
local result=$(awk -F':' '$3 == 0 && $1 != "root" {print $1}' /etc/passwd)

if [ -n "$result"]
then
	echo "Users with the UID 0 that aren't root: $result"
else
	echo "No users found with UID 0 that isn't root"
fi

}

#Check last 10 logged in users
check_last_10() {
last -n 10
}

#See currently logged in users
see_logged_in() {
w
}

#Create new user and add the menu as their shell
new_menu_shell_user() {
read -p "What will the name of the user be? " username

if [ -z "$username" ]
then
	echo "Username cannot be empty"
	exit 1
fi

if id "$username" &>/dev/null
then
	echo "The user '$username' already exists"
	exit 1
fi

#Wraps the manage-users.bash script to be a shell
script="/usr/local/bin/$username-shell"
echo "#!/bin/bash" > "$script"
echo "/home/liam/SYS-320-02/wiregaurd/manage-users.bash" >> "$script"
chmod +x "$script"

#Creates the user and sets this script as their shell
useradd -m -s "$script" "$username" 

#Shows the user being created
echo "User '$username' created with manage-users.bash as their shell"
}

#Menu
display_menu() {
	echo "Menu:"
	echo "1: Check if a user is in the wg0.conf file"
	echo "2: You can add or delete users using the flags -d, -a, -u, -h"
	echo "3: List open network sockets using the flags -tcp, -udp, -l, -n"
	echo "4: Check if any user besides root has UID of 0"
	echo "5: Check last 10 logged in users"
	echo "6: See currently logged in users"
	echo "7: Create a new user and add this menu as their shell"
	echo "8: Exit "
	echo -n "Enter an option(1-8): "
}

while true; do
	display_menu
	read option

	case $option in
	  1)
	     check_user_in_file
	     ;;

	  2)
	     add_or_delete_user
	     ;;

	  3)
	     list_open_network_sockets
	     ;;

	  4)
	     check_uid
	     ;;

	  5)
	     check_last_10
	     ;;

	  6)
	     see_logged_in
	     ;;

	  7)
	     new_menu_shell_user
 	     ;;

	  8)
	     exit 1
   	     ;;
	  *)
	     echo "Invalid option"
  	     ;;
   esac
done
