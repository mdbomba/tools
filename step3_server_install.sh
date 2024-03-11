version='20240308'
# This script installs chef server with automate on either Ubunto or Redhat Linux
echo 'Step3 script installs chef automate + infra server.'
echo "Version = $version"
echo ''
###################################################
# ENSURE SCRIPT WAS STARTED NOT STARTED USING SUDO
###################################################
if test "x$EUID" = "x"; then
  echo ''; echo 'This script should be started using user level (not sudo) rights. Script is terminating.'
  echo ''
  exit
fi
#
cd ~
. ./.bashrc
#
#######################################################################
# DOWNLOAD AND INSTALL CHEF SERVER (AUTOMATE + INFRA_SERVER + BUILDER)
#######################################################################
curl https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate
sudo ./chef-automate deploy --product automate --product infra-server
sudo chef-automate init-config
#
#########################
# CREATE CHEF ADMIN USER
#########################
read -p  "Enter password for Chef Admin Account ($CHEF_ADMIN_ID): " CHEF_ADMIN_PASSWORD
if [ ! -f "./$CHEF_ADMIN_ID.pem" ]
  then
    sudo chef-server-ctl user-create "$CHEF_ADMIN_ID" "$CHEF_ADMIN_FIRST" "$CHEF_ADMIN_LAST" "$CHEF_ADMIN_EMAIL" "$CHEF_ADMIN_PASSWORD" --filename "$CHEF_ADMIN_ID.pem"
fi
#
###########################
# CREATE CHEF ORGANIZATION
###########################
if [ ! -f "./$CHEF_ORG""-validator.pem" ]
  then
    sudo chef-server-ctl org-create "$CHEF_ORG" "$CHEF_ORG_LONG" --association_user "$CHEF_ADMIN_ID" --filename "$CHEF_ORG-validator.pem"
fi

