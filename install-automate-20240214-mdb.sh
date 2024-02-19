# read -p  "Enter password for Chef Admin Account ($CHEF_ADMIN_ID): " $CHEF_ADMIN_PASSWORD
# sudo ./install.sh -P automate
# Update system settings needed for Chef Server

. ~/.bashrc
. ~/.chefparams

sudo sysctl -w vm.max_map_count=262144           | sudo tee /dev/null >> /dev/null
sudo sysctl -w vm.dirty_expire_centisecs=20000   | sudo tee /dev/null >> /dev/null
grep -v 'sysctl' /etc/sysctl.conf                | sudo tee    /etc/sysctl.conf >> /dev/null
echo 'sysctl -w vm.max_map_count=262144'         | sudo tee -a /etc/sysctl.conf >> /dev/null
echo 'sysctl -w vm.dirty_expire_centisecs=20000' | sudo tee -a /etc/sysctl.conf >> /dev/null



# Download Chef Automate installer
if ! test -f chef-automate; then
  curl 'https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip' | gunzip - > chef-automate && chmod +x chef-automate
fi

# Initialize automate installer
sudo ./chef-automate init-config

# Install builder, automate and infra server 
sudo ./chef-automate deploy --product builder --product automate --product chef-server

read -p "Enter password for Chef admin account ($CHEF_ADMIN_ID): "  CHEF_ADMIN_PASSWORD

# CREATE CHEF ADMIN USER AND ASSOCIATED PEM FILE
sudo chef-server-ctl user-create "$CHEF_ADMIN_ID" "$CHEF_ADMIN_FIRST" "$CHEF_ADMIN_LAST" "$CHEF_ADMIN_EMAIL" "$CHEF_ADMIN_PASSWORD" --filename "$CHEF_ADMIN_ID.pem"

# CREATE CHEF ORGANIZATION AND ORGAMIZATION PEM FILE
sudo chef-server-ctl org-create "$CHEF_ORG" "$CHEF_ORG_LONG" --association_user "$CHEF_ADMIN_ID" --filename "$CHEF_ORG-validator.pem"
