version='20240308'
# This script installs chef workstation on either Ubunto or Redhat Linux
echo 'Step1 script updates the .bashrc file and installs dependent applications.'
echo "Version = $version"
echo ''
###################################################
# ENSURE SCRIPT WAS STARTED NOT STARTED USING SUDO
###################################################
if test "x$EUID" = "x"; then
  echo ''; echo 'This script should be started using user level (not sudo) rights. Script is terminating.'
  echo ''
  exit
fi
#
cd ~
. ./.bashrc
#
grep -v -i "chef" .bashrc > bashrc; cp bashrc .bashrc
#
#####################################
# START LOAD PARAMS SECTION
#####################################
CHEF_LICENSE='accept'
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
CHEF_WORKSTATION_NAME='chef-workstation'
CHEF_WORKSTATION_IP='192.168.56.1'
CHEF_SERVER_NAME='chef-server'
CHEF_SERVER_IP='192.168.56.5'
CHEF_NODE1_NAME='node1'
CHEF_NODE1_IP='192.168.56.6'
CHEF_NODE2_NAME='node2'
CHEF_NODE2_IP='192.168.56.7'
#####################################
# END LOAD PARAMS SECTION
#####################################

################################
# START export PARAMS
################################
export CHEF_LICENSE
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

echo CHEF_LICENSE="'accept'" | tee -a .bashrc
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

echo 'export CHEF_LICENSE' | tee -a .bashrc
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

echo ''
echo '######################################################'
echo '#                                                    #'
echo '#   Please sign out, sign in, and run step2 script   #'
echo '#                                                    #'
echo '######################################################'
