version=20240223
#
# Script to install chef server (automate, habitat builder, infra-server)
#
# download to chef server and run after running the chef-load-params script
#
# Collect chef admin password (needed to create a new chef user)
read -p  "Enter password for Chef Admin Account ($CHEF_ADMIN_ID): " $CHEF_ADMIN_PASSWORD

# Download Chef Automate installer
curl https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate

# Use chef-automate to install builder, automate and infra server 
sudo ./chef-automate deploy --product builder --product automate --product infra-server

sudo chef-server-ctl reconfigure

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

