# Version 20240202
#
version='20240202'
#
# This script updates .bashrc and /etc/hosts prior to chef installs
#
echo 'This script will load environmental variables related to the insallation and operations of Chef'
echo "Version = $version"
echo ''
if [ ! -d ~/temp ]; then mkdir ~/temp ; fi ; cd ~/temp

CHEF_WORKSTATION_PATH='/opt/chef-workstation/bin:/home/mike/.chefdk/gem/ruby/3.0.0/bin:/opt/chef-workstation/embedded/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/chef-workstation/gitbin'

# CREATE CHEF PARAMETERS FILE ~/.chefparamsrc
echo '# FOLLOWING IS ADDED BY CHEF INSTALL SCRITS'  > ~/.chefparams
echo '# BELOW GLOBAL VARIABLES ARE CALLED BY OTHER CHEF SCRIPTS' >> ~/.chefparams
echo "CHEF_ADMIN_ID='mike'"                         >> ~/.chefparams
echo "export CHEF_ADMIN_ID"                         >> ~/.chefparams
echo "CHEF_ADMIN_FIRST='Mike'"                      >> ~/.chefparams
echo "export CHEF_ADMIN_FIRST"                      >> ~/.chefparams
echo "CHEF_ADMIN_LAST='Bomba'"                      >> ~/.chefparams
echo "export CHEF_ADMIN_LAST"                       >> ~/.chefparams
echo "CHEF_ADMIN_EMAIL='mike.bomba@progress.com'"   >> ~/.chefparams
echo "export CHEF_ADMIN_EMAIL"                      >> ~/.chefparams
echo "CHEF_DOMAINNAME='localhost'"                  >> ~/.chefparams
echo "export CHEF_DOMAINNAME"                       >> ~/.chefparams
echo "CHEF_WORKSTATION_NAME='mike-mint'"            >> ~/.chefparams
echo "export CHEF_WORKSTATION_NAME"                 >> ~/.chefparams
echo "CHEF_WORKSTATION_IP='192.168.56.1'"           >> ~/.chefparams
echo "export CHEF_WORKSTATION_IP"                   >> ~/.chefparams
echo "CHEF_SERVER_NAME='chef-automate'"             >> ~/.chefparams
echo "export CHEF_SERVER_NAME"                      >> ~/.chefparams
echo "CHEF_SERVER_IP='192.168.56.5'"                >> ~/.chefparams
echo "export CHEF_SERVER_IP"                        >> ~/.chefparams
echo "CHEF_NODE1_NAME='chef-node1'"                 >> ~/.chefparams
echo "export CHEF_NODE1_NAME"                       >> ~/.chefparams
echo "CHEF_NODE1_IP='192.168.56.6'"                 >> ~/.chefparams
echo "export CHEF_NODE1_IP"                         >> ~/.chefparams
echo "CHEF_NODE2_NAME='chef-node2'"                 >> ~/.chefparams
echo "export CHEF_NODE2_NAME"                       >> ~/.chefparams
echo "CHEF_NODE2_IP='192.168.56.7'"                 >> ~/.chefparams
echo "export CHEF_NODE2_IP"                         >> ~/.chefparams
echo "CHEF_ORG='chef-demo'"                         >> ~/.chefparams
echo "export CHEF_ORG"                              >> ~/.chefparams
echo "CHEF_ORG_LONG='Chef Demo Organization'"       >> ~/.chefparams
echo "export CHEF_ORG_LONG"                         >> ~/.chefparams
echo '# URL TO DOWNLOAD Chef Workstation deb file'  >> ~/.chefparams
echo "URL_WORKSTATION='https://packages.chef.io/files/stable/chef-workstation/23.12.1055/ubuntu/22.04/chef-workstation_23.12.1055-1_amd64.deb'"    >> ~/.chefparams
echo "export URL_WORKSTATION"                       >> ~/.chefparams
echo '# URL TO DOWNLOAD Chef Server deb file'       >> ~/.chefparams
echo "URL_SERVER='https://packages.chef.io/files/stable/chef-server-core/15.9.20/ubuntu/22.04/chef-server-core_15.9.20-1_amd64.deb'"   >> ~/.chefparams
echo "export URL_SERVER"                            >> ~/.chefparams
echo "# URL TO DOWNLOAD Chef Client deb file"       >> ~/.chefparams
echo "URL_CLIENT='https://packages.chef.io/files/stable/chef/18.4.2/ubuntu/22.04/chef_18.4.2-1_amd64.deb'"  >> ~/.chefparams
echo "export URL_CLIENT"                            >> ~/.chefparams
echo "# URL TO DOWNLOAD Chef Automate installer executable"     >> ~/.chefparams
echo "URL_AUTOMATE='https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip'"  >> ~/.chefparams
echo "export URL_AUTOMATE"                          >> ~/.chefparams
echo '# URL TO DOWNLOAD Chef install.sh'            >> ~/.chefparams
echo "URL_INSTALL='https://omnitruck.chef.io/install.sh'"   >> ~/.chefparams
echo "export URL_INSTALL"                           >> ~/.chefparams
. ~/.chefparams

# Add PATH for CHEF_WORKSTATION ONLY 
HN=`hostname -s`
if [ "$HN" = "$CHEF_WORKSTATION_NAME" ]; then 
  echo "# BELOW WILL ADJUST PATH for CHEF"          >> ~/.chefparams
  echo "PATH=$CHEF_WORKSTATION_PATH"                >> ~/.chefparams
  echo "export PATH"                                >> ~/.chefparams
fi

grep -v -i 'chefparams' ~/.bashrc > ./bashrc ; echo ". ~/.chefparams" >> ./bashrc ; cp ./bashrc ~/.bashrc ; rm ./bashrc

# LOAD PARAMETERS
. ~/.chefparams

# UPDATE HOSTS FILE
grep -i -v "$CHEF_WORKSTATION_IP" /etc/hosts | grep -i -v "$CHEF_SERVER_IP" | grep -i -v "$CHEF_NODE1_IP" | grep -i -v "$CHEF_NODE2_IP" | grep -i -v "# CHEF INFO" > ./hosts
cat >> "./hosts" << EOF
# CHEF INFO
$CHEF_WORKSTATION_IP  $CHEF_WORKSTATION_NAME  $CHEF_WORKSTATION_NAME.$CHEF_DOMAINNAME
$CHEF_SERVER_IP  $CHEF_SERVER_NAME  $CHEF_SERVER_NAME.$CHEF_DOMAINNAME
$CHEF_NODE1_IP  $CHEF_NODE1_NAME  $CHEF_NODE1_NAME.$CHEF_DOMAINNAME
$CHEF_NODE2_IP  $CHEF_NODE2_NAME  $CHEF_NODE2_NAME.$CHEF_DOMAINNAME
EOF
echo "COPY ./hosts to /etc/hosts"
sudo cp ./hosts /etc/hosts ; rm ./hosts

if [ "$HN" = "$CHEF_WORKSTATION_NAME" ]; then echo "FINISHING PREP FOR CHEF WORKSTATION ($CHEF_WORKSTATION_NAME)" ; cd ~ ; exit; fi

echo "ENABLE SSH LOGIN USING PUBLIC KEY"
# DOWNLOAD PUB SSH KEY
cd ~/.ssh
if [ ! -f id_rsa.pub ]; then 
  scp mike@mike-mint:/home/mike/.ssh/id_rsa.* .
  cp id_rsa.pub authorized_keys
fi
if [ "$HN" = "$CHEF_SERVER_NAME" ]; then echo "FINISHING PREP FOR CHEF SERVER ($CHEF_SERVER_NAME)" ; cd ~ ; exit; fi
if [ "$HN" = "$CHEF_NODE1_NAME" ]; then echo "FINISHING PREP FOR CHEF NODE ($CHEF_NODE1_NAME)" ; cd ~ ; exit; fi
if [ "$HN" = "$CHEF_NODE2_NAME" ]; then echo "FINISHING PREP FOR CHEF NODE ($CHEF_NODE2_NAME)" ; cd ~ ; exit; fi



