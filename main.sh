#! /bin/bash
 
GREP=/bin/grep
 
createUser()
{
	#echo "Enter Username: "
	#$ zenity --entry --title "Enter Username:"
	name=$(zenity --entry --title "Enter Username:");
	#read name
 
	$GREP -i $name /etc/passwd
 
	if [ $? == 0 ]
	then
		#echo "$name, is already a user"
		$(zenity --error --text "name, is already a user");
	else
		#echo "Preparing to create..."
		#$(zenity --info --text "Preparing to create...");
		#$(zenity --info --text "Preparing to create...");
		(
  			echo 25
  			echo "# Setting up..."
  			sleep 1

			echo 30
			echo "# Reading files..."
			sleep 1

			echo 70
			echo "# Creating content..."
			sleep 1

			echo 100
			echo "# Done!"
		) | zenity --title "Progress bar example" --progress --auto-kill

		clear
		#echo "Enter a comment for $name"
		#read comment
		comment=$(zenity --entry --width=400 --height=200 --title "Enter a comment for $name");
		sudo useradd -c "$comment" -m -s /bin/bash $name
		#echo "User created!"
		$(zenity --info --text "User created!");
		less /etc/passwd | grep $name 
		#echo "Please supply a password for $name"
		$(zenity --info --text "Please supply a password for $name");
		sudo passwd $name
	fi
}
 
modUser()
{
	clear
	#echo "Which user would you like to modify?"
	modName=$(zenity --entry --title "Which user would you like to modify?");
	#read modName
 
	$GREP -i $modName /etc/passwd
 
	if [ $? == 0 ]
	then
		options=("1) Add a comment for $modName" "2) Modify home directory" "3) Add an expiration date (yyyy-mm-dd)" "4) Exit")
		#echo "Would you like to:"
		#echo "1) Add a comment for $modName"
		#echo "2) Modify home directory"
		#echo "3) Add an expiration date (yyyy-mm-dd)"
		#echo "4) Exit"
 
		#read answer
		while opt=$(zenity --title="Modify user" --text="Would you like to:"  --list  --column="Options"  "${options[@]}"); do
    case "$opt" in
    "${options[0]}" ) #echo "Enter comment: ";
			#read comment
			comment=$(zenity --entry --title "Enter comment:");
			sudo usermod -c "$comment" $modName;
			less /etc/passwd | grep $modName;;
    "${options[1]}" ) #echo "Enter new home directoy [path]";
			#read homeDir
			homeDir=$(zenity --entry --title "Enter new home directoy [path]");
			sudo usermod -d $homeDir $modName;
			less /etc/passwd | grep $modName;;
    "${options[2]}" ) #echo "Enter expiration date";
			#read expiration
			expiration=$(zenity --entry --title "Enter expiration date");
			sudo usermod -e $expiration $modName;
			sudo chage -l $modName;;
    	esac
    	
    	else echo "not found"
		#case "$answer" in
			#1) echo "Enter comment: ";
			#read comment
			#sudo usermod -c "$comment" $modName;
			#less /etc/passwd | grep $modName;;
			#2) echo "Enter new home directoy [path]";
			#read homeDir
			#sudo usermod -d $homeDir $modName;
			#less /etc/passwd | grep $modName;;
			#3) echo "Enter expiration date";
			#read expiration
			#sudo usermod -e $expiration $modName;
			#sudo chage -l $modName;;
			#4) exit;;
		#esac
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

title="CRUD Linux User"
prompt="Pick an option:"
options=("Create User" "Modify User" "Delete User")

while opt=$(zenity --title="$title" --text="$prompt" --list  --column="Options"  "${options[@]}"); do
    case "$opt" in
    "${options[0]}" ) createUser;;
    "${options[1]}" ) modUser;;
    "${options[2]}" ) deleteUser;;
    esac

done

