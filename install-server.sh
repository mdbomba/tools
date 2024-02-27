version='20240227'
. ~/.bashrc
cd ~
#
# This script installs chef server with automate on either Ubunto or Redhat Linux
#
echo 'This script installs chef server (automate + infra-server)'
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

# Collect chef admin password (needed to create a new chef user)
read -p  "Enter password for Chef Admin Account ($CHEF_ADMIN_ID): " $CHEF_ADMIN_PASSWORD

#######################################################################
# DOWNLOAD AND INSTALL CHEF SERVER (AUTOMATE + INFRA_SERVER + BUILDER)
#######################################################################
curl https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate
sudo ./chef-automate deploy --product automate --product infra-server
sudo chef-server-ctl reconfigure

#########################
# CREATE CHEF ADMIN USER
#########################
if [ ! -f "./$CHEF_ADMIN_ID.pem" ]
  then
    sudo chef-server-ctl user-create "$CHEF_ADMIN_ID" "$CHEF_ADMIN_FIRST" "$CHEF_ADMIN_LAST" "$CHEF_ADMIN_EMAIL" "$CHEF_ADMIN_PASSWORD" --filename "$CHEF_ADMIN_ID.pem"
fi

###########################
# CREATE CHEF ORGANIZATION
###########################
if [ ! -f "./$CHEF_ORG-validator.pem" ]
  then
    sudo chef-server-ctl org-create "$CHEF_ORG" "$CHEF_ORG_LONG" --association_user "$CHEF_ADMIN_ID" --filename "$CHEF_ORG-validator.pem"
fi

###########################
# CREATE SSL KEY
###########################
hn=`hostname -s`
cd ~/.ssh
rm -f "$hn*"
ssh-keygen -b 4092 -f $hn -N '' >> /dev/null
cd ~

#######################################
# ENABLE SSL CERT LOGIN TO CHEF SERVER
#######################################
if ping -c 1 $CHEF_WORKSTATION_IP &> /dev/null; then
  cd ~/.ssh
  scp  "$CHEF_ADMIN_ID@$CHEF_WORKSTATION_NAME:/home/$CHEF_ADMIN_ID/.chef/$CHEF_WORKSTATION_NAME.pub" ./
  cat $CHEF_SERVER_NAME.pub > authorized_keys
  cat $CHEF_WORKSTATION_NAME.pub >> authorized_keys
  scp authorized_keys "$CHEF_ADMIN_ID@$CHEF_WORKSTATION_NAME:/home/$CHEF_ADMIN_ID/.ssh/authorized_keys
  # Copy chef-server login information to chef-workstation 
  scp  ~/*.toml "$CHEF_ADMIN_ID@$CHEF_WORKSTATION_NAME:/home/$CHEF_ADMIN_ID/.chef/"
fi
