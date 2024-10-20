TOOLBOX_VER=v1.0.1
GREEN="\033[0;32m"
BLUE="\033[1;34m"
NORM="\033[0m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
sel=0
while [ "$sel" != "x" ]; do
# ${GREEN}

echo "${GREEN}"
echo "  ____    ____ _  ______            __ __            ";
echo " / __ \  |_  /( )/_  __/___  ___   / // /  ___  __ __";
echo "/ /_/ / _/_ < |/  / /  / _ \/ _ \ / // _ \/ _ \ \ \ /";
echo "\___\_\/____/    /_/   \___/\___//_//_.__/\___//_\_\ ";
echo "                                                     ";
echo "${NORM}"
echo "Welcome to ${RED}Q3 F3 MH2p Toolbox $TOOLBOX_VER${NORM}"
echo "Combiskins and Fullscreen AA Carplay by Q3 F3 telegram group ${BLUE}https://t.me/q3chat"
echo "thx to @bfbumamdihm, @tochk and all other contributors"
echo
echo "${YELLOW} 1 ${NORM}${BLUE}Create backup${NORM}"
echo "${YELLOW} 2 ${NORM}${BLUE}Telnet without password in RED menu${NORM}"
echo "${YELLOW} 3 ${NORM}${BLUE}Enable all FECs${NORM}"
echo "${YELLOW} 4 ${NORM}${BLUE}Disable CP${NORM}"
echo "${YELLOW} 5 ${NORM}${BLUE}Allow installation of any update (convert AS/CN/US to EU)${NORM}"
echo "${YELLOW} 6 ${NORM}${BLUE}Activate fullscreen Android Auto & CarPlay${NORM}"
echo "${YELLOW} 7 ${NORM}${BLUE}Install extended Green Engineering Menu${NORM}"
echo "${YELLOW} 8 ${NORM}${BLUE}Update Radiostation logo database (RSDB) to the latest available 1.20.20 (2020608)"
echo "${YELLOW} 9 ${NORM}${BLUE}Backup Gracenote2 DB"
echo "${YELLOW}10 ${NORM}${BLUE}Update Gracenote2 DB from gracenotedb folder on SD${NORM}"
echo "${YELLOW}11 ${NORM}${BLUE}Format navdb${NORM}"
echo "${YELLOW}12 ${NORM}${BLUE}Activate wireless Android Auto & CarPlay${NORM}"
echo "${YELLOW}13 ${NORM}${BLUE}Activate Baidu CarLife${NORM}"
echo "${YELLOW}14 ${NORM}${BLUE}Add S Perfomance skin ${RED}ONLY Q3${NORM}"
echo "${YELLOW}15 ${NORM}${BLUE}Add RS Perfomance skin ${RED}ONLY Q3${NORM}"
echo "${YELLOW}16 ${NORM}${BLUE}Disable skin ${RED}ONLY Q3${NORM}"
echo "${YELLOW}17 ${NORM}${BLUE}Enable fullscreen AA Carplay ${RED}ONLY Q3${NORM}"
echo "${YELLOW}18 ${NORM}${BLUE}Enable fullscreen AA Carplay with statusbar ${RED}ONLY Q3${NORM}"
echo "${YELLOW}19 ${NORM}${BLUE}Disable fullscreen AA Carplay ${RED}ONLY Q3${NORM}"
echo "${YELLOW}20 ${NORM}${BLUE}Compass test patch ${RED}ONLY Q3${NORM}"
echo "${YELLOW}21 ${NORM}${BLUE}Compass test patch OFF ${RED}ONLY Q3${NORM}"
echo "${YELLOW}99 ${NORM}${BLUE}Reboot the unit${NORM}"
echo "${YELLOW} 0 ${NORM}${BLUE}Exit${NORM}"
read sel?"Enter number of the function: "
echo

if [[ -e /fs/sda0 ]]; then
	mount -uw /fs/sda0
	dstPath=/fs/sda0
	echo "Mounted SD1 card in r/w mode"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	dstPath=/fs/sdb0
	echo "Mounted SD2 card in r/w mode"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	dstPath=/fs/usb0_0
	echo "Mounted USB1 drive in r/w mode"
else
	echo "Error: cannot find any SD card/USB drive!"
	exit 1
fi

touch $dstPath/toolbox_.tmp
if [[ ! -e $dstPath/toolbox_.tmp ]]; then
   echo "SD card/USB drive is write protected!"
   break
fi
rm -f $dstPath/toolbox_.tmp
[[ ! -e $dstPath/backup ]] && mkdir $dstPath/backup
[[ ! -e $dstPath/backup ]] && echo "Error: cannot create $dstPath/backup folder!" && break

case $sel in
	1)
		s="Creating backup...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -d /mnt/app ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Toolbox version: $TOOLBOX_VER" >> $dstPath/backup/device_info.txt
		echo "$(date)" >> $dstPath/backup/device_info.txt
		echo "Variant: $(/mnt/app/armle/usr/bin/pc s:678364556:12 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "SW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF187 | awk '{print $13}' 2>/dev/null) HW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF191 | awk '{print $13}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		[[ -f /eso/hmi/lsd/development_activated ]] && echo "Unit in dev mode">> $dstPath/backup/device_info.txt || echo "Unit in rel mode">> $dstPath/backup/device_info.txt
		echo "5F coding: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "5F adaptations: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		[[ ! -d /mnt/gracenotedb ]] && mount -t qnx6 /dev/mnanda0t177.9 /mnt/gracenotedb
		[[ -e "/mnt/gracenotedb/database/rev.txt" ]] && echo "GracenoteDB: $(cat /mnt/gracenotedb/database/rev.txt)" >> $dstPath/backup/device_info.txt
		echo "Mounts:" >> $dstPath/backup/device_info.txt 2>/dev/null
		mount >> $dstPath/backup/device_info.txt 2>/dev/null
		ls -alR / >> $dstPath/backup/device_info.txt 2>/dev/null
		cp -rf /mnt/persist_new $dstPath/backup/
		cp -rf /mnt/app/eso/hmi/lsd/jars $dstPath/backup/
		cat /dev/fs0 > $dstPath/backup/fs0
		[[ -e /mnt/app/eso/bin/apps/fecmanager ]] && cp -f /mnt/app/eso/bin/apps/fecmanager $dstPath/backup/
		[[ -e /mnt/app/eso/bin/apps/componentprotection ]] && cp -f /mnt/app/eso/bin/apps/componentprotection $dstPath/backup/
		[[ ! -e "/mnt/swup" ]] && mount -t qnx6 /dev/mnanda0t177.2 /mnt/swup
		cp -f /mnt/swup/etc/passwd $dstPath/backup/
		cp -f /mnt/swup/etc/shadow $dstPath/backup/
		[[ -e /mnt/app/eso/hmi/lsd/Resources/skin1 ]] && cp -rf /mnt/app/eso/hmi/lsd/Resources/skin1 $dstPath/backup/
		[[ -f "/mnt/app/eso/hmi/lsd/jars/fc.jar" ]] && cp -f /mnt/app/eso/hmi/lsd/jars/fc.jar $dstPath/backup/
		[[ ! -e "/mnt/system" ]] && mount -o noatime,nosuid,noexec -r /dev/fs0p1 /mnt/system
		if [[ -e "/mnt/system/etc/eso/production/gal.json" ]]; then
			[[ -e "$dstPath/backup/skin1" ]] && cp -f /mnt/system/etc/eso/production/gal.json $dstPath/backup/skin1/ || cp -f /mnt/system/etc/eso/production/gal.json $dstPath/backup/
		fi
		[[ -e "/mnt/misc1/connectivity/mcc_countrycode.xml" ]] && cp -f /mnt/misc1/connectivity/mcc_countrycode.xml $dstPath/backup/
		s="Done.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	2)
		s="Enabling telnet without password in RED menu...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		echo "Creating backup..."
		[[ ! -e "/mnt/swup" ]] && mount -t qnx6 /dev/mnanda0t177.2 /mnt/swup
		mount -uw /mnt/swup/
		cp -f /mnt/swup/etc/passwd $dstPath/backup/
		cp -f /mnt/swup/etc/shadow $dstPath/backup/
		echo "Done."
		echo "Enabling telnet..."
		if [[ -e /mnt/swup/etc/nopasswd ]]; then
			cp -f /mnt/swup/etc/nopasswd /mnt/swup/etc/passwd
		else
			echo "root::0:0::/root/:/bin/sh" >/tmp/passwd
			grep -v "root" /mnt/swup/etc/passwd >>/tmp/passwd
			mv -f /tmp/passwd /mnt/swup/etc/passwd
			if [[ -e /mnt/swup/etc/shadow ]]; then
				echo "root:*:0:0" >/tmp/shadow
				grep -v "root" /mnt/swup/etc/shadow >>/tmp/shadow
				mv -f /tmp/shadow /mnt/swup/etc/shadow
			else
				echo "root:*:0:0" >/mnt/swup/etc/shadow
			fi
		fi
		[[ -e /mnt/swup/bin/opa ]] && rm -f /mnt/swup/bin/opa
		s="Telnet enabled. You can login to 172.16.250.248:23 without password.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	3)
		s="Enabling all FECs...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		echo "Creating backup..."
		cp -rf /mnt/persist_new/fec $dstPath/backup/
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		mount -uw /mnt/app/
		[[ ! -e "/mnt/swup" ]] && mount -t qnx6 /dev/mnanda0t177.2 /mnt/swup
		mount -uw /mnt/swup/
		[[ -e /mnt/app/eso/bin/apps/fecmanager ]] && cp -f /mnt/app/eso/bin/apps/fecmanager $dstPath/backup/
		echo "Backup created."
		echo "Replacing /mnt/app/eso/bin/apps/fecmanager"
		cp -Vf $dstPath/patch/fecmanager /mnt/app/eso/bin/apps/
		chmod 777 /mnt/app/eso/bin/apps/fecmanager
		echo "Replacing /mnt/swup/eso/bin/apps/fecmanager"
		cp -Vf $dstPath/patch/fecmanager /mnt/swup/eso/bin/apps/
		chmod 777 /mnt/swup/eso/bin/apps/fecmanager
		echo "Generating /mnt/persist_new/fec/ExceptionList.txt"
		echo '???-?????.??.??????????' > /mnt/persist_new/fec/ExceptionList.txt
		echo '[SupportedFSC]' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc   = "00000700"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc2  = "00030000"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc3  = "00040100"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc4  = "00050000"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc5  = "00050100"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc6  = "00060100"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc7  = "00060200"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc8  = "00060300"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc9  = "00060400"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc10 = "00060500"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc11 = "00060600"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc12 = "00060700"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc13 = "00060800"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc14 = "00060900"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc15 = "00060A00"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc16 = "00060B00"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc17 = "00060F00"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc18 = "00070200"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc19 = "00070400"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc20 = "026000F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc21 = "026100F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc22 = "026D00F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc23 = "056000F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc24 = "056100F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc25 = "056D00F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc26 = "066000F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc27 = "066100F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc28 = "066D00F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc29 = "096000F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc30 = "096100F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc31 = "096D00F0"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'fsc32 = "00000007"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo '[ECU-Signature]' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'signature1 = "00000000000000000000000000000000"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'signature2 = "00000000000000000000000000000000"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'signature3 = "00000000000000000000000000000000"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'signature4 = "00000000000000000000000000000000"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'signature5 = "00000000000000000000000000000000"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'signature6 = "00000000000000000000000000000000"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'signature7 = "00000000000000000000000000000000"' >> /mnt/persist_new/fec/ExceptionList.txt
		echo 'signature8 = "00000000000000000000000000000000"' >> /mnt/persist_new/fec/ExceptionList.txt
		#cp -Vf $dstPath/patch/ExceptionList.txt /mnt/persist_new/fec/
		if [[ -e $dstPath/patch/mcc_countrycode.xml ]]; then
			cp -f /mnt/misc1/connectivity/mcc_countrycode.xml $dstPath/backup/
			cp -f $dstPath/patch/mcc_countrycode.xml /mnt/misc1/connectivity/
		fi
		echo "5F coding before FEC activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "5F adaptations before FEC activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		#Enable online media, Android Auto(GAL), CarPlay(Apple DIO), WiFi Client HMI, WiFi 5GHz, Wireless CP, USB iPod, Enable WiFi, EU navi, EU FM etc
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:7.4 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:7.7 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:8.0 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:8.2 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:17.5 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:23.3 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:19.6 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:19.7 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.1 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.2 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.3 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.4 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.5 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.6 1
		#/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.7 1
		echo "5F coding after FEC activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "5F adaptations after FEC activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "Done."
		echo
		s="IMPORTANT! In block 5F set adaptation Vehicle configuration>FoD=SWaP!!!";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	4)
		s="Disabling CP...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		echo "Creating $dstPath/backup..."
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		[[ -e /mnt/app/eso/bin/apps/componentprotection ]] && cp -f /mnt/app/eso/bin/apps/componentprotection $dstPath/backup/
		echo "Backup created."
		echo "Replacing /mnt/app/eso/bin/apps/componentprotection"
		mount -uw /mnt/app/
		cp -Vf $dstPath/patch/componentprotection /mnt/app/eso/bin/apps/
		chmod 777 /mnt/app/eso/bin/apps/componentprotection
		s="Done.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	5)
		s="Enabling installation of any update...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		echo "This script enables installation of any update"
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Variant of unit is: $(/mnt/app/armle/usr/bin/pc s:678364556:12)"
		touch /mnt/persist_new/swup/allowUserDefinedUpdate
		touch /mnt/persist_new/swup/checkAllUpdatesPROD
		touch /mnt/persist_new/swup/skipCheckInstallerChecksumPROD
		touch /mnt/persist_new/swup/skipCheckMetaChecksumPROD
		touch /mnt/persist_new/swup/skipCheckVariantPROD
		echo "Installation of any update is enabled."
		echo
		echo "IMPORTANT! Change unit's variant to EU with following command:"
		echo "/mnt/app/armle/usr/bin/pc s:678364556:12 M2P-H-NL-EU-AU-MLE-AL"
		echo
		#Changing byte3=01 (EU navi) etc in 5F coding
		#Changing byte 9, sets byte 0 to 00
		echo "5F coding before EU conversion: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "5F adaptations before EU conversion: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:03.0 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:03.1 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:03.2 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:03.3 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:13.1 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:13.3 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:13.4 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:14.1 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:14.4 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:14.5 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.1 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.2 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.3 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.4 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.5 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.6 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.7 1
		echo "5F coding after EU conversion: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "5F adaptations after EU conversion: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "After the update onto ER firmware, do not forget to format navdb"
		echo
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	6)
		s="Activating fullscreen Android Auto and CarPlay...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		[[ ! -e "/mnt/system" ]] && mount -o noatime,nosuid,noexec -r /dev/fs0p1 /mnt/system
		[[ ! -e $dstPath/backup/gal.json ]] && cp -f /mnt/system/etc/eso/production/gal.json $dstPath/backup/
		echo "Mounting /mnt/app and /mnt/system/ in r/w mode..."
		mount -uw /mnt/app
		mount -uw /mnt/system
		echo "Done."
		echo "Activating fullscreen Android Auto..."
		sed -i -e s/\"dpi\":0,/\"dpi\":220,/ /mnt/system/etc/eso/production/gal.json
		echo "Done."
		if [[ -e "/mnt/app/eso/hmi/lsd/Resources/skin1" ]]; then
			if [[ ! -e $dstPath/backup/skin1 ]]; then
				echo "Backing up /mnt/app/eso/hmi/lsd/Resources/skin1 to $dstPath/backup/..."
				cp -rf /mnt/app/eso/hmi/lsd/Resources/skin1 $dstPath/backup/
				echo "Done."
			fi
			vh_size=$(ls -l /mnt/app/eso/hmi/lsd/Resources/skin1/viewhandler.zip | awk '{print $5}' 2>/dev/null)
			if_size=$(ls -l /mnt/app/eso/hmi/lsd/Resources/skin1/info.txt | awk '{print $5}' 2>/dev/null)
			if [[ "$vh_size" == "14338067" && "$if_size" == "1355" ]]; then
				echo "Activating fullscreen CarPlay for MH2p_ER_VWG36_P2869"
				cp -Vf $dstPath/patch/fullscreen/viewhandler.zip /mnt/app/eso/hmi/lsd/Resources/skin1/
				cp -Vf $dstPath/patch/fullscreen/info.txt /mnt/app/eso/hmi/lsd/Resources/skin1/
				echo "Done."
			else
				echo "${RED}ERROR!${NORM} Currently CarPlay fullscreen patch is ONLY compatible with MH2p_ER_VWG36_P2869 train"
			fi
		else
			if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
				if [[ -f "/mnt/app/eso/hmi/lsd/jars/fc.jar" ]]; then
					echo "Backing up /mnt/app/eso/hmi/lsd/jars/fc.jar to $dstPath/backup/..."
					cp -f /mnt/app/eso/hmi/lsd/jars/fc.jar $dstPath/backup/
					echo "Done."
				fi
				if [[ -f "$dstPath/patch/fullscreen/fc.jar" ]]; then
					echo "Activating fullscreen CarPlay for PCM5..."
					cp -Vf $dstPath/patch/fullscreen/fc.jar /mnt/app/eso/hmi/lsd/jars/
					echo "Done."
				else
					echo "Error: cannot find $dstPath/patch/fullscreen/fc.jar"
				fi
			else
				echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
			fi
		fi
		sync
		[[ -e "/mnt/system" ]] && umount -f /mnt/system
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	7)
		s="Installing extended Green Engineering Menu...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		echo "Creating backup of Green Engineering Menu to $dstPath/backup"
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		cp -rf /mnt/app/eso/hmi/engdefs $dstPath/backup/
		echo "Copying Green Engineering Menu files from $dstPath/engdefs to /mnt/app/eso/hmi/engdefs/"
		mount -uw /mnt/app/
		cp -rf $dstPath/patch/engdefs /mnt/app/eso/hmi/
		chmod 777 /mnt/app/eso/hmi/engdefs/scripts/*
		sync
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	8)
		s="Update Radiostation logo database (RSDB)...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/misc1" ]] && mount -t qnx6 /dev/mnanda0t177.4 /mnt/misc1
		echo "Backing up /mnt/misc1/rsdb/VW_STL_DB.sqlite to $dstPath/backup"
		cp -Vf /mnt/misc1/rsdb/VW_STL_DB.sqlite $dstPath/backup/
		echo "Done."
		mount -uw /mnt/misc1
		echo "Copying VW_STL_DB.sqlite to /mnt/misc1/rsdb/"
		cp -Vf $dstPath/patch/VW_STL_DB.sqlite /mnt/misc1/rsdb/
		s="Done.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	9)
		s="Backup Gracenote2 DB...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/gracenotedb" ]] && mount -t qnx6 /dev/mnanda0t177.9 /mnt/gracenotedb
		if [[ -e "/mnt/gracenotedb/database" ]]; then
			[[ -e "/mnt/gracenotedb/database/rev.txt" ]] && echo "GracenoteDB: $(cat /mnt/gracenotedb/database/rev.txt)" >> $dstPath/backup/device_info.txt
			cp -Vrf /mnt/gracenotedb/* $dstPath/backup/
			s="Done.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		else
			s="ERROR: /mnt/gracenotedb does not exist!";echo $s;echo $s >> $dstPath/backup/device_info.txt
		fi
		;;
	10)
		s="Updating Gracenote2 DB...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/gracenotedb" ]] && mount -t qnx6 /dev/mnanda0t177.9 /mnt/gracenotedb
		if [[ -e $dstPath/gracenotedb ]]; then
			[[ -e "/mnt/gracenotedb/database/rev.txt" ]] && echo "GracenoteDB: $(cat /mnt/gracenotedb/database/rev.txt)" >> $dstPath/backup/device_info.txt
			echo "Copying $dstPath/mnt/gracenotedb/* to /mnt/gracenotedb/"
			mount -uw /mnt/gracenotedb
			cp -Vrf $dstPath/gracenotedb/* /mnt/gracenotedb/
			s="Done.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		else
			echo "ERROR: Cannot open $dstPath/gracenotedb folder";echo $s;echo $s >> $dstPath/backup/device_info.txt
		fi
		;;
	11)
		s="Formatting navdb...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		if [[ -e "/mnt/navdb" ]]; then
			ls -alR /mnt/navdb >> $dstPath/backup/device_info.txt
			umount -f /mnt/navdb
		fi
		echo "y" | mkqnx6fs -q /dev/mnandb0t177 2>/dev/null
		s="Done. Reboot unit and install maps from RED menu.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	12)
		s="Activating wireless Android Auto & CarPlay...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -d /mnt/app ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "5F coding before AA&CP activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "5F adaptations before AA&CP activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		#Enable online media, Android Auto(GAL), CarPlay(Apple DIO), WiFi Client HMI, WiFi 5GHz, Wireless CP, USB iPod, Enable WiFi, EU navi etc
		#Changing byte 9 zeroes byte 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:7.4 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:7.7 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:8.0 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:8.2 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:17.5 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:23.3 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:19.6 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:19.7 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:03.0 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:03.1 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:03.2 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:03.3 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:13.1 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:13.3 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:13.4 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:14.1 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:14.4 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:14.5 0
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.1 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.2 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.3 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.4 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.5 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.6 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x600:24.7 1
		echo "5F coding after AA&CP activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "5F adaptations after AA&CP activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	13)
		s="Activating Baidu CarLife...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -d /mnt/app ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "5F coding before Baidu CL activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "5F adaptations before Baidu CL activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		#Enable Baidu CarLife
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:7.6 1
		/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD:20.2 1
		echo "5F coding after Baidu CL activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		echo "5F adaptations after Baidu CL activation: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	14)
		s="Adding S Perfomance skin...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Mounting /mnt/app in r/w mode..."
		mount -uw /mnt/app
		echo "Done."
		echo "Adding S Perfomance skin..."
		if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
			if [[ -f "$dstPath/patch/jars/CombiSkinsSPerfomance.jar" ]]; then
				echo "Copy jar..."
				cp -Vf $dstPath/patch/jars/CombiSkinsSPerfomance.jar /mnt/app/eso/hmi/lsd/jars/CombiSkins.jar
				echo "Done."
			else
				echo "Error: cannot find $dstPath/patch/jars/CombiSkinsSPerfomance.jar"
			fi
		else
			echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
		fi
		sync
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	15)
		s="Adding RS Perfomance skin...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Mounting /mnt/app in r/w mode..."
		mount -uw /mnt/app
		echo "Done."
		echo "Adding S Perfomance skin..."
		if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
			if [[ -f "$dstPath/patch/jars/CombiSkinsRSPerfomance.jar" ]]; then
				echo "Copy jar..."
				cp -Vf $dstPath/patch/jars/CombiSkinsRSPerfomance.jar /mnt/app/eso/hmi/lsd/jars/CombiSkins.jar
				echo "Done."
			else
				echo "Error: cannot find $dstPath/patch/jars/CombiSkinsRSPerfomance.jar"
			fi
		else
			echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
		fi
		sync
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	16)
		s="Disabling skin...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Mounting /mnt/app in r/w mode..."
		mount -uw /mnt/app
		echo "Done."
		echo "Disabling skin..."
		if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
			if [[ -f "/mnt/app/eso/hmi/lsd/jars/CombiSkins.jar" ]]; then
				echo "Copy jar..."
				rm -f /mnt/app/eso/hmi/lsd/jars/CombiSkins.jar
				echo "Done."
			else
				echo "Error: cannot find /mnt/app/eso/hmi/lsd/jars/CombiSkins.jar"
			fi
		else
			echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
		fi
		sync
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	17)
		s="Enabling fullscreen AA Carplay Q3...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Mounting /mnt/app in r/w mode..."
		mount -uw /mnt/app
		echo "Done."
		echo "Enabling fullscreen AA Carplay Q3..."
		if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
			if [[ -f "$dstPath/patch/jars/FullScreenAACPCL.jar" ]]; then
				echo "Copy jar..."
				cp -Vf $dstPath/patch/jars/FullScreenAACPCL.jar /mnt/app/eso/hmi/lsd/jars/FullScreenAACPCL.jar
				echo "Done."
			else
				echo "Error: cannot find $dstPath/patch/jars/FullScreenAACPCL.jar"
			fi
		else
			echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
		fi
		sync
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	18)
		s="Enabling fullscreen AA Carplay with statusbar Q3...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Mounting /mnt/app in r/w mode..."
		mount -uw /mnt/app
		echo "Done."
		echo "Enabling fullscreen AA Carplay Q3 with statusbar..."
		if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
			if [[ -f "$dstPath/patch/jars/FullScreenAACPCL_withsb.jar" ]]; then
				echo "Copy jar..."
				cp -Vf $dstPath/patch/jars/FullScreenAACPCL_withsb.jar /mnt/app/eso/hmi/lsd/jars/FullScreenAACPCL.jar
				echo "Done."
			else
				echo "Error: cannot find $dstPath/patch/jars/FullScreenAACPCL_withsb.jar"
			fi
		else
			echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
		fi
		sync
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	19)
		s="Disabling fullscreen AA Carplay...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Mounting /mnt/app in r/w mode..."
		mount -uw /mnt/app
		echo "Done."
		echo "Disabling fullscreen AA Carplay..."
		if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
			if [[ -f "/mnt/app/eso/hmi/lsd/jars/FullScreenAACPCL.jar" ]]; then
				echo "Copy jar..."
				rm -f /mnt/app/eso/hmi/lsd/jars/FullScreenAACPCL.jar
				echo "Done."
			else
				echo "Error: cannot find /mnt/app/eso/hmi/lsd/jars/FullScreenAACPCL.jar"
			fi
		else
			echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
		fi
		sync
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	20)
		s="Compass test patch ...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Mounting /mnt/app in r/w mode..."
		mount -uw /mnt/app
		echo "Done."
		if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
			if [[ -f "$dstPath/patch/jars/NaviCompass.jar" ]]; then
				echo "Copy jar..."
				cp -Vf $dstPath/patch/jars/NaviCompass.jar /mnt/app/eso/hmi/lsd/jars/NaviCompass.jar
				echo "Done."
			else
				echo "Error: cannot find $dstPath/patch/jars/NaviCompass.jar"
			fi
		else
			echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
		fi
		sync
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	21)
		s="Compass test patch off...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
		echo "Mounting /mnt/app in r/w mode..."
		mount -uw /mnt/app
		echo "Done."
		if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
			if [[ -f "/mnt/app/eso/hmi/lsd/jars/NaviCompass.jar" ]]; then
				echo "Copy jar..."
				rm -f /mnt/app/eso/hmi/lsd/jars/NaviCompass.jar
				echo "Done."
			else
				echo "Error: cannot find /mnt/app/eso/hmi/lsd/jars/NaviCompass.jar"
			fi
		else
			echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
		fi
		sync
		[[ -e "/mnt/app" ]] && umount -f /mnt/app
		s="Done. Reboot the unit.";echo $s;echo $s >> $dstPath/backup/device_info.txt
		;;
	99)
		s="Rebooting the unit...";echo $s;echo $s >> $dstPath/backup/device_info.txt
		echo gem-reset > /dev/ooc/system
		;;
esac
sync
if [ "$sel" != "0" ]; then
   read sel?"Press ENTER to continue..."
else
   break
fi
done
sync