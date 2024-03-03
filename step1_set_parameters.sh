version='20240229'
#
# This script loads environmental variables related to chef

#####################################
# START LOAD PARAMS SECTION
#####################################
CHEF_HOME_DIR='/home/chef'
CHEF_GIT_USER='mdbomba'
CHEF_GIT_USER_EMAIL='mbomba@kemptechnologies.com'
CHEF_REPO='chef-repo'
CHEF_ORG='chef'
CHEF_ORG_LONG='Chef Management Organization'
CHEF_DOMAINNAME='localhost'
CHEF_ADMIN_ID='chef'
CHEF_ADMIN_FIRST='Chef'
CHEF_ADMIN_LAST='Admin'
CHEF_ADMIN_EMAIL='chef.admin@kemptech.biz'
CHEF_WORKSTATION_NAME='BOMBA-GH2NL13'
CHEF_WORKSTATION_IP='10.0.1.1'
CHEF_SERVER_NAME='chef-server'
CHEF_SERVER_IP='10.0.1.7'
CHEF_NODE1_NAME='chef-node1'
CHEF_NODE1_IP='10.0.1.8'
CHEF_NODE2_NAME='chef-node2'
CHEF_NODE2_IP='10.0.1.9'

#####################################
# END LOAD PARAMS SECTION
#####################################

################################
# START export PARAMS
################################
export CHEF_HOME_DIR
export CHEF_GIT_USER
export CHEF_GIT_USER_EMAIL
export CHEF_REPO
export CHEF_ORG
export CHEF_ORG_LONG
export CHEF_DOMAINNAME
export CHEF_ADMIN_ID
export CHEF_ADMIN_FIRST
export CHEF_ADMIN_LAST
export CHEF_ADMIN_EMAIL
export CHEF_WORKSTATION_NAME
export CHEF_WORKSTATION_IP
export CHEF_SERVER_NAME
export CHEF_SERVER_IP
export CHEF_NODE1_NAME
export CHEF_NODE1_IP
export CHEF_NODE2_NAME
export CHEF_NODE2_IP
################################
# END export PARAMS
################################

cd "$CHEF_HOME_DIR"
grep -v -i "chef" .bashrc > bashrc
cp bashrc .bashrc

echo CHEF_HOME_DIR="'$CHEF_HOME_DIR'" | tee -a .bashrc
echo CHEF_GIT_USER="'$CHEF_GIT_USER'" | tee -a .bashrc
echo CHEF_GIT_USER_EMAIL="'$CHEF_GIT_USER_EMAIL'" | tee -a .bashrc
echo CHEF_REPO="'$CHEF_REPO'" | tee -a .bashrc
echo CHEF_ORG="'$CHEF_ORG'" | tee -a .bashrc
echo CHEF_ORG_LONG="'$CHEF_ORG_LONG'" | tee -a .bashrc
echo CHEF_DOMAINNAME="'$CHEF_DOMAINNAME'" | tee -a .bashrc
echo CHEF_ADMIN_ID="'$CHEF_ADMIN_ID'" | tee -a .bashrc
echo CHEF_ADMIN_FIRST="'$CHEF_ADMIN_FIRST'" | tee -a .bashrc
echo CHEF_ADMIN_LAST="'$CHEF_ADMIN_LAST'" | tee -a .bashrc
echo CHEF_ADMIN_EMAIL="'$CHEF_ADMIN_EMAIL'" | tee -a .bashrc
echo CHEF_WORKSTATION_NAME="'$CHEF_WORKSTATION_NAME'" | tee -a .bashrc
echo CHEF_WORKSTATION_IP="'$CHEF_WORKSTATION_IP'" | tee -a .bashrc
echo CHEF_SERVER_NAME="'$CHEF_SERVER_NAME'" | tee -a .bashrc
echo CHEF_SERVER_IP="'$CHEF_SERVER_IP'" | tee -a .bashrc
echo CHEF_NODE1_NAME="'$CHEF_NODE1_NAME'" | tee -a .bashrc
echo CHEF_NODE1_IP="'$CHEF_NODE1_IP'" | tee -a .bashrc
echo CHEF_NODE2_NAME="'$CHEF_NODE2_NAME'" | tee -a .bashrc
echo CHEF_NODE2_IP="'$CHEF_NODE2_IP'" | tee -a .bashrc

echo 'export CHEF_HOME_DIR' | tee -a .bashrc
echo 'export CHEF_GIT_USER' | tee -a .bashrc
echo 'export CHEF_GIT_USER_EMAIL' | tee -a .bashrc
echo 'export CHEF_REPO' | tee -a .bashrc
echo 'export CHEF_ORG' | tee -a .bashrc
echo 'export CHEF_ORG_LONG' | tee -a .bashrc
echo 'export CHEF_DOMAINNAME' | tee -a .bashrc
echo 'export CHEF_ADMIN_ID' | tee -a .bashrc
echo 'export CHEF_ADMIN_FIRST' | tee -a .bashrc
echo 'export CHEF_ADMIN_LAST' | tee -a .bashrc
echo 'export CHEF_ADMIN_EMAIL' | tee -a .bashrc
echo 'export CHEF_WORKSTATION_NAME' | tee -a .bashrc
echo 'export CHEF_WORKSTATION_IP' | tee -a .bashrc
echo 'export CHEF_SERVER_NAME' | tee -a .bashrc
echo 'export CHEF_SERVER_IP' | tee -a .bashrc
echo 'export CHEF_NODE1_NAME' | tee -a .bashrc
echo 'export CHEF_NODE1_IP' | tee -a .bashrc
echo 'export CHEF_NODE2_NAME' | tee -a .bashrc
echo 'export CHEF_NODE2_IP' | tee -a .bashrc

# BELOW SETTING TURNS SYNTAX COLOR MODE ON OR OFF FOR vi/vim
echo 'set syntax off' | sudo tee -a /etc/vim/vimrc >>/dev/null


echo ''
echo '######################################################'
echo '#                                                    #'
echo '#   Please sign out, sign in, and run step2 script   #'
echo '#                                                    #'
echo '######################################################'