count=1;
ifconfig | grep flags | cut -d":" -f1 | grep -v lo | while read fn
do
    echo "$count) $fn";
    let count++;
done
echo "0) End";
echo "Select interface:";
read interface;
if test $interface -eq 0
then
    exit;
fi
clear;
echo "1) 00:11:22:33:44:55";
echo "2) 00:08:ca:c2:21:1e";
echo "3) 00:90:f5:63:f1:d8";
echo "4) Other";
echo "Select a MAC";
read mac;
if test $mac -le 4 && test $mac -ge 0
then
    case $mac in
	1)
	    ether="00:11:22:33:44:55";
	    ;;
	2)
	    ether="00:08:ca:c2:21:1e";
	    ;;
	3)
	    ether="00:90:f5:63:f1:d8";
	    ;;
	4)
	    clear;
	    echo "Write a new MAC:";
	    read ether;
	    ;;
	esac
    if test $interface -le $(ifconfig | grep flags | cut -d":" -f1 | grep -v lo | wc -l)
    then
	inter=$(ifconfig | grep flags | cut -d":" -f1 | grep -v lo | head -n $interface | tail -n 1);
	ifconfig $inter down;
	ifconfig $inter hw ether $ether;
	ifconfig $inter up;	
	clear;
	echo "Finish. The interface $inter has his MAC $ether.";
    fi
    
fi
