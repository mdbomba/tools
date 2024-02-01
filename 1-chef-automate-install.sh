

read -p  "Enter password for Chef Admin Account ($CHEF_ADMIN_ID): " $CHEF_ADMIN_PASSWORD
wget https://github.com/mdbomba/tools/blob/main/install.sh
chmod +x install.sh
sudo ./install.sh -P chef-automate

