#! /bin/bash
 
GREP=/bin/grep
 
createUser()
{
	echo "Enter Username: "
	read name
 
	$GREP -i $name /etc/passwd
 
	if [ $? == 0 ]
	then
		echo "$name, is already a user"
	else
		echo "Preparing to create..."
		sleep 1
		clear
		echo "Enter a comment for $name"
		read comment
		sudo useradd -c "$comment" -m -s /bin/bash $name
		echo "User created!"
		less /etc/passwd | grep $name 
		echo "Please supply a password for $name"
		sudo passwd $name
	fi
}
 
modUser()
{
	clear
	echo "Which user would you like to modify?"
	read modName
 
	$GREP -i $modName /etc/passwd
 
	if [ $? == 0 ]
	then
		echo "Would you like to:"
		echo "1) Add a comment for $modName"
		echo "2) Modify home directory"
		echo "3) Add an expiration date (yyyy-mm-dd)"
		echo "4) Exit"
 
		read answer
		case "$answer" in
			1) echo "Enter comment: ";
			read comment
			sudo usermod -c "$comment" $modName;
			less /etc/passwd | grep $modName;;
			2) echo "Enter new home directoy [path]";
			read homeDir
			sudo usermod -d $homeDir $modName;
			less /etc/passwd | grep $modName;;
			3) echo "Enter expiration date";
			read expiration
			sudo usermod -e $expiration $modName;
			sudo chage -l $modName;;
			4) exit;;
		esac
	else
		echo "$modName does not exist!"
	fi
}
 
deleteUser()
{
	clear
	echo "Which user would you like to delete?"
	read delName
 
	$GREP -i $delName /etc/passwd
 
	if [ $? == 0 ]
	then
		echo "Are you sure you want to delete $delName ? [y/n]"
		read answer
		if [ $answer == "y"]
		then
			sudo userdel -r $delName
			echo "deleting..."
			sleep 1
			echo "$delName deleted!"
			exit 0
		fi
	else
		echo "$delName does not exist!"
	fi
 
}

title="Menu"
prompt="Pick an option:"
options=("Create User" "Modify User" "Delete User")

while opt=$(zenity --title="$title" --text="$prompt" --list  --column="Options"  "${options[@]}"); do
    case "$opt" in
    "${options[0]}" ) createUser;;
    "${options[1]}" ) modUser;;
    "${options[2]}" ) deleteUser;;
    esac

done

