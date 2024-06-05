# FUNCTION TO GET A FILE FROM A WEB BASED FILE SHARE
# USAGE:  get-file -p platform -f file -l http://files
platform=''          # Choices are el8, rocky8, deb
file=''              # Choices are chef-client, chef-server, chef-workstation, chef-automate
download_url=''      # Example (http://files)

get-file () {
  file=$1
  platform=$2
  url=$3
  rm -rf index.tx*

    while ! [[ "$file" =~ ^(chef-client|chef-workstation|chef-automate|chef-server)$ ]]
    do
      read -p "Enter Chef Product (chef-client|chef-workstation|chef-automate|chef-server): " file
    done

    while ! [[ "$platform" =~ ^(el8|rocky8|deb)$ ]]
    do
      read -p "Enter platform type (el8|rocky8|deb)$ " platform
    done

    while ! `wget "$url/index.txt"`
    do
      echo "Usage get-file [chef-client|chef-workstation|chef-server|chef-automate] [el8|rocky8|deb] [download_url]"
      read -p "Enter download link (http://files): " url
    done

    if [ $platform = 'rocky8' ]; then
      if ! `grep $file index.txt | grep $platform > /dev/null`; then platform=el8; fi
    fi

    filename=`grep $file index.txt | grep $platform`

    echo "$filename"

    wget "$url/$filename"

    rm -rf index.txt

}
