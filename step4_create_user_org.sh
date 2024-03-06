################################
# INITIAL CONFIG
################################
echo 'eval "$(chef shell-init bash)"'"  # CHEF PARAM" | tee -a ~/.bashrc >> /dev/null; . ~/.bashrc
chef generate repo "$CHEF_REPO" --chef-license 'accept'

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
# UPDATE SSL CERTIFICATE CACHE
#####################################
if ping -c 1 $CHEF_SERVER_IP &> /dev/null; then
  knife ssl fetch https://$CHEF_SERVER_NAME
  knife ssl fetch https://$CHEF_SERVER_IP
fi

#########################
# CREATE CHEF ADMIN USER
#########################
if test `hostname -s` = $CHEF_SERVER_NAME; then

  read -p  "Enter password for Chef Admin Account ($CHEF_ADMIN_ID): " $CHEF_ADMIN_PASSWORD
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
fi
