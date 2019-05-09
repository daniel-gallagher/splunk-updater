# splunk-updater
Automate downloading the latest Splunk installer

Usage: ./splunk_updater.sh _product_ _version_ _hash_ _arch_ _pkg_

* [1] Product -> Values can be: splunk, splunkforwarder
* [2] Version -> Example: 7.2.6
* [3] Hash -> Example: c0bf0f679ce9
* [4] Arch -> Values can be: x86_64 (redhat), amd64 (ubuntu)
* [5] Pkg -> Values can be: rpm, deb

# Current defaults:

* Product: splunk
* Version: 7.2.6
* Hash: c0bf0f679ce9
* Arch: amd64
* Pkg: deb
