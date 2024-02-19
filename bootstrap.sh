#!/bin/bash -xe
#
# To get this and other files, first store them in a folder ~/node on the 
# chef workstation. Recommend you source prep.sh, bootstrap.sh, install.sh,
# chef_18.4.2-1_amd64.deb and the org-validator.pem file in this folder.
# The og-validator.pem file was created when you installed and initialized the 
# chef-server.
#   -  wget https://github.com/mdbomba/tools/blob/main/bootstrap.sh
#   -  wget https://github.com/mdbomba/tools/blob/main/prep.sh
#   -  wget https://packages.chef.io/files/stable/chef/18.4.2/ubuntu/22.04/chef_18.4.2-1_amd64.deb
#   -  wget https://omnitruck.chef.io/install.sh
#
# Run prep.sh script before running bootstrap.sh
#   -  prep.sh will update hosts file with chef components
#   -  prep.sh will create a series of environmental variables to support script automation
#   -  prep.sh will download and implement the demo ssh validator key
#
# bootstrap.sh script will do the following
#   -  create required working directories
#   -  download the organization pem file to /etc/chef
#   -  dowload the install.sh script
#   -  create a first-boot.json for initial chef-client execution
#   -  create a client.rb file
#   -  install the chef client and register the node with the chef server
# 
#
# Chef Client bootstrap setup
. ~/.chefparams

# Do some chef pre-work
sudo mkdir -p /etc/chef
sudo mkdir -p /var/lib/chef
sudo mkdir -p /var/log/chef
sudo mkdir -p ~/temp
cd ~/temp
#
# Get all files
#
scp "$CHEF_ADMIN_ID@$CHEF_WORKSTATION_NAME:/home/$CHEF_ADMIN_ID/node/*" .
#
#
# Create first-boot.json
cat > "./first-boot.json" << EOF
{
   "policy_group": "dev",
   "policy_name": "base"
}
EOF
#
sudo cp first-boot.json /etc/chef
#
# Create client.rb
cat > ./client.rb << EOF
log_location     STDOUT
ssl_verify_mode     :verify_none
verify_api_cert     false
chef_server_url  "https://$CHEF_SERVER_NAME/organizations/$CHEF_ORG"
validation_client_name "$CHEF_ORG-validator"
validation_key "/etc/chef/$CHEF_ORG-validator.pem"
node_name  "${HOSTNAME}"
chef_license "accept"
EOF
#
sudo cp client.rb /etc/chef
#
cd /etc/chef
#
# Download the validator key
if [ -f "$HOME/temp/$CHEF_ORG-validator.pem" ]; then
  sudo rm -f "./$CHEF_ORG-validator.pem"
  sudo cp "$HOME/temp/$CHEF_ORG-validator.pem" .
else
  echo "Place $CHEF_ORG-validator.pem in $HOME/temp and rerun script"
  exit
fi
#
# Get install.sh script (needed if .deb file not placed in workstation ~\node folder)
if [ -f "$HOME/temp/install.sh" ]; then
  sudo rm -f ./install.sh
  sudo cp "$HOME/temp/install.sh" .
else
  echo "Place install.sh in $HOME/temp and rerun script"
  exit
fi
#
sudo chmod +x *.sh
#
# Get client .deb file
if [ -f "$HOME/temp/chef_18.4.2-1_amd64.deb" ]; then
  sudo rm -f "./chef_18.4.2-1_amd64.deb"
  sudo cp "$HOME/temp/chef_18.4.2-1_amd64.deb" . 
  sudo dpkg -i ./chef_18.4.2-1_amd64.deb
else 
  sudo ./install.sh -v 'latest'
fi
#
# Run chef-client with the first-boot.json to set the policy
sudo chef-client -j /etc/chef/first-boot.json | sudo tee chef-client-output.txt
echo "Node name is $HOSTNAME" 

