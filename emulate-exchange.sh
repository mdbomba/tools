clear
echo "SCRIPT TO CONFIGURE apache2 SERVER TO EMULATE MS EXCHANGE HEALTH CHECKS"
echo ""

sudo apt install tree

if ! test -d /var/www; then echo "apache2 not installed. Exiting script"; exit; fi
if ! test -d /var/www/html; then echo "apache2 not installed. Exiting script"; exit; fi

service=EXCHANGE
msg='<!DOCTYPE html> <html><head><title>'"$service "'CHECK PAGE</title></head> <style> p { color: black; } .title2 { font-size: 20px; text-align: center; } .paragraph1 { font-size: 15px; text-align: left; } </style> <h1>'"$service "'CHECK PAGE</h1> <hr> <br> <p class="title1">THIS IS THE DEFAULT CHECK PAGE FOR '"$service "'<br> </p> <br><br> <p class="paragraph1">If you can read this page, then it is highly likely the '"$service "'service is alive and well. <br><br> </p> </body></html>'

if ! test -d /var/www/html/autodiscover; then sudo mkdir /var/www/html/autodiscover; fi
sudo echo $msg > /var/www/html/autodiscover/healthcheck.htm
if ! test -d /var/www/html/ecp; then sudo mkdir /var/www/html/ecp; fi
sudo echo $msg > /var/www/html/ecp/healthcheck.htm
if ! test -d /var/www/html/ews; then sudo mkdir /var/www/html/ews; fi
  sudo echo $msg > /var/www/html/ews/healthcheck.htm
if ! test -d /var/www/html/mapi; then sudo mkdir /var/www/html/mapi; fi
sudo echo $msg > /var/www/html/mapi/healthcheck.htm
if ! test -d /var/www/html/microsoft-server-activesync; then sudo mkdir /var/www/html/microsoft-server-activesync; fi
sudo echo $msg > /var/www/html/microsoft-server-activesync/healthcheck.htm
if ! test -d /var/www/html/oab; then sudo mkdir /var/www/html/oab; fi
sudo echo $msg > /var/www/html/oab/healthcheck.htm
if ! test -d /var/www/html/owa; then sudo mkdir /var/www/html/owa; fi
sudo echo $msg > /var/www/html/owa/healthcheck.htm
if ! test -d /var/www/html/powershell; then sudo mkdir /var/www/html/powershell; fi
sudo echo $msg > /var/www/html/powershell/healthcheck.htm
if ! test -d /var/www/html/rpc; then sudo mkdir /var/www/html/rpc; fi
sudo echo $msg > /var/www/html/rpc/healthcheck.htm

echo 'This server has been configured to emulate health checking process for Microsoft Exchange'

echo 'SCRIPT COMPLETED'

tree /var/www/html


