# TEST TO SEE IF CHEF SERVER ALREADY INSTALLED

if test `command -v chef-server-ctl` = '/usr/bin/chef-server-ctl'
 then
   echo "CHEF SERVER ALREADY INSTALLED - SKIPPING INSTALL"
 else
   mkdir ~/.chef
   read -p "Enter password for chef admin accout ($CHEF_ADMIN_ID): " CHEF_ADMIN_PASSWORD
   wget https://github.com/mdbomba/tools/blob/main/install.sh
   chmod +x install.sh
   sudo ./install.sh -P chef-server
   sudo chef-server-ctl reconfigure
fi


cd ~/.chef

# CREATE CHEF ADMIN USER AND ASSOCIATED PEM FILE
if [ ! -f "./$CHEF_ADMIN_ID.pem" ]
  then
    sudo chef-server-ctl user-create "$CHEF_ADMIN_ID" "$CHEF_ADMIN_FIRST" "$CHEF_ADMIN_LAST" "$CHEF_ADMIN_EMAIL" "$CHEF_ADMIN_PASSWORD" --filename "$CHEF_ADMIN_ID.pem"
fi

# CREATE CHEF ORGANIZATION AND ORGAMIZATION PEM FILE

if [ ! -f "./$CHEF_ORG-validator.pem" ]
  then
    sudo chef-server-ctl org-create "$CHEF_ORG" "$CHEF_ORG_LONG" --association_user "$CHEF_ADMIN_ID" --filename "$CHEF_ORG-validator.pem"
fi

