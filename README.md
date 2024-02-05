This repo will hold work related to automating the installation of Chef Workstation and Chef Server. 

Chef Server installs will use the Chef Automate process (download chef-automate installer and use the -products 
command line options to include Chef Infra Server, Chef Habitat Builder and Chef Automate Server. 

Install scripts are written to use the apt installer on Ubuntu and tested on Ubuntu 22 and Mint 21.

There are many methods to install chef, the scripts in this repo will use an overall process of creating 
environmental variables (appended to ~/.bashrc) that can then we used in various config files that chef 
normally reads (e.g. config.toml). They will aslo be used in the chef-install-workstation.sh and chef-install-automate.sh 
scripts. 

It is recommended you create or have available a github account before running the install scripts. 

knife bootstrap chef-node1 -N 'chef-node1' -u 'mike' --run-list 'chef-demo' --sudo -P 'Mdb121600' --ssh-user 'mike'

it is recommended to use certificate based auth with ssh
to do this first
$ ssh-keygen -t rsa

this will place 2 files in the ~/.ssh folder. copy the id_rsa.pub to authorized_users and then you can use these keys to ssh without a password. 

To use exact same keys in all nodes, copy both id_rsa files to ~/.ssh on all nodes and copy id_rsa.pub to the local authorized_users file 
(replacing the contents of this file with the contents of id_rsa.pub.)

when working with machines that do not have public or trusted certs, you will need to ssh to each node and accept the cert issue (ssh mike@192.168.56.5)

If you have a problem bootstraping a node, make sure the chef server (automate server) does not have a client entry for the node. If there is a client entry and no node entry, delete the client entry and try to bootstrap again. 

 
