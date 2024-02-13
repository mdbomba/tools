# Version 20240213
#
version='20240213'
#
# This script loads environmental variables related to Chef
#
echo ""
echo "######################################################################################"
echo "#                                                                                    #"
echo "#   This script will load environmental variables and app packages related to the    #"
echo "#   installation and operations of Chef. Script Version = $version                   #"
echo "#                                                                                    #"
echo "######################################################################################"
echo ''
#
STAMP=$(date +"_%Y%j%H%M%S")
#
# Create function to set environment variables for Chef installs
# usage is  $ loadEnvironment 'variablename' 'value'
#
# CLEAR OLD ENTRIES FROM .bashrc

echo ""
echo "ENTER THE PASSWORD FOR sudo COMMANDS"
sudo echo ''  >> /dev/null

echo ""
echo "PLEASE ENTER THE PATH TO YOUR HOME DIRECTORY."
myhome='/x'; while ! test -f "$myhome/.bashrc" || test `echo "${myhome:0-1}" = '/'`; do read -p "Enter the path to your home directory (e.g. /home/mike): " myhome; done

echo ""
echo "PLEASE ENTER THE DOMAIN NAME FOR YOUR CHEF INFRASTRUCTURE."
dname=''; while test "x$dname" = "x"; do read -p "Enter the domain name for your chef infrastructure (i.e. localhost, company.com): " dname; done

cd $myhome

# CLEAR OLD CHEF ENTRIES FROM .bashrc
grep -v -i "CHEF" ".bashrc" > bashrc

# CREATE ADDITIONS FILE TO BE ADDED TO .bashrd
echo '# START OF CHEF PARAMETERS
CHEF_ORG="chef-demo"                          ; # Collect Chef Organization short name (lowercase)
CHEF_ORG_LONG="Chef Demo Organization"        ; # Collect Chef Organization long name
CHEF_DOMAINNAME="$dname"                      ; # Collect domain name for Chef environment
CHEF_ADMIN_ID="mike"                          ; # Collect Chef admin login id
CHEF_ADMIN_FIRST="Mike"                       ; # Collect Chef admin first name
CHEF_ADMIN_LAST="Bomba"                       ; # Collect Chef admin last name
CHEF_ADMIN_EMAIL="mike.bomba@progress.com"    ; # Collect Chef admin email
CHEF_WORKSTATION_NAME="chef-workstation"      ; # Collect Chef Workstation name (lowercase)
CHEF_WORKSTATION_IP="10.0.0.6"                ; # Collect Chef Workstation IP address
CHEF_AUTOMATE_NAME="chef-automate"            ; # Collect Chef Automate Server Name (lowercase)
CHEF_AUTOMATE_IP="10.0.0.7"                   ; # Collect Chef Automate Server IP address
CHEF_NODE1_NAME="chef-node1"                  ; # Collect Chef Node 1 Name
CHEF_NODE1_IP="10.0.0.8"                      ; # Collect Chef Node 1 IP address
CHEF_NODE2_NAME="chef-node2"                  ; # Collect Chef Node 2 Name
CHEF_NODE2_IP="10.0.0.9"                      ; # Collect Chef Node 2 IP address
CHEF_WORKSTATION_URL="https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb"
CHEF_AUTOMATE_URL="https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip"
' > chefparams ; cp -f chefparams .chefparams
. .chefparams

cat bashrc chefparams > newbashrc
cp -f newbashrc  .bashrc


# LOAD PARAMETERS FROM .bashrc

. .bashrc

# UPDATE /etc/hosts WITH INFO FROM PARAMETERS LOADED FROM .bashrc

# CLEAR OLD CHEF ENTRIES FROM /etc/hosts
grep -v -i "CHEF" "/etc/hosts" > $myhome/oldhosts

# DETERMINE CURRENT DEVICE DATA TO ADD TO /etc/hosts
hname=`hostname -s`
hdname="$hname.$dname"

echo "# CHEF INFO
127.0.1.1  $hname  $hdname
$CHEF_WORKSTATION_IP  $CHEF_WORKSTATION_NAME  $CHEF_WORKSTATION_NAME.$CHEF_DOMAINNAME
$CHEF_AUTOMATE_IP  $CHEF_AUTOMATE_NAME  $CHEF_AUTOMATE_NAME.$CHEF_DOMAINNAME
$CHEF_NODE1_IP  $CHEF_NODE1_NAME  $CHEF_NODE1_NAME.$CHEF_DOMAINNAME
$CHEF_NODE2_IP  $CHEF_NODE2_NAME  $CHEF_NODE2_NAME.$CHEF_DOMAINNAME
" > $myhome/newhosts

cat $myhome/oldhosts $myhome/newhosts > $myhome/hosts
sudo cp -f $myhome/hosts /etc/hosts

# apparmor can cause issues with Chef Server(s), so below will remove apparmor
if [ `command -v apparmor` ]; then sudo apt remove apparmor -y; fi

# git is used for most chef components
if [ ! `command -v git` ]; then sudo apt install git -y; fi
git config --global user.name "$CHEF_GIT_USER"
git config --global user.email "$CHEF_GIT_EMAIL"

# curl is used across all chef components
if [ ! `command -v curl` ]; then sudo apt install curl -y; fi
sed '/tlsv1.2/d' ~/.curlrc > ~/.curlrc
sed '/insecure/d' ~/.curlrc > ~/.curlrc
echo "--tlsv1.2" >> ~/.curlrc
echo '--insecure' >> ~/.curlrc

# Install tree (pretty version of "ls -lr" command )
if [ ! `command -v tree` ]; then sudo apt install tree -y; fi

# Install gzip
if [ ! `command -v gzip` ]; then sudo apt install gzip -y; fi

# Ensure openssh-server is installed
if [ ! `command -v sshd` ]; then sudo apt install openssh-server -y; fi

# Install additional tools
if [ ! `command -v wget` ]; then sudo apt install wget -y; fi
if [ ! `command -v add-apt-repository` ]; then sudo apt install software-properties-common -y; fi
if [ ! `command -v apt-get` ]; then sudo apt install apt-transport-https -y; fi

# Install Microsoft Visual Studio code (use firefox test to ensure this is a workstation and not a server)
if test `command -v firefox`; then
  echo ''; echo "INSTALLING or UPDATING Microsoft Vistual Studio Code";
  if ! test `command -v code`; then 
    sudo wget -O 'code.deb' 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    sudo dpkg -i code.deb
  fi
fi

# Update system settings needed for Chef Server
sudo sysctl -w vm.max_map_count=262144           | sudo tee /dev/null >> /dev/null
sudo sysctl -w vm.dirty_expire_centisecs=20000   | sudo tee /dev/null >> /dev/null
grep -v 'sysctl' /etc/sysctl.conf                | sudo tee    /etc/sysctl.conf >> /dev/null
echo 'sysctl -w vm.max_map_count=262144'         | sudo tee -a /etc/sysctl.conf >> /dev/null
echo 'sysctl -w vm.dirty_expire_centisecs=20000' | sudo tee -a /etc/sysctl.conf >> /dev/null

sudo hostname "$hdname"
echo $hdname | sudo tee /etc/hostname >> /dev/null

rm .ssh/*
ssh-keygen -b 4092 -f ~/.ssh/id_rsa -N '' 
cp .ssh/id_rsa.pub .ssh/authorized_keys
knife ssl fetch https://$CHEF_AUTOMATE_NAME/organizations/$CHEF_ORG
knife ssl fetch https://$CHEF_AUTOMATE_NAME.$CHEF_DOMAINNAME/organizations/$CHEF_ORG
knife ssl fetch https://$CHEF_AUTOMATE_IP/organizations/$CHEF_ORG



echo ""
echo "######################################################################################"
echo "#                                                                                    #"
echo "#    Parameters are loaded into .bashrc. To make them active close and reopen bash   #"
echo "#                                                                                    #"
echo "######################################################################################"
echo ''
