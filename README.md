# splunk-updater
Automate downloading the latest Splunk installer

Usage: ./splunk_updater.sh _product_ _arch_ _pkg_

# Optional Arguments:

* [1] Product -> Values can be: splunk, splunkforwarder
* [2] Arch -> Values can be: x86_64 (redhat), amd64 (ubuntu)
* [3] Pkg -> Values can be: rpm, deb

# Current defaults:

* Product: splunk
* Arch: amd64
* Pkg: deb
