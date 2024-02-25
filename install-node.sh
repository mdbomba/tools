version=20240224
cd ~
#
# This script installs chef client on amanaged node (Ubunto or Redhat)
#
echo 'This script installs chef client on amanaged node (Ubunto or Redhat)'
echo 'This script should be started using user level (not sudo) rights.'
echo "Version = $version"
echo ''

#########################################
# CHECK IF SCRIPT WAS STARTED USING SUDO
#########################################
if test "x$EUID" = "x"; then
  echo ''; echo 'Please run this script using normal user rights (not sudo)'
  echo ''
  exit
fi

# Do some chef pre-work
sudo mkdir -p /etc/chef
sudo mkdir -p /var/lib/chef
sudo mkdir -p /var/log/chef

cd /etc/chef

# Create first-boot.json
cat > "./first-boot.json" << EOF
{
   "policy_group": "dev",
   "policy_name": "base"
}
EOF

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

scp "$CHEF_ADMIN_ID@$CHEF_SERVER_NAME:/home/$CHEF_ADMIN_ID/$CHEF_ORG-validator.pem" ./


wget -O install.sh  https://omnitruck.chef.io/install.sh
chmod +x install.sh
sudo ./install.sh -v 'latest'