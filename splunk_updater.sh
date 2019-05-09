#!/bin/bash

#-------------------------------------------#
#       Splunk update auto-downloader       #
#             -Daniel Gallagher             #
#-------------------------------------------#

# Initialze variables
os="linux" # Set static to "linux" for now
product=${1:-splunk} # values can be : splunk , splunkforwarder
version=${2:-7.2.6} # Splunk product version
hash=${3:-c0bf0f679ce9} # Hash is specific to version
arch=${4:-amd64} # values should be : x86_64 (redhat), amd64 (ubuntu)
pkg=${5:-deb} # Values should be : rpm, deb
filename="${product}-${version}-${hash}-${os}-2.6-${arch}.${pkg}"
md5File="${filename}.md5"

function usage
{
  echo -e "\e[96m[+] Usage: $0 <product> <version> <hash> <arch> <pkg> \e[0m"
  echo -e "\e[96m[+] --- Arguments --- \e[0m"
  echo -e "\e[96m[+] Product -> Values can be: splunk, splunkforwarder \e[0m" #option 1
  echo -e "\e[96m[+] Version -> Example: 7.2.6 \e[0m" #option 2
  echo -e "\e[96m[+] Hash -> Example: c0bf0f679ce9 \e[0m" #option 3
  echo -e "\e[96m[+] Arch -> Values can be: x86_64 (redhat), amd64 (ubuntu) \e[0m" #option 4
  echo -e "\e[96m[+] Pkg -> Values can be: rpm, deb \e[0m" #option 5
  exit
}


function get_update
{
  echo -e "\e[35m[+] Downloading: $md5File \e[0m"

  wget "https://download.splunk.com/products/splunk/releases/${version}/${os}/${md5File}" -q --show-progress

  echo -e "\e[35m[+] Downloading: $filename \e[0m"

  wget "https://download.splunk.com/products/splunk/releases/${version}/${os}/${filename}" -q --show-progress

  echo -e "\e[94m[+] Checking md5sum of: $filename \e[0m"

  if md5sum -c $md5File | grep -q -w "OK"; then
    echo -e "\e[32m[+] File looks good. \e[0m"
  else
    echo -e "\e[31m[+] File appears to be corrupt! \e[0m"
    exit 1
  fi
}


if [ "$1" = "-h" ]; then
  usage
fi

get_update

echo -e "\e[93m[+] Finished! \e[0m"

exit 0
