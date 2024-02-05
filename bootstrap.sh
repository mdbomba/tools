#!/bin/bash -xe
#
# To get this and other files, first store them in a folder ~/node on the 
# chef workstation. Recommend you source prep.sh, bootstrap.sh, install.sh and 
# chef_18.4.2-1_amd64.deb.  You can get prep.sh and bootstrap.sh from
#
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

# Enter sudo su mode
sudo su

. ~/.chefparams

# Do some chef pre-work
mkdir -p /etc/chef
mkdir -p /var/lib/chef
mkdir -p /var/log/chef

cd /etc/chef

# Create first-boot.json
cat > "/etc/chef/first-boot.json" << EOF
{
   "policy_group": "dev",
   "policy_name": "base"
}
EOF

# Create client.rb
cat > /etc/chef/client.rb << EOF
log_location     STDOUT
ssl_verify_mode     :verify_none
verify_api_cert     false
chef_server_url  "https://chef-automate/organizations/chef-demo"
validation_client_name "chef-demo-validator"
validation_key "/etc/chef/chef-demo-validator.pem"
node_name  "${HOSTNAME}"
chef_license "accept"
EOF

# Download the validator key
cd /etc/chef/
if [ ! -f /etc/chef/chef-demo-validator.pem ]; then
 scp mike@mike-mint:/home/mike/.chef/chef-demo-validator.pem /etc/chef/
fi

# Install chef
rm -f ./install.sh*
wget https://omnitruck.chef.io/install.sh 
if [ ! -f ./install.sh ]; then echo "Cound not download install script"; exit ; exit ; fi
chmod +x ./install.sh
./install.sh -v 'latest'

# Run chef-client with the first-boot.json to set the policy
chef-client -j /etc/chef/first-boot.json | tee chef-client-output.txt
echo "Node name is $HOSTNAME" 

# Exit from sudo su mode
exit
