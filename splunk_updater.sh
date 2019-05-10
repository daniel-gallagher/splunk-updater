#!/bin/bash

#-------------------------------------------#
#            Splunk auto-updater            #
#             -Daniel Gallagher             #
#-------------------------------------------#

# Lookup current Splunk version
long_version=$(curl -s https://www.splunk.com/en_us/download/splunk-enterprise.html | egrep -o 'splunk-[0-9]+\.[0-9]+\.[0-9]+-[0-9a-f]{8,12}' | head -1)
version=$(echo $long_version | cut -d - -f 2)
hash=$(echo $long_version | cut -d - -f 3)

# Static variables (adjust to your environment)
os="linux" # Linux only for now
product="splunk" # values can be : splunk , splunkforwarder
arch="amd64" # values can be : x86_64 (redhat), amd64 (ubuntu)
pkg="deb" # Values can be : rpm (redhat), deb (ubuntu)

# Generate filename
filename="${product}-${version}-${hash}-${os}-2.6-${arch}.${pkg}"
md5File="${filename}.md5"


function usage
{
  echo -e "\e[96m[+] Optional switch to install (will use sudo): -i \e[0m"
  exit
}


function get_update
{
  echo -e "\e[35m[*] Current Version: $long_version \e[0m"
  echo -e "\e[90m[+] Downloading: $md5File \e[0m"

  wget "https://download.splunk.com/products/splunk/releases/${version}/${os}/${md5File}" -q --show-progress

  echo -e "\e[90m[+] Downloading: $filename \e[0m"

  wget "https://download.splunk.com/products/splunk/releases/${version}/${os}/${filename}" -q --show-progress

  echo -e "\e[94m[+] Checking md5sum of: $filename \e[0m"

  if md5sum -c $md5File | grep -q -w "OK"; then
    echo -e "\e[32m[+] File looks good. \e[0m"
  else
    echo -e "\e[31m[!] File appears to be corrupt! \e[0m"
    exit 1
  fi

  echo -e "\e[93m[+] Download complete! \e[0m"
}


function install_update
{
  echo -e "\e[90m[+] Installing: $filename \e[0m"

  sudo dpkg -i $filename
  sudo su - splunk -c '/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt'

  echo -e "\e[93m[+] Upgrade complete! \e[0m"
}


if [ "$1" = "-h" ]; then
  usage
fi

if [ "$1" = "-i" ]; then
  get_update
  install_update
else
  get_update
fi

exit 0
