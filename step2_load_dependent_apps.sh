version='20240229'
cd ~
. ./.bashrc

if [ "x$CHEF_ADMIN_ID" = "x" ]; then echo "Please run params.sh script before running this script"; exit; fi

#####################################
# START UPDATE /etc/hosts SECTION
#####################################

# CLEAR OLD CHEF ENTRIES FROM /etc/hosts
grep -v -i "CHEF" /etc/hosts > ~/.hosts

echo "# CHEF INFO
$CHEF_WORKSTATION_IP  $CHEF_WORKSTATION_NAME  $CHEF_WORKSTATION_NAME.$CHEF_DOMAINNAME  # CHEF Workstation
$CHEF_SERVER_IP  $CHEF_SERVER_NAME  $CHEF_SERVER_NAME.$CHEF_DOMAINNAME  # CHEF Server
$CHEF_NODE1_IP  $CHEF_NODE1_NAME  $CHEF_NODE1_NAME.$CHEF_DOMAINNAME  # CHEF Node 1
$CHEF_NODE2_IP  $CHEF_NODE2_NAME  $CHEF_NODE2_NAME.$CHEF_DOMAINNAME  # CHEF Node 2
" >> ~/.hosts

sudo cp -f ~/.hosts /etc/hosts; rm ~/.hosts

#####################################
# END UPDATE /etc/hosts SECTION
#####################################

#####################################
# START LOAD APPLICATIONS SECTION
#####################################

# curl is used across all chef components
if [ ! `command -v curl` ]; then sudo apt install curl -y; fi
if [ -f ./.curlrc ]; then grep -v -i 'tls' ./.curlrc | grep -v -i 'insecure' > .curlrc_new; fi
echo "--tlsv1.2" >> ./.curlrc_new; echo '--insecure' >> ./.curlrc_new; cp -f ./.curlrc_new ./.curlrc; rm ./.curlrc_new

# apparmor can cause issues with Chef Server(s), so below will remove apparmor
if [ `command -v apparmor` ]; then sudo apt remove apparmor -y; fi

# git is used for most chef components
if [ ! `command -v git` ]; then sudo apt install git -y; fi
git config --global user.name "$CHEF_GIT_USER"
git config --global user.email "$CHEF_GIT_EMAIL"

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
    wget -O 'code.deb' 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    sudo dpkg -i code.deb
    rm code.deb
  fi
fi

#####################################
# END LOAD APPLICATIONS SECTION
#####################################

#####################################
# START UPDATE FOR CHEF SERVER ONLY
#####################################

sudo  sysctl -w vm.max_map_count=262144
sudo  sysctl -w vm.dirty_expire_centisecs=20000
echo "vm.max_map_count=262144"         | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_expire_centisecs=20000" | sudo tee -a /etc/sysctl.conf

#####################################
# END UPDATE FOR CHEF SERVER ONLY
#####################################

#####################################
# START UPDATE SSL CACHE
#####################################
if test `hostname -s` = "$CHEF_WORKSTATION_NAME"; then
  rm -f ~/.ssh/"$CHEF_ADMIN_ID"_rsa*
  ssh-keygen -b 4092 -f ~/.ssh/"$CHEF_ADMIN_ID"_rsa -N '' 
  cat  ~/.ssh/"$CHEF_ADMIN_ID"_rsa.pub >> ~/.ssh/authorized_keys
fi
# if test `hostname -s` = "$CHEF_WORKSTATION_NAME"; then
#   knife ssl fetch https://$CHEF_SERVER_NAME
#   knife ssl fetch https://$CHEF_SERVER_IP
# fi
#####################################
# END UPDATE SSL CACHE
#####################################
#
echo ''
echo '################################################################'
echo '#                                                              #'
echo '#  Please reboot server and then run appropriate step3 script  #'
echo '#                                                              #'
echo '################################################################'
