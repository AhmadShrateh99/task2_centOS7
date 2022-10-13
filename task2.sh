#!/bin/bash

mkdir /root/task2
cd /root/task2

#make files
touch usedAndAvailable.sh
touch memUsedAndAvailable.sh
touch cpuUtilization.sh

#give the execute permmission for the file
chmod +x usedAndAvailable.sh memUsedAndAvailable.sh cpuUtilization.sh


echo '#!/bin/bash
echo -e "`df -m --output=source,used,avail |sed' "'1d'"' `\t\t`date +%H:%M:%S`                                                                                  `date +"%d-%m-%y"`"' > usedAndAvailable.sh


echo '#!/bin/bash
echo "`sar 1 1|grep -vE "Average" |awk'" '"'NR==4  {OFS="\t\t";  print $3,$4,$5,                                                                             $6,$7,$8,$9}'"'"'`    `date +%H:%M:%S`   `date +"%d-%m-%y"` "' >cpuUtilization.s                                                                             h


echo '#!/bin/bash
echo -e "`free -m | awk '"'"'{print $1"\t\t",$3"\t\t",$4}'"'"' | sed '"'"'1d'"'"                                                                             ' `\t`date +%H:%M:%S`\t`date +"%d-%m-%y" `"' > memUsedAndAvailable.sh
#enable http and add it to firewalld
systemctl start httpd
systemctl enable httpd
firewall-cmd --zone=public --add-service=http

#make the html page
touch /var/www/html/index.html
echo '<h1 style="color:Tomato;">Hello plz choose what do u want to show &#10069;                                                                             </h1>

<ul>
  <li><h3><button onclick="document.location='"'"cpu.html"'"' ">CPU Utilization<                                                                             /button></h3></li>
  <li><h4><button onclick="document.location='"'"mem.html"'"'">Memory Info</butt                                                                             on></h4></li>
  <li><h5><button onclick="document.location='"'"disk.html"'"'">Disk Usage</butt                                                                             on></h5></li>
  <li><h6><button onclick="document.location='"'"avgs.html"'"'">avarages</button                                                                             ></h6></li>
</ul>
 ' >/var/www/html/index.html


touch /var/www/html/mem.html
echo "<pre>" > /var/www/html/mem.html
echo "                 free(M)        Used(M)  Time            Date\n" >> /var/w                                                                             ww/html/mem.html
touch /var/www/html/cpu.html
echo "<pre>" > /var/www/html/cpu.html
echo -e "cpu            %user           %nice          %system         %iowait                                                                                       %steal           %idle      Time       Date\n" >> /var/www/html/cpu.html
touch /var/www/html/disk.html
echo -e "<pre>" > /var/www/html/disk.html
echo -e "Filesystem               Used  Available        Time          Date\n" >                                                                             > /var/www/html/disk.html
touch /root/task2/avgs.sh


#add the avgs contant


echo '#!/bin/bash

echo "<pre>"
#for disks
diskU="`cat /var/www/html/disk.html |awk '"'"'{sum += $2} END {print sum}'"'"'`"
diskA="`cat /var/www/html/disk.html |awk '"'"'{sum += $3} END {print sum}'"'"'`"

numlin="`cat /var/www/html/disk.html |awk '"'"'END {print NR}'"'"'`"
numOflinWithOutFirstTwo=$(($numlin - 3))
if [ $numOflinWithOutFirstTwo -gt 2]
then
avgdU=$(($diskU /  $numOflinWithOutFirstTwo))
avgdA=$(($diskA /  $numOflinWithOutFirstTwo))

echo "Avarage Used Of disks:  $avgdU"M" "
echo -e "Avarage Available Of disks:  $avgdA"M"\n "


#for memory
memU="`cat /var/www/html/mem.html |awk '"'"'{sum += $2} END {print sum}'"'"'`"
memA="`cat /var/www/html/mem.html |awk '"'"'{sum += $3} END {print sum}'"'"'`"

numlin="`cat /var/www/html/mem.html |awk '"'"'END {print NR}'"'"'`"
numOflinWithOutFirstTwo=$(($numlin - 3))

avgmU=$(($memU /  $numOflinWithOutFirstTwo))
avgmA=$(($memA /  $numOflinWithOutFirstTwo))

echo "Avarage Used Of Memory:  $avgmU"M" "
echo -e "Avarage Available Of Memory:  $avgmA"M"\n "


#for cpu
cpuU="`cat /var/www/html/cpu.html |awk '"'"'{sum += $2} END {print sum}'"'"'`"
cpuN="`cat /var/www/html/cpu.html |awk '"'"'{sum += $3} END {print sum}'"'"'`"
cpuS="`cat /var/www/html/cpu.html |awk '"'"'{sum += $4} END {print sum}'"'"'`"
cpuIO="`cat /var/www/html/cpu.html |awk '"'"'{sum += $5} END {print sum}'"'"'`"
cpuST="`cat /var/www/html/cpu.html |awk '"'"'{sum += $6} END {print sum}'"'"'`"
cpuID="`cat /var/www/html/cpu.html |awk '"'"'{sum += $7} END {print sum}'"'"'`"

numlin="`cat /var/www/html/cpu.html |awk '"'"'END {print NR}'"'"'`"
numOflinWithOutFirstTwo=$(($numlin - 3))

#avgcU=$(($cpuU/$numOflinWithOutFirstTwo)|bc)
#avgcN=$(($cpuN /  $numOflinWithOutFirstTwo))
#avgcS=$(($cpuS /  $numOflinWithOutFirstTwo)) |bc
#avgcIO=$(($cpuIO /  $numOflinWithOutFirstTwo))
#avgcST=$(($cpuST /  $numOflinWithOutFirstTwo))
avgcID="$cpuID /  $numOflinWithOutFirstTwo"


echo -n "Avarage cpu Of user: "
echo "scale=2;  $cpuU / $numOflinWithOutFirstTwo " |bc -l
echo -n "Avarage cpu of nice: "
echo "scale=2; $cpuN /  $numOflinWithOutFirstTwo" |bc -l
echo -n "Avarage cpu of system: "
echo "scale=2; $cpuS /  $numOflinWithOutFirstTwo" |bc -l
echo -n "Avarage cpu of iowait: "
echo "scale=2; $cpuIO /  $numOflinWithOutFirstTwo" |bc -l
echo -n "Avarage cpu of steal: "
echo "scale=2; $cpuST /  $numOflinWithOutFirstTwo" |bc -l
echo -n "Avarage cpu of idle: "
echo "scale=2; $cpuID /  $numOflinWithOutFirstTwo" |bc -l
echo -e "\n\n"
#Time and Date
echo "TIME:  `date +%H:%M:%S`"
echo "DATE:  `date +%d-%m-%y`"
else
echo "you need to wait for a the second execution"
fi
' > /root/task2/avgs.sh














touch /var/www/html/avgs.html
chmod +x /root/task2/avgs.sh

#add the cron job
crontab -l > cron_bkp
echo "0 * * * *  /root/task2/cpuUtilization.sh >> /var/www/html/cpu.html;/root/task2/memUsedAndAvailable.sh >> /var/www/html/mem.html;/root/task2/usedAndAvailable.sh >> /var/www/html/disk.html 2>&1 " >> cron_bkp
echo "0 * * * * /root/task2/avgs.sh > /var/www/html/avgs.html 2>&1 " >> cron_bkp
crontab cron_bkp
rm cron_bkp

