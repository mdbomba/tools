version='20240308'
# This script installs chef workstation on either Ubunto or Redhat Linux
echo 'Step3 script installs chef workstation.'
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
# SOURCES FOR rpm and deb PACKAGES FOR CHEF WORKSTATION
DEB_URL='https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb'
RPM_URL='https://packages.chef.io/files/stable/chef-workstation/21.10.640/el/8/chef-workstation-21.10.640-1.el8.x86_64.rpm'
#
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

