#!/bin/bash

echo "selinux status is `/usr/sbin/getenforce`"

if ! test -d $HOME/.ssh; then mkdir .ssh; fi
if ! test -f $HOME/.ssh/*.pub; then ssh-keygen -P '' -f $HOME/.ssh/id_rsa; fi 
if ! test -f $HOME/.ssh/authorized_keys; then cat *.pub >> authorized_keys; fi
if ! test -f $HOME/.ssh/known_hosts; then touch $HOME/.ssh/known_hosts; fi
if [ "$EUID" = "0" ]; then chown root:root $HOME/.ssh/*; else echo "chown $USER:$USER $HOME/.ssh/*"; fi
echo "chmod 400 $HOME/.ssh/*"
chmod 400 $HOME/.ssh/*
echo "chmod 600 $HOME/.ssh/authorized_keys"
chmod 400 $HOME/.ssh/authorized_keys
echo "chmod 644 $HOME/.ssh/*.pub"
chmod 400 $HOME/.ssh/*.pub
echo "chmod 644 $HOME/.ssh/known_hosts*"
chmod 400 $HOME/.ssh/known_hosts*
echo "chcon -R unconfined_u:object_r:ssh_home_t:s0 .ssh"
chcon -R unconfined_u:object_r:ssh_home_t:s0 .ssh

if /usr/sbin/getenforce 2>/dev/null|grep -q "Enforcing\|Permissive"
then
  if [ "$EUID" = "0" ]
  then
    echo "chcon -R unconfined_u:object_r:home_root_t:s0 .ssh"
    chcon -R unconfined_u:object_r:home_root_t:s0 .ssh
  fi
fi
