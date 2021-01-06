#!/bin/sh
# Generate /jffs/addons/YazDHCP.d/DHCP_Clients compatible file if a /jffs/configs/dnsmasq.conf.add file exists.
# Once checked, can be optionaly be copied to  /jffs/addons/YazDHCP.d/DHCP_clients
if [ -f /jffs/configs/dnsmasq.conf.add ]; then
	if ! [ -d /jffs/addons/YazDHCP.d ]; then
		echo "It doesn't appear that you have installed YazDHCP"
		echo "Install that Addon and try again..."
		exit
	fi
	echo "dnsmasq.conf.add found, generating YazDHCP compatible file"
	cat /jffs/configs/dnsmasq.conf.add | grep '^dhcp-host=' | awk -F"," '{ printf substr($1,11)","$2 "," $3 ",";if ($4) printf $4 ; printf "\n" }' > cvtYazDHCP
	more cvtYaxDHCP
	echo -n "If this file looks good, enter Y copy to /jffs/addons/YazDHCP.d/DHCP_clients "
	read -r "confirm"
	case "$confirm" in
		y|Y)
			cp ./cvtYazDHCP /jffs/addons/YazDHCP.d/DHCP_clients
			rm ./cvtYazDHCP
			echo "Copied"
			echo "Your dnsmasq.conf.add file in /jffs/configs should be disabled/backed up"
			echo -n "Should it be renamed to dnsmasq.conf.bak? " 
			read -r "confirm2"
        		case "$confirm2" in
                		y|Y)
                        		mv /jffs/configs/dnsmasq.conf.add /jffs/configs/dnsmasq.conf.bak
					echo "renamed..."
					echo
                        		break
                		;;
                		*)
					echo "Remember to backup and remove this file"
					echo "if you are going to use YazDHCP"
					break
                		;;
			esac
		;;
		*)
			echo "Not copied, the converted file is called cvtYazDHCP"
			echo -n "and is located in this directory: "
			pwd
			break
		;;	
	esac
else
	echo "No dnsmasq.conf.add file found in /jffs/configs..."
fi

