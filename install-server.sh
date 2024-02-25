version='20240224'
cd ~
#
# This script installs chef workstation on either Ubunto or Redhat Linux
#
echo 'This script installs chef server (automate + infra-server + habitat builder)'
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
sudo ./chef-automate deploy --product builder --product automate --product infra-server
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

#####################################
# UPDATE SSL CACHE
#####################################
if ping -c 1 $CHEF_WORKSTATION_IP &> /dev/null; then
  scp  ~/*.pem "$CHEF_ADMIN_ID@$CHEF_WORKSTATION_NAME:/home/$CHEF_ADMIN_ID/.chef/$CHEF_ADMIN_ID.pem"
  scp  ~/*.toml "$CHEF_ADMIN_ID@$CHEF_WORKSTATION_NAME:/home/$CHEF_ADMIN_ID/.chef/"
fi

