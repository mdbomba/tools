version='20240226'
#
# This script loads environmental variables and dependent applications related to chef
# It is meant to be ran on chef workstations and chef servers before installing chef
#
echo 'This script will load environmental variables related to the insallation and operations of chef'
echo 'This script will also install recommended supporting applications for chef'
echo 'This script should be started usig user level (not sudo) rights.'
echo "Version = $version"
echo ''

#########################################
# CHECK IF SCRIPT WAS STARTED USING SUDO
#########################################
if test "x$EUID" = "x"; then
  echo ''; echo 'Please run this script using normal user rights (not sudo)'
  echo ''
  exit
fi

#####################################
# START LOAD PARAMS SECTION
#####################################

# ENSURE A BACKUP of ~/.bashrc EXISTS
if ! test -f ~/.bashrc_orig; then cp ~/.bashrc ~/.bashrc_orig; fi

# CLEAR OUT OLD CHEF ENTRIES FROM ~/.bashrc 
grep -v -i "CHEF" ~/.bashrc > ~/.bashrc_new                       

# Create function to set environment variables for Chef installs
# usage is  $ loadEnvironment 'variablename' 'value'
loadEnvironment() { 
  if [ "x$1" = "x" ] || [ "x$2" = 'x' ]
    then 
      echo "function loadEnvironment requires 2 arguments"
      echo "Example is  $  loadEnvironment 'CHEF_ADMIN_ID' 'mike' "
      return
    else 
      export $1="$2"
      echo "export $1='$2'  # CHEF PARAM"  >> ~/.chefparams
  fi
}

# ENTER ENVIRONMENTAL VARIABLES FOR CHEF INSTALLATION (saves to ~/.bashrc)
echo "# BELOW ARE PARAMETERS ADDED BY CHEF" > ~/.chefparams          # Create a clean ~/.chefparams file
loadEnvironment 'CHEF_GIT_USER' 'mdbomba'                            # Used to setup a git repo (if needed)
loadEnvironment 'CHEF_GIT_USER_EMAIL' 'mbomba@kemptechnologies.com'  # Used to setup a git repo (if needed)
loadEnvironment 'CHEF_REPO' 'chef-repo'                              # Collect Chef Organization short name (lowercase)
loadEnvironment 'CHEF_ORG' 'chef'                                    # Collect Chef Organization short name (lowercase)
loadEnvironment 'CHEF_ORG_LONG' 'Chef Management Organization'       # Collect Chef Organization long name
loadEnvironment 'CHEF_DOMAINNAME' 'localhost'                        # Collect domain name for Chef environment
loadEnvironment 'CHEF_ADMIN_ID' 'chef'                               # Collect Chef admin login id
loadEnvironment 'CHEF_ADMIN_FIRST' 'Mike'                            # Collect Chef admin first name
loadEnvironment 'CHEF_ADMIN_LAST' 'Bomba'                            # Collect Chef admin last name
loadEnvironment 'CHEF_ADMIN_EMAIL' 'mike.bomba@progress.com'         # Collect Chef admin email
loadEnvironment 'CHEF_WORKSTATION_NAME' 'chef-workstation'           # Collect Chef Workstation name (lowercase)
loadEnvironment 'CHEF_WORKSTATION_IP' '10.0.1.6'                     # Collect Chef Workstation IP address
loadEnvironment 'CHEF_SERVER_NAME' 'chef-server'                     # Collect Chef Server Name (lowercase)
loadEnvironment 'CHEF_SERVER_IP' '10.0.1.7'                          # Collect Chef Server IP address
loadEnvironment 'CHEF_NODE1_NAME' 'chef-node1'                       # Collect Chef Node 1 Name
loadEnvironment 'CHEF_NODE1_IP' '10.0.1.8'                           # Collect Chef Node 1 IP address
loadEnvironment 'CHEF_NODE2_NAME' 'chef-node1'                       # Collect Chef Node 1 Name
loadEnvironment 'CHEF_NODE2_IP' '10.0.1.9'                           # Collect Chef Node 1 IP address

if test `hostname -s` = "$CHEF_WORKSTATION_NAME"                     # Add to parh if this is a chef workstation
  then echo 'eval "$(chef shell-init bash)"'"  # CHEF PARAM" >> ~/.chefparams
fi
. ~/.chefparams                                                      # LOAD PARAMETERS FROM ~/.chefparams
cat ~/.chefparams >> ~/.bashrc_new                                   # ADD NEW CHEF ENTIRES TO ~/.bashrc_new
cp -f ~/.bashrc_new ~/.bashrc
rm -f ~/.bashrc_new

#####################################
# END LOAD PARAMS SECTION
#####################################

#####################################
# START UPDATE /etc/hosts SECTION
#####################################

# CLEAR OLD CHEF ENTRIES FROM /etc/hosts
grep -v -i "CHEF" "/etc/hosts" > ~/.hosts_new

echo "# CHEF INFO
$CHEF_WORKSTATION_IP  $CHEF_WORKSTATION_NAME  $CHEF_WORKSTATION_NAME.$CHEF_DOMAINNAME
$CHEF_SERVER_IP  $CHEF_SERVER_NAME  $CHEF_SERVER_NAME.$CHEF_DOMAINNAME
$CHEF_NODE1_IP  $CHEF_NODE1_NAME  $CHEF_NODE1_NAME.$CHEF_DOMAINNAME
$CHEF_NODE2_IP  $CHEF_NODE2_NAME  $CHEF_NODE2_NAME.$CHEF_DOMAINNAME
" > ~/.hosts_add
echo ''
echo "You ay get prompted for a sudo password to use to create the new /etc/hosts file"
echo ''
cat ~/.hosts_add >> ~/.hosts_new
sudo cp -f ~/.hosts_new /etc/hosts
rm ~/.hosts_new ; rm ~/.hosts_add

#####################################
# END UPDATE /etc/hosts SECTION
#####################################

#####################################
# START LOAD APPLICATIONS SECTION
#####################################

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

#####################################
# END LOAD APPLICATIONS SECTION
#####################################

#####################################
# START UPDATE FOR CHEF SERVER ONLY
#####################################

if test `hostname -s` = "$CHEF_SERVER_NAME"; then
  sudo sysctl -w vm.max_map_count=262144           | sudo tee /dev/null >> /dev/null
  sudo sysctl -w vm.dirty_expire_centisecs=20000   | sudo tee /dev/null >> /dev/null
  grep -v 'sysctl' /etc/sysctl.conf                | sudo tee    /etc/sysctl.conf >> /dev/null
  echo 'sysctl -w vm.max_map_count=262144'         | sudo tee -a /etc/sysctl.conf >> /dev/null
  echo 'sysctl -w vm.dirty_expire_centisecs=20000' | sudo tee -a /etc/sysctl.conf >> /dev/null
fi

#####################################
# END UPDATE FOR CHEF SERVER ONLY
#####################################

#####################################
# START UPDATE SSL CACHE
#####################################
if test `hostname -s` = "$CHEF_WORKSTATION_NAME"; then
  rm -f ~/.ssh/chef_rsa*
  ssh-keygen -b 4092 -f ~/.ssh/chef_rsa -N '' 
  cat  ~/.ssh/chef_rsa.pub >> ~/.ssh/authorized_keys
  knife ssl fetch https://$CHEF_SERVER_NAME
  knife ssl fetch https://$CHEF_SERVER_IP
fi
if test `hostname -s` = "$CHEF_SERVER_NAME"; then
  knife ssl fetch https://$CHEF_WORKSTATION_NAME
  knife ssl fetch https://$CHEF_WORKSTATION_IP
fi
#####################################
# END UPDATE SSL CACHE
#####################################

