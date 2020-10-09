#! /bin/bash
 
GREP=/bin/grep
 
createUser()
{
	name=$(zenity --entry --title "Enter Username:");
 
	$GREP -i $name /etc/passwd
 
	if [ $? == 0 ]
	then
		$(zenity --error --text "name, is already a user");
	else
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
		comment=$(zenity --entry --width=400 --height=200 --title "Enter a comment for $name");
		sudo useradd -c "$comment" -m -s /bin/bash $name

		$(zenity --info --text "User created!");
		less /etc/passwd | grep $name 

		$(zenity --info --text "Please supply a password for $name");
		sudo passwd $name
	fi
}

modUser()
{
	clear
	modName=$(zenity --entry --title "Which user would you like to modify?");
 
	$GREP -i $modName /etc/passwd
 
	if [ $? == 0 ]
	then
		options=("1) Add a comment for $modName" "2) Modify home directory" "3) Add an expiration date (yyyy-mm-dd)" "4) Exit")

		while opt=$(zenity --title="Modify user" --text="Would you like to:"  --list  --column="Options"  "${options[@]}"); do
			case "$opt" in
			"${options[0]}" ) #echo "Enter comment: ";
					comment=$(zenity --entry --title "Enter comment:");
					sudo usermod -c "$comment" $modName;
					less /etc/passwd | grep $modName;;
			"${options[1]}" ) #echo "Enter new home directoy [path]";
					homeDir=$(zenity --entry --title "Enter new home directoy [path]");
					sudo usermod -d $homeDir $modName;
					less /etc/passwd | grep $modName;;
			"${options[2]}" ) #echo "Enter expiration date";
					expiration=$(zenity --entry --title "Enter expiration date");
					sudo usermod -e $expiration $modName;
					sudo chage -l $modName;;
			"${options[3]}" ) exit;;
			esac
		done
    else 
		echo "not found"
	fi
}
 
deleteUser()
{
	clear
	delName=$(zenity --entry --title "Which user would you like to delete?");
 
	$GREP -i $delName /etc/passwd
 
	if [ $? == 0 ]
	then
		zenity --question --text "Are you sure you want to delete $delName ?" --no-wrap --ok-label "No" --cancel-label "Yes"
		answer=$?
		echo $answer
		if [[ $answer == 1 ]]
		then
			(
				echo 50
				sudo userdel -r $delName
				echo "# Deleting..."
				sleep 1

				echo 100
				echo "# $delName deleted!"
			) | zenity --title "Deleteing user" --progress --auto-kill
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

