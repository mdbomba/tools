#

read -p "Enter full path to file to download (e.g. /home/chef/progress-validator.pem): " filepath
if [ "x$filepath" = "x" ]; then filepath='/home/chef/progress-validator.pem' ; fi

read -p "Enter the admin account name to access the server holding the file to download (chef): " user
if [ "x$userid" = "x" ]; then user='chef'; fi

read -p "Enter the admin account credential path (~/.ssh/id_rsa.pub): " cred
if [ "x$credpath" = "x" ]; then cred=~/.ssh/id_rsa.pub ; fi

read -p "Enter the server name holding the file to download (server): " server
if [ "x$server" = "x" ]; then server='server'; fi

read -p "Enter the local file path to store the downloaded file (validator.pem): " newpath
if [ "x$newpath" = "x" ]; then newpath='validator.pem'; fi

echo ''
echo "Copying $filepath using credentials $user from server $server to location $newpath"
echo ''
echo "PLEASE ENTER SUDO PASSWORD FOR CHEF SERVER"
echo ''

ssh -i $cred -t $user@$server "sudo chmod 644 $filepath"
scp -i $cred $user@$server:$filepath $newpath
ssh -i $cred -t $user@$server "sudo chmod 600 $filepath"
chmod 600 $newpath
