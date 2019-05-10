# splunk-updater
Automate downloading the latest Splunk installer

This script run without arguments will find the most recent version, download it, and verify the md5sum of the installer. Using the optional '-i' switch will install the update over top of the existing installation and then will restart Splunk services (as 'splunk' user) after accepting the license agreement.

Stdout and Stderr are redirected to a file called 'update.log'


*For now, to download and install .rpm files, you must set the Arch variable to 'x86_64' and Pkg to 'rpm'*

# Optional Arguments:

* -i Install and restart splunk services

# Current defaults:

* Product: splunk
* Arch: amd64
* Pkg: deb
