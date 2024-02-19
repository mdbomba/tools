# read -p  "Enter password for Chef Admin Account ($CHEF_ADMIN_ID): " $CHEF_ADMIN_PASSWORD
# sudo ./install.sh -P automate

if test -f ~/.chefparams; then . ~/.chefparams; fi

# Download Chef Automate installer
curl https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate

# Install builder, automate and infra server 
sudo ./chef-automate deploy --product builder --product automate --product infra-server

chef generate repo 'chef-repo'

mkdir ~/chef-repo/.chef


