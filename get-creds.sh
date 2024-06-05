# Script to pull organization validator pem file from chef server
# version: beta_20240605
#
# DEFAULTS (edit before use)
default_filepath='/home/chef/progress-validator.pem' 
default_user='chef'
default_cred='~/.ssh/id_rsa.pub'
default_server='server'
default_newpath='validator.pem'

read -p "Enter full path to file to download ($default_filepath): " filepath
if [ "x$filepath" = "x" ]; then filepath="$default_filepath" ; fi

read -p "Enter the admin account name to access the server holding the file to download ($default_user): " user
if [ "x$userid" = "x" ]; then user="$default_user"; fi

read -p "Enter the admin account credential path ($default_cred): " cred
if [ "x$credpath" = "x" ]; then cred="$default_cred" ; fi

read -p "Enter the server name holding the file to download ($default_server): " server
if [ "x$server" = "x" ]; then server="$default_server"; fi

read -p "Enter the local file path to store the downloaded file ($default_newpath): " newpath
if [ "x$newpath" = "x" ]; then newpath="$default_newpath"; fi

echo ''
echo "Copying $filepath using credentials $user from server $server to location $newpath"
echo ''
echo "PLEASE ENTER SUDO PASSWORD FOR CHEF SERVER ($user@$server) "
echo ''

ssh -i $cred -t $user@$server "sudo chmod 644 $filepath"
scp -i $cred $user@$server:$filepath $newpath
ssh -i $cred -t $user@$server "sudo chmod 600 $filepath"
chmod 600 $newpath
