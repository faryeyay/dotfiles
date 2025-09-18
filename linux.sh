#!/bin/bash

. ./util.sh

# If we are running as root, we do not need to use sudo
sudo_cmd=""
if [ "$(id -u)" != "0" ]; then
    sudo_cmd="sudo"
fi

pkg_manager

## Update timezone
${sudo_cmd} ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
${sudo_cmd} dpkg-reconfigure --frontend noninteractive tzdata