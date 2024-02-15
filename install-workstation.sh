# TEST TO SEE IF CHEF SERVER ALREADY INSTALLED

echo 'current_dir = File.dirname(__FILE__)'                                                  > configrb
echo 'log_level                :info'                                                       >> configrb
echo 'log_location             STDOUT'                                                      >> configrb
echo 'node_name                "'"$CHEF_ADMIN_ID"'                                          >> configrb
echo 'client_key               "#{current_dir}/'"$CHEF_ADMIN_ID"                            >> configrb
echo 'chef_server_url          "https://'"$CHEF_SERVER_NAME/organizations/$CHEF_ORG"'"'     >> configrb
echo 'cookbook_path            ["#{current_dir}/../cookbooks"]'                             >> configrb



if test `command -v chef-server-ctl` = '/usr/bin/chef-server-ctl'
 then
   echo "CHEF SERVER ALREADY INSTALLED - SKIPPING INSTALL"
 else
   mkdir ~/.chef
   read -p "Enter password for chef admin accout ($CHEF_ADMIN_ID): " CHEF_ADMIN_PASSWORD
   wget https://github.com/mdbomba/tools/blob/main/install.sh
   chmod +x install.sh
   sudo ./install.sh -P chef-workstation
   chef generate repo $CHEF_REPO

   
fi

# Need to copy configrb to .chef

# Need to build .chef/credentials


