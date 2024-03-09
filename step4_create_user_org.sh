version='20240229'
# This script performs post installation configuration on chef worksatation or chef server
echo 'Step4 script performs post installation configuration on chef worksatation or chef server.'
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

##################################################
# POST INSTALL CONFIGURATION  FOR CHEF WORKSTATION
##################################################
if test `hostname -s` = $CHEF_WORKSTATION_NAME; then
  # ADD PATH TO .bashrc
  echo 'eval "$(chef shell-init bash)"'"  # CHEF PARAM" | tee -a ~/.bashrc >> /dev/null
  . ~/.bashrc
  # GENERATE DEFAULT CHEF REPO
  chef generate repo "$CHEF_REPO" --chef-license 'accept'
  # CREATE CREDENTIALS FILE
  if ! test -d ~/.chef; then mkdir ~/.chef; fi
  echo "[default]
  client_name     = '$CHEF_ADMIN_ID'
  client_key      = '/home/$CHEF_ADMIN_ID/.chef/$CHEF_ADMIN_ID.pem'
  chef_server_url = 'https://$CHEF_SERVER_NAME/organizations/$CHEF_ORG'
  " > ~/.chef/credentials
  # UPDATE SSL CERTIFICATE CACHE
  if ping -c 1 $CHEF_SERVER_IP &> /dev/null; then
    knife ssl fetch https://$CHEF_SERVER_NAME
    knife ssl fetch https://$CHEF_SERVER_IP
  fi
fi

#############################################
# POST INSTALL CONFIGURATION  FOR CHEF SERVER
#############################################
if test `hostname -s` = $CHEF_SERVER_NAME; then
  # CREATE CHEF ADMIN USER
  if [ ! -f "./$CHEF_ADMIN_ID.pem" ]
    then
      sudo chef-server-ctl user-create "$CHEF_ADMIN_ID" "$CHEF_ADMIN_FIRST" "$CHEF_ADMIN_LAST" "$CHEF_ADMIN_EMAIL" "$CHEF_ADMIN_PASSWORD" --filename "$CHEF_ADMIN_ID.pem"
  fi
  # CREATE CHEF ORGANIZATION
  if [ ! -f "./$CHEF_ORG-validator.pem" ]
    then
      sudo chef-server-ctl org-create "$CHEF_ORG" "$CHEF_ORG_LONG" --association_user "$CHEF_ADMIN_ID" --filename "$CHEF_ORG-validator.pem"
  fi
  # UPDATE .chef ON WORKSTATION WITH .pem FILES
  sudo scp *.pem $CHEF_ADMIN_ID@$CHEF_WORKSTATION_IP:/home/$CHEF_ADMIN_ID/.chef/
fi

###############
# END OF SCRIPT
###############
