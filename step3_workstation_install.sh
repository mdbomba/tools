version='20240229'
cd ~
. ~/.bashrc
#
# This script installs chef workstation on either Ubunto or Redhat Linux
#
echo 'This script installs chef workstation'
echo 'This script should be started using user level (not sudo) rights.'
echo "Version = $version"
echo ''

#########################################
# CHECK IF SCRIPT WAS STARTED USING SUDO
#########################################
if test "x$EUID" = "x"; then
  echo ''; echo 'Please do not run this script using sudo'
  echo ''
  exit
fi

# SOURCES FOR rpm and deb PACKAGES FOR CHEF WORKSTATION
DEB_URL='https://packages.chef.io/files/stable/chef-workstation/23.12.1055/ubuntu/22.04/chef-workstation_23.12.1055-1_amd64.deb'
RPM_URL='https://packages.chef.io/files/stable/chef-workstation/21.10.640/el/8/chef-workstation-21.10.640-1.el8.x86_64.rpm'

# DETERMINE LINUX VARIENT
if test -f /etc/lsb-release; then . /etc/lsb-release; fi
if [ "x$DISTRIB_ID" = "xUbuntu" ] || [ "x$DISTRIB_ID" = "xLinuxMint" ]; then URL="$DEB_URL"; else URL="$RPM_URL"; fi
PKG=`echo $URL | cut -d "/" -f 10`

######################################
# CREATE GIT REPO
#######################################
git config --global user.name "$CHEF_GIT_USER"
git config --global user.email "$CHEF_GIT_EMAIL"

########################################
# DOWNLOAD AND INSTALL CHEF WORKSTATION
########################################
wget -O "$PKG" "$URL"
if test "x$DISTRIB_ID" = "xUbuntu"
  then sudo dpkg -i "$PKG"
  else sudo yum localinstall "$PKG"
fi

echo "#############################################"
echo "# Please reboot server and run step4 script #"
echo '#############################################'


