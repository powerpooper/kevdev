#!/bin/bash


##############################################
#
# This will help manange the OSMC tweaks
# on a friends Raspberry Pi.
# 
#
##############################################
clear

if [ $UID -ne 0 ]; then
    echo "You nned to run ./kevdev.sh as root or it might fail."
    echo "To do this run this command sudo ./kevdev.sh"
    sleep 3
fi

###### Install script if not installed
if [ ! -e "/usr/bin/kevdev" ];then
	echo "Script is not installed. Do you want to install it ? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
		cp -v $0 /usr/bin/kevdev
		chmod +x /usr/bin/kevdev
		#rm $0
		kevdev
		exit 1
	else
		echo -e "\e[32m[-] Ok,maybe later !\e[0m"
	fi
else
	echo "Script is installed"
	sleep 1
fi
### End of install process

#### Screwup function
function screwup {
	echo "You Screwed up somewhere, try again." 
	clear
}

######## Update
function Update {
	echo "This will update OSMC. Do you want to install these programs? (Y/N)"
	read install
	if [[ $install = Y || $install = y ]] ; then
		apt-get update &&  apt-get upgrade -y &&  apt-get dist-upgrade -y
		echo -e "\e[32m[-] OSMC has been update.\e[0m"
	else
			echo -e "\e[32m[-] Ok,maybe later !\e[0m"
	fi
}

######## HDMI
function hdmi {
sed -i 's/display_default_lcd=1/display_default_lcd=0/' /home/mint/config.txt
echo "For this setting to take affect you need to reboot. Would you like to reboot now? (Y/N)"
read reboot
if [[ $reboot = Y || $reboot = y ]] ; then
	echo "Rebooting."
	sleep 3
	init 6
fi

}

######## LCD
function lcd {
sed -i 's/display_default_lcd=0/display_default_lcd=1/' /home/mint/config.txt
echo "For this setting to take affect you need to reboot. Would you like to reboot now? (Y/N)"
read reboot
if [[ $reboot = Y || $reboot = y ]] ; then
	echo "Rebooting."
	sleep 3
	init 6
fi	
	
}

######## On
function on {
screenon
}

######## Off
function off {
screenoff
}

######### Screen Picker
function screenpicker {
clear
echo -e "
\033[31m#######################################################\033[m
                Choose the Display Output
\033[31m#######################################################\033[m"

select menusel in "HDMI" "LCD" "Back to Main"; do
case $menusel in
	"HDMI")
		hdmi
		clear
		mainmenu;;

	"LCD")
		lcd 
		clear
		mainmenu;;

	"Back to Main")
		clear
		mainmenu ;;
		
	*)
		screwup
		screenpicker ;;
	
		
esac

break

done
}

######### LCD Power 
function lcdpower {
clear
echo -e "
\033[31m#######################################################\033[m
                LCD On or Off
\033[31m#######################################################\033[m"

select menusel in "On" "Off" "Back to Main"; do
case $menusel in
	"On")
		on
		clear
		mainmenu;;

	"Off")
		off 
		clear
		mainmenu;;

	"Back to Main")
		clear
		mainmenu ;;
		
	*)
		screwup
		lcdpower ;;
	
		
esac

break

done
}
########################################################
##             Main Menu Section
########################################################
function mainmenu {
echo -e "
\033[31m################################################################\033[m
\033[1;36m

 This script will help you manage OSMC a little more easily.

\033[m                                        
\033[31m################################################################\033[m"

select menusel in "Update" "Screen Picker" "Choose Display Output" "LCD Power On or OFF" "EXIT PROGRAM"; do
case $menusel in
	"Update")
		Update
		clear ;;
			
	"Choose Display Output")
		screenpicker
		clear ;;

	"LCD Power On or OFF")
		lcdpower
		clear ;;

	"EXIT PROGRAM")
		clear && exit 0 ;;
		
	* )
		screwup
		clear ;;
esac

break

done
}

while true; do mainmenu; done
# kevdev
