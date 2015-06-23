
ctsfoder=$(dirname $(readlink -f "$0"))
clear
echo ""


#Show devices
cont=1
if test $(adb devices | wc -l) -ge 3
then
	echo "Select device for CTS Test:"
        adb devices | while read fn
        do
                if test $(echo $fn | grep "devices" | wc -l) -eq 1
                then
                        echo -n ""
                else
                        if test $(echo $fn | grep "device" | wc -l) -eq 1
                        then
                                count=$(expr $count + 1)
                                echo "$count.- $(echo $fn | cut -d" " -f1)"
                        fi
                fi
        done
        #echo "0.- Todos los dispositivos."
else
        echo "No device was found."
	exit 0
fi

#Get the device
read device
clear

cont=1
adb devices | while read fn
do
        if test $(echo $fn | grep "devices" | wc -l) -eq 1
        then
                echo -n ""
        else
                if test $(echo $fn | grep "device" | wc -l) -eq 1
                then
                        count=$(expr $count + 1)
			if test $device -eq $count
			then
                        	echo $fn | cut -d" " -f1 > CTS.temp
				
			fi
                fi
        fi
done
devicename=$(cat CTS.temp)
rm CTS.temp


deviceversion=$(adb -s $devicename shell getprop ro.build.version.release)
deviceversion=$(echo $deviceversion | cut -c3)

if test $deviceversion -eq 2
then
	echo "Installing CtsDelegatingAccessibilityService.apk..."
	adb -s $devicename install -r $ctsfoder/4.2/android-cts/repository/testcases/CtsDelegatingAccessibilityService.apk > /dev/null 2>&1 
	echo "Enable: Settings>Accessibility>Delegating Accessibility Service"
	echo ""
	echo "Press Enter to continue."
	read nada
	clear
fi

if test $deviceversion -ge 2
then
	echo "Installing CtsDeviceAdmin.apk..."
	adb -s $devicename install -r $ctsfoder/4.$deviceversion/android-cts/repository/testcases/CtsDeviceAdmin.apk > /dev/null 2>&1 
	echo "Enhable: Settings>Security>Device administrators>android.deviceadmin.cts.CtsDeviceAdminReceiver*"
	echo "Disable: Settings>Security>Device administrators>android.deviceadmin.cts.CtsDeviceAdminDeactivatedReceiver"
	echo ""
	echo "Press Enter to continue."
	read nada
	clear
fi


echo "Press home button on the device."
echo "Press Enter to contien. (Note that the test will take 2-10 hours)"
read asdf
adb -s $devicename shell mkdir /mnt/sdcard/test
adb -s $devicename push $ctsfoder/android-cts-media-1.0/bbb_short /mnt/sdcard/test
adb -s $devicename push $ctsfoder/android-cts-media-1.0/bbb_full /mnt/sdcard/test
clear

#Start Test
$ctsfoder/4.$deviceversion/android-cts/tools/cts-tradefed run cts --plan CTS --serial $devicename









