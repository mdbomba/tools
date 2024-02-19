version=20240218
#
# Script to install chef workstation and do basic cnfig
#
cd ~
. .chefparams


if test `hostname -s` = $CHEF_WORKSTATION_NAME; then

  echo 'current_dir = File.dirname(__FILE__)'                                          	| tee new.config.rb
  echo 'log_level                :info'                                                   | tee -a new.config.rb
  echo 'log_location             STDOUT'                                                  | tee -a new.config.rb
  echo "node_name                '"$CHEF_ADMIN_ID"'"                                      | tee -a new.config.rb
  echo "client_key               '/home/""$CHEF_ADMIN_ID/.chef/$CHEF_ADMIN_ID.pem'"       | tee -a new.config.rb
  echo "chef_server_url          'https://""$CHEF_SERVER_NAME/organizations/$CHEF_ORG'"   | tee -a new.config.rb
  echo "cookbook_path            '/home/""$CHEF_ADMIN_ID/$CHEF_ORG/cookbooks'"            | tee -a new.config.rb

  echo '[default]'									| tee new.credentials
  echo "client_name     = '"$CHEF_ADMIN_ID"'"						| tee -a new.credentials
  echo "client_key      = '/home/"$CHEF_ADMIN_ID"/.chef/"$CHEF_ADMIN_ID".pem'"		| tee -a new.credentials
  echo "chef_server_url = 'https://"$CHEF_SERVER_NAME"/organizations/"$CHEF_ORG"'"	| tee -a new.credentials

  if test `command -v chef-server-ctl` = '/usr/bin/chef-server-ctl'; then
    echo "CHEF SERVER ALREADY INSTALLED - SKIPPING INSTALL"
  else
    mkdir ~/.chef
    read -p "Enter password for chef admin accout ($CHEF_ADMIN_ID): " CHEF_ADMIN_PASSWORD
    wget -O chef-workstation.deb https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
    sudo dpkg -i chef-workstation.deb
    chef generate repo $CHEF_REPO
    cp -f new.config.rb ~/.chef/config.rb
    cp -f new.credentials ~/.chef/credentials
  fi
fi


online=`ping -q -c1 $CHEF_SERVER_IP &>/dev/null && echo yes || echo no`; echo "Test to see if $CHEF_SERVER_NAME is online = $online"
if test "$online" = "yes" && `hostname -s` = "$CHEF_WORKSTATION_NAME"; then
  knife ssl fetch https://$CHEF_SERVER_NAME/organizations/$CHEF_ORG
  knife ssl fetch https://$CHEF_SERVER_NAME.$CHEF_DOMAINNAME/organizations/$CHEF_ORG
  knife ssl fetch https://$CHEF_SERVER_IP/organizations/$CHEF_ORG
fi
