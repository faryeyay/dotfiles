#!/bin/bash

. ./util.sh

info "Setting up Farye's Dotfile"

OSFAM=`get_os_type`
info "Using $OSFAM"

if [ "${OSFAM}" == "Linux" ]; then
	bash linux.sh
fi

## Forgit - This tool is designed to help you use git more efficiently. It's lightweight and easy to use.
git clone https://github.com/wfxr/forgit.git ${HOME}/bin/forgit

info "Looking for the AWS configuration directory"
if [ ! -d $HOME/.aws ]; then
	mkdir $HOME/.aws
fi

# Place the current company where you are working at here
bash ./hadrian/hadrian.sh

info "All done. Have fun!"

