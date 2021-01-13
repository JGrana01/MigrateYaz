#!/bin/sh
# Generate /jffs/addons/YazDHCP.d/.staticlist compatible file if a /jffs/configs/dnsmasq.conf.add file exists.
# Once checked, can be optionaly be copied to  /jffs/addons/YazDHCP.d/.staticlist
if [ -f /jffs/configs/dnsmasq.conf.add ]; then
        if ! [ -d /jffs/addons/YazDHCP.d ]; then
                echo "It doesn't appear that you have installed YazDHCP"
                echo "Install that Addon and try again..."
                exit
        fi
        echo "dnsmasq.conf.add found, generating YazDHCP compatible files"
        cat /jffs/configs/dnsmasq.conf.add | grep '^dhcp-host=' | awk -F"," '{ printf substr($1,11)","$2 "," $3 ",";if ($4) printf $4 ; printf "\n" }' > cvtYazDHCP
        cat /jffs/configs/dnsmasq.conf.add | grep '^dhcp-host=' | awk -F"," '{ print $2" "$3; }' > cvtYazDHCPhosts
        more cvtYazDHCP
        echo -n "If this file looks good, enter Y copy to /jffs/addons/YazDHCP.d"
        read -r "confirm"
        case "$confirm" in
                y|Y)
                        cp cvtYazDHCP /jffs/addons/YazDHCP.d/.staticlist
                        cp cvtYazDHCPhosts /jffs/addons/YazDHCP.d/.hostnames
                        rm ./cvtYazDHCP ./cvtYazDHCPhosts
                        echo "Copied"
                        echo "Your dnsmasq.conf.add file in /jffs/configs should be disabled/backed up"
                        echo -n "Should it be renamed to dnsmasq.conf.bak? "
                        read -r "confirm2"
                        case "$confirm2" in
                                y|Y)
                                        mv /jffs/configs/dnsmasq.conf.add /jffs/configs/dnsmasq.conf.bak
                                        echo "renamed..."
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
                        echo "Not copied, the converted files are called cvtYazDHCP and cvtYazDHCPhosts"
                        echo -n "and is located in this directory: "
                        pwd
                        break
                ;;
        esac
else
        echo "No dnsmasq.conf.add file found in /jffs/configs..."
fi
