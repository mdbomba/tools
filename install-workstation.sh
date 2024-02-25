version='20240224'
cd ~
#
# This script installs chef workstation on either Ubunto or Redhat Linux
#
echo 'This script installs chef workstation'
echo 'This script should be started using user level (not sudo) rights.'
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

# SOURCES FOR rpm and deb PACKAGES FOR CHEF WORKSTATION
DEB_URL='https://packages.chef.io/files/stable/chef-workstation/23.12.1055/ubuntu/22.04/chef-workstation_23.12.1055-1_amd64.deb'
RPM_URL='https://packages.chef.io/files/stable/chef-workstation/21.10.640/el/8/chef-workstation-21.10.640-1.el8.x86_64.rpm'

# DETERMINE LINUX VARIENT
if test -f /etc/lsb-release; then . /etc/lsb-release; fi
if test "x$DISTRIB_ID" = "xUbuntu"; then URL="$DEB_URL"; else URL="$RPM_URL"; fi
PKG=`echo $URL | cut -d "/" -f 10`

######################################
# CREATE GIT REPO
#######################################
git config --global user.name "$CHEF_GIT_USER"
git config --global user.email "$CHEF_GIT_EMAIL"

#################################
# UPDATE HOST
#################################
sudo apt update
sudo apt upgrade -y

########################################
# DOWNLOAD AND INSTALL CHEF WORKSTATION
########################################
wget -O "$PKG" "$URL"                                                        ; # Download Chef Workstation package
if test "x$DISTRIB_ID" = "xUbuntu"
  then sudo dpkg -i "$PKG"                                                   ; # Install Chef Workstation
  else sudo yum localinstall "$PKG"
fi
chef generate repo "$CHEF_REPO"                                               ; # Create first chef repo 

##########################
# CREATE CREDENTIALS FILE
##########################
if ! test -d ~/.chef; then mkdir ~/.chef; fi
echo "[default]
client_name     = '$CHEF_ADMIN_ID'
client_key      = '/home/$CHEF_ADMIN_ID/.chef/$CHEF_ADMIN_ID.pem'
chef_server_url = 'https://$CHEF_SERVER_NAME/organizations/$CHEF_ORG'
" > ~/.chef/credentials

#####################################
# UPDATE SSL USER KEY
#####################################
if test `hostname -s` = "$CHEF_WORKSTATION_NAME"; then
  rm -f ~/.ssh/chef_rsa*
  ssh-keygen -b 4092 -f ~/.ssh/chef_rsa -N '' 
  cat  ~/.ssh/chef_rsa.pub >> ~/.ssh/authorized_keys
fi

#####################################
# UPDATE SSL CACHE
#####################################
if ping -c 1 $CHEF_SERVER_IP &> /dev/null; then
  scp "$CHEF_ADMIN_ID@$CHEF_SERVER:/home/$CHEF_ADMIN_ID/$CHEF_ADMIN_ID.pem" ~/.chef/$CHEF_ADMIN_ID.pem
  knife ssl fetch https://$CHEF_SERVER_NAME
  knife ssl fetch https://$CHEF_SERVER_IP
fi



