# splunk-updater
Automate downloading the latest Splunk installer

This script will find the most recent version, download it, and verify the md5sum of the installer. THe optional '-i' switch will install the update over top of the existing installation and then will restart Splunk services after accepting the license agreement.


*currently only working for Ubuntu/Debian environments*

# Optional Arguments:

* -i Install and restart splunk services

# Current defaults:

* Product: splunk
* Arch: amd64
* Pkg: deb
