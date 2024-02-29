version='20240228'
#
# This script loads environmental variables and dependent applications related to chef

# Ensure sudo password is entered early in scripe
#
echo "If Prompted for a password, enter password used for sudo commands"
sudo echo ""

#####################################
# START LOAD PARAMS SECTION
#####################################

export CHEF_GIT_USER='mdbomba'                            # Used to setup a git repo (if needed)
export CHEF_GIT_USER_EMAIL='mbomba@kemptechnologies.com'  # Used to setup a git repo (if needed)
export CHEF_REPO='chef-repo'                              # Collect Chef Organization short name (lowercase)
export CHEF_ORG='chef'                                    # Collect Chef Organization short name (lowercase)
export CHEF_ORG_LONG='Chef Management Organization'       # Collect Chef Organization long name
export CHEF_DOMAINNAME='localhost'                        # Collect domain name for Chef environment
export CHEF_ADMIN_ID='chef'                               # Collect Chef admin login id
export CHEF_ADMIN_FIRST='Chef'                            # Collect Chef admin first name
export CHEF_ADMIN_LAST='Admin'                            # Collect Chef admin last name
export CHEF_ADMIN_EMAIL='chef.admin@kemptech.biz'         # Collect Chef admin email
export CHEF_WORKSTATION_NAME='chef-workstation'           # Collect Chef Workstation name (lowercase)
export CHEF_WORKSTATION_IP='10.0.1.6'                     # Collect Chef Workstation IP address
export CHEF_SERVER_NAME='chef-server'                     # Collect Chef Server Name (lowercase)
export CHEF_SERVER_IP='10.0.1.7'                          # Collect Chef Server IP address
export CHEF_NODE1_NAME='chef-node1'                       # Collect Chef Node 1 Name
export CHEF_NODE1_IP='10.0.1.8'                           # Collect Chef Node 1 IP address
export CHEF_NODE2_NAME='chef-node1'                       # Collect Chef Node 1 Name
export CHEF_NODE2_IP='10.0.1.9'                           # Collect Chef Node 1 IP address
if test `command -v chef`; then 
  chef shell-init bash
fi

#####################################
# START UPDATE /etc/hosts SECTION
#####################################

# CLEAR OLD CHEF ENTRIES FROM /etc/hosts
grep -v -i "CHEF" "/etc/hosts" > ~/.hosts

# ADD NEW CHEF ENTRIES TO /etc/hosts
echo "# CHEF INFO
$CHEF_WORKSTATION_IP  $CHEF_WORKSTATION_NAME  $CHEF_WORKSTATION_NAME.$CHEF_DOMAINNAME  # CHEF WORKSTATION DATA
$CHEF_SERVER_IP  $CHEF_SERVER_NAME  $CHEF_SERVER_NAME.$CHEF_DOMAINNAME                 # CHEF SERVER DATA
$CHEF_NODE1_IP  $CHEF_NODE1_NAME  $CHEF_NODE1_NAME.$CHEF_DOMAINNAME                    # CHEF NODE1 DATA
$CHEF_NODE2_IP  $CHEF_NODE2_NAME  $CHEF_NODE2_NAME.$CHEF_DOMAINNAME                    # CHEF NODE2 DATA
" >> ~/.hosts

sudo cp -f ~/.hosts /etc/hosts
rm ~/.hosts

#####################################
# END UPDATE /etc/hosts SECTION
#####################################
