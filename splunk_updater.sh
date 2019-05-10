#!/bin/bash

#-------------------------------------------#
#            Splunk auto-updater            #
#             -Daniel Gallagher             #
#-------------------------------------------#

# Lookup current Splunk version
long_version=$(curl -s https://www.splunk.com/en_us/download/splunk-enterprise.html | egrep -o 'splunk-[0-9]+\.[0-9]+\.[0-9]+-[0-9a-f]{8,12}' | head -1)
version=$(echo $long_version | cut -d - -f 2)
build=$(echo $long_version | cut -d - -f 3)

# Static variables (adjust to your environment)
product="splunk" # values can be : splunk , splunkforwarder
arch="amd64" # values can be : x86_64 (redhat), amd64 (ubuntu)
pkg="deb" # Values can be : rpm (redhat), deb (ubuntu)

# Generate filename
filename="${product}-${version}-${build}-${os}-2.6-${arch}.${pkg}"
md5File="${filename}.md5"


function usage
{
  echo -e "\e[96m[+] Optional switch to install (will use sudo): -i \e[0m"
  exit
}


function get_update
{
  echo -e "\e[35m[*] Current Version: $long_version \e[0m"
  echo -e "\e[94m[+] Downloading: $md5File \e[0m"

  wget "https://download.splunk.com/products/splunk/releases/${version}/linux/${md5File}" -q --show-progress

  echo -e "\e[94m[+] Downloading: $filename \e[0m"

  wget "https://download.splunk.com/products/splunk/releases/${version}/linux/${filename}" -q --show-progress

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
  echo -e "\e[94m[+] Installing: $filename \e[0m"

  if [ "$pkg" = "deb" ]; then
    sudo dpkg -i $filename >>update.log
  fi

  if [ "$pkg" = "rpm" ]; then
    sudo rpm -Uvh $filename >>update.log
  fi

  echo -e "\e[94m[+] Restarting Splunk services \e[0m"
  sudo su - splunk -c '/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt' >>update.log

  echo -e "\e[94m[-] Cleaning up: $filename \e[0m"
  rm -f ./$filename

  echo -e "\e[94m[-] Cleaning up: $md5File \e[0m"
  rm -f ./$md5File

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
