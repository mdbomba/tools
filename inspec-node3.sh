PROFILE='cis-rockylinux8-level1-server-1.0.0-1.tar.gz'
TARGET='node3'
USER='chef'
USERPASS='devsecops'
OUTFILE="./$TARGET_$PROFILE.htm"
clear
echo "Compliance scan of $TARGET using profile $PROFILE with output to $OUTFILE"
echo ''
echo inspec exec "$PROFILE" -t "ssh://$USER@$TARGET" --password "$USERPASS" --reporter cli html2:"$OUTFILE"
inspec exec "$PROFILE" -t "ssh://$USER@$TARGET" --password "$USERPASS" --reporter cli html2:"$OUTFILE"
echo ''
echo 'Displaying result as htm file. Press any key to continue. '
echo ''
read -p ''
firefox "$OUTFILE"


