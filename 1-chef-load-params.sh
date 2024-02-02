# Version 20240201
#
version='20240201'
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

grep -v "CHEF" ~/.bashrc | tee ~/.bashrc >> /dev/null
grep -v "CHEF" /etc/hosts | sudo tee /etc/hosts >> /dev/null
echo "127.0.1.1  $HOSTNAME" | sudo tee -a /etc/hosts >> /dev/null

loadEnvironment() { 
newValue=''  
if [ "x$1" = "x" ] || [ "x$2" = 'x' ]
  then 
    echo "function loadEnvironment requires 2 arguments"
    echo "Example is  $  loadEnvironment 'CHEF_ADMIN_ID' 'mike' "
    return
  else 
    echo "$1='$2'"   | tee -a ~/.bashrc >> /dev/null
    echo "export $1" | tee -a ~/.bashrc >> /dev/null
fi
}


#
# Create function to update /etc/hosts file with chef componnets
# usage is  $ loadHost 'ip address' 'hostname' 'domainname'
#
loadHost() {
if [ "x$1" = "x" ] || [ "x$2" = 'x' ] || [ "x$3" = "x" ]
  then 
    echo "function loadHost requires 3 arguments" 
    echo "usage is  $ loadHost 'ip address' 'hostname' 'domainname'"
     return
  else 
    sudo echo "$1  $2 $2.$3" | sudo tee -a /etc/hosts >> /dev/null
fi
}

# ENTER ENVIRONMENTAL VARIABLES FOR CHEF INSTALLATION (saves to ~/.bashrc)

loadEnvironment 'CHEF_ORG' 'chef-demo'                          ; # Collect Chef Organization short name (lowercase)
loadEnvironment 'CHEF_ORG_LONG' 'Chef Demo Organization'        ; # Collect Chef Organization long name
loadEnvironment 'CHEF_DOMAINNAME' 'localhost'                   ; # Collect domain name for Chef environment

loadEnvironment 'CHEF_ADMIN_ID' 'mike'                          ; # Collect Chef admin login id
loadEnvironment 'CHEF_ADMIN_FIRST' 'Mike'                       ; # Collect Chef admin first name
loadEnvironment 'CHEF_ADMIN_LAST' 'Bomba'                       ; # Collect Chef admin last name
loadEnvironment 'CHEF_ADMIN_EMAIL' 'mike.bomba@progress.com'    ; # Collect Chef admin email

loadEnvironment 'CHEF_WORKSTATION_NAME' 'chef-workstation'      ; # Collect Chef Workstation name (lowercase)
loadEnvironment 'CHEF_WORKSTATION_IP' '10.0.0.5'                ; # Collect Chef Workstation IP address

loadEnvironment 'CHEF_INFRA_NAME' 'chef-infra'                  ; # Collect Chef Infra Server Name (lowercase)
loadEnvironment 'CHEF_INFRA_IP' '10.0.0.6'                      ; # Collect Chef Infra Server IP address

loadEnvironment 'CHEF_AUTOMATE_NAME' 'chef-automate'            ; # Collect Chef Automate Server Name (lowercase)
loadEnvironment 'CHEF_AUTOMATE_IP' '10.0.0.7'                   ; # Collect Chef Automate Server IP address

loadEnvironment 'CHEF_NODE1_NAME' 'chef-node1'                  ; # Collect Chef Node 1 Name
loadEnvironment 'CHEF_NODE1_IP' '10.0.0.8'                      ; # Collect Chef Node 1 IP address

loadEnvironment 'CHEF_NODE2_NAME' 'chef-node2'                  ; # Collect Chef Node 2 Name
loadEnvironment 'CHEF_NODE2_IP' '10.0.0.9'                      ; # Collect Chef Node 2 IP address

loadEnvironment 'CHEF_WORKSTATION_URL' "https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb"
loadEnvironment 'CHEF_AUTOMATE_URL' 'https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip'

# need to update /etc/hosts to add all above names and IP addresses
sudo cp /etc/hosts "/etc/hosts$STAMP"
loadHost "$CHEF_WORKSTATION_IP" "$CHEF_WORKSTATION_NAME" "$CHEF_DOMAINNAME"
loadHost "$CHEF_INFRA_IP" "$CHEF_INFRA_NAME" "$CHEF_DOMAINNAME"
loadHost "$CHEF_AUTOMATE_IP" "$CHEF_AUTOMATE_NAME" "$CHEF_DOMAINNAME"
loadHost "$CHEF_NODE1_IP" "$CHEF_NODE1_NAME" "$CHEF_DOMAINNAME"
loadHost "$CHEF_NODE2_IP" "$CHEF_NODE2_NAME" "$CHEF_DOMAINNAME"

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

# Add Repo for Microsoft Visual Studio Code
if [ ! `command -v wget` ]; then 
  if ! which 'code' | grep -q -w '/usr/bin/code' - ; then 
    if [ ! -f /usr/share/keyrings/vscode.gpg ]
      then
        echo "################### GET CODE SIGNING KEY FOR VISUAL STUDIO CODE ############################"
        sudo wget -O- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg /dev/null
    fi

    if [ ! -f /etc/apt/sources.list.d/vscode.list ]
      then
        echo "################################## ADDING VISUAL STUDIO CODE GIT_REPOSITORY TO APT STORE ###########################"
        echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | sudo tee /etc/apt/sources.list.d/vscode.list
    fi
    # Install Visual Studio Code
    sudo apt update
    sudo apt install code -y
  fi
fi
# Update system settings needed for Chef Server
sudo sysctl -w vm.max_map_count=262144           | sudo tee /dev/null >> /dev/null
sudo sysctl -w vm.dirty_expire_centisecs=20000   | sudo tee /dev/null >> /dev/null
grep -v 'sysctl' /etc/sysctl.conf                | sudo tee    /etc/sysctl.conf >> /dev/null
echo 'sysctl -w vm.max_map_count=262144'         | sudo tee -a /etc/sysctl.conf >> /dev/null
echo 'sysctl -w vm.dirty_expire_centisecs=20000' | sudo tee -a /etc/sysctl.conf >> /dev/null

echo ""
echo "######################################################################################"
echo "#                                                                                    #"
echo "#    Parameters are loaded into .bashrc. To make them active close and reopen bash   #"
echo "#                                                                                    #"
echo "######################################################################################"
echo ''
