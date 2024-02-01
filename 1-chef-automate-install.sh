# read -p  "Enter password for Chef Admin Account ($CHEF_ADMIN_ID): " $CHEF_ADMIN_PASSWORD
# sudo ./install.sh -P automate


# Download Chef Automate installer
curl "$CHEF_AUTOMATE_URL" | gunzip - > chef-automate && chmod +x chef-automate

# Initialize automate installer
sudo ./chef-automate init-config

# Install builder, automate and infra server 
sudo ./chef-automate deploy --product builder --product automate


