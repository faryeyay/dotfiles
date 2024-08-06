#!/bin/sh

. ./util.sh

info "Setting up Codespaces"

OSFAM=`get_os_type`
info "Using $OSFAM"

# If we are running as root, we do not need to use sudo
sudo_cmd=""
if [ "$(id -u)" != "0" ]; then
    sudo_cmd="sudo"
fi

pkg_manager

if [ $PKG_MGR == "apt" ]; then
	# Install prereqs
  ###
	wget -qO - 'https://proget.makedeb.org/debian-feeds/prebuilt-mpr.pub' | gpg --dearmor | sudo tee /usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg 1> /dev/null
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/prebuilt-mpr-archive-keyring.gpg] https://proget.makedeb.org prebuilt-mpr $(lsb_release -cs)" | sudo tee /etc/apt/sources.list.d/prebuilt-mpr.list
	${sudo_cmd} apt update

	PACKAGES="fzf tmux just mycli pgcli redis jq ripgrep"
	${sudo_cmd} $PKG_MGR install $PACKAGES -y
elif [ $PKG_MGR == "apk" ]; then 
	PACKAGES="fzf tmux just"
	${sudo_cmd} $PKG_MGR add $PACKAGES
fi

## Update timezone
${sudo_cmd} ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
${sudo_cmd} dpkg-reconfigure --frontend noninteractive tzdata


## Forgit - This tool is designed to help you use git more efficiently. It's lightweight and easy to use.
git clone https://github.com/wfxr/forgit.git ${HOME}/bin/forgit

## Install granted - https://docs.commonfate.io/granted/getting-started/
# curl -OL releases.commonfate.io/granted/v0.11.1/granted_0.11.1_linux_x86_64.tar.gz
# sudo tar -zxvf ./granted_0.11.1_linux_x86_64.tar.gz -C /usr/local/bin/
# rm granted_0.11.1_linux_x86_64.tar.gz

## k9s - Kubernetes CLI To Manage Your Clusters In Style!
curl -sS https://webinstall.dev/k9s | bash

# Cleanup
if [ $PKG_MGR == "apt" ]; then
	${sudo_cmd} $PKG_MGR -y autoremove
elif [ $PKG_MGR == "apk" ]; then
	${sudo_cmd} $PKG_MGR cache clean
fi

if [ ! -d $HOME/.aws ]; then
	mkdir $HOME/.aws
fi
info "Copying AWS Shared Configuration File"
cp ./aws_config $HOME/.aws/config

# Adding environment variables to ~/.bashrc and ~/.zshrc
[[ -z `cat $HOME/.bashrc | grep "PULUMI_CONFIG_PASSPHRASE"` ]] && echo "export PULUMI_CONFIG_PASSPHRASE=${PULUMI_CONFIG_PASSPHRASE}" >> $HOME/.bashrc || info "PULUMI_CONFIG_PASSPHRASE is already in bashrc"
[[ -z `cat $HOME/.zshrc | grep "PULUMI_CONFIG_PASSPHRASE"` ]] && echo "export PULUMI_CONFIG_PASSPHRASE=${PULUMI_CONFIG_PASSPHRASE}" >> $HOME/.zshrc || info "PULUMI_CONFIG_PASSPHRASE is already in zshrc"

[[ -z `cat $HOME/.bashrc | grep "ANSIBLE_VAULT_IDENTITY_LIST"` ]] && echo "export ANSIBLE_VAULT_IDENTITY_LIST=dev@~/.ssh/ansible_vault_pass,ops@~/.ssh/ansible_vault_ops_pass" >> $HOME/.bashrc || info "ANSIBLE_VAULT_IDENTITY_LIST is already in bashrc"
[[ -z `cat $HOME/.zshrc | grep "ANSIBLE_VAULT_IDENTITY_LIST"` ]] && echo "export ANSIBLE_VAULT_IDENTITY_LIST=dev@~/.ssh/ansible_vault_pass,ops@~/.ssh/ansible_vault_ops_pass" >> $HOME/.zshrc || info "ANSIBLE_VAULT_IDENTITY_LIST is already in zshrc"

[[ -f /workspaces/ops/playbooks/ansible.cfg ]] && [[ -z `cat $HOME/.bashrc | grep "ANSIBLE_CONFIG"` ]] && echo "export ANSIBLE_CONFIG=/workspaces/ops/playbooks/ansible.cfg" >> $HOME/.bashrc || info "ANSIBLE_VAULT_IDENTITY_LIST is already in bashrc"
[[ -f /workspaces/ops/playbooks/ansible.cfg ]] && [[ -z `cat $HOME/.zshrc | grep "ANSIBLE_CONFIG"` ]] && echo "export ANSIBLE_CONFIG=/workspaces/ops/playbooks/ansible.cfg" >> $HOME/.zshrc || info "ANSIBLE_VAULT_IDENTITY_LIST is already in zshrc"

[[ ! -f ~/.ssh/ansible_vault_pass ]] && echo "${ANSIBLE_VAULT_PASS}" >> ~/.ssh/ansible_vault_pass
[[ ! -f ~/.ssh/ansible_vault_ops_pass ]] && echo "${ANSIBLE_VAULT_OPS_PASS}" >> ~/.ssh/ansible_vault_ops_pass

info "All done. Have fun!"

