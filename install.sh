#!/bin/sh

. ./util.sh

info "Setting up Codespaces"

OSFAM=`get_os_type`
info "Using $OSFAM"

pkg_manager

if [ $PKG_MGR == "apt" ]; then
	# Install prereqs
  ###
	wget -qO - 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1> /dev/null
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
	sudo apt update

	PACKAGES="fzf tmux just mycli pgcli iredis jq ripgrep"
	sudo $PKG_MGR install $PACKAGES -y
elif [ $PKG_MGR == "apk" ]; then 
	PACKAGES="fzf tmux just"
	sudo $PKG_MGR add $PACKAGES
fi

## Update timezone
sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
sudo dpkg-reconfigure --frontend noninteractive tzdata


## Forgit - This tool is designed to help you use git more efficiently. It's lightweight and easy to use.
git clone https://github.com/wfxr/forgit.git ${HOME}/bin/forgit

## Install granted - https://docs.commonfate.io/granted/getting-started/
curl -OL releases.commonfate.io/granted/v0.11.1/granted_0.11.1_linux_x86_64.tar.gz
sudo tar -zxvf ./granted_0.11.1_linux_x86_64.tar.gz -C /usr/local/bin/
rm granted_0.11.1_linux_x86_64.tar.gz

## k9s - Kubernetes CLI To Manage Your Clusters In Style!
curl -sS https://webinstall.dev/k9s | bash

# Cleanup
if [ $PKG_MGR == "apt" ]; then
	sudo $PKG_MGR -y autoremove
elif [ $PKG_MGR == "apk" ]; then
	sudo $PKG_MGR cache clean
fi

info "All done. Have fun!"
