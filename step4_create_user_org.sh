#########################
# CREATE CHEF ADMIN USER
#########################
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