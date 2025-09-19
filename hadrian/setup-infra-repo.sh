#!/bin/bash

. ./util.sh

WORKSPACE_DIR="/workspaces/$DEVPOD_WORKSPACE_ID/infra"

info "Setting up the infra repository"
pushd $WORKSPACE_DIR

info "Copy vault.envrc"
mv vault.envrc $USER.envrc

info "Install direnv via brew"
brew install direnv

eval "$(direnv hook zsh)"
direnv allow
direnv reload

# Update my kubeconfig file
[ -f toolbox/eks/get_kubeconfig_all ] && bash toolbox/eks/get_kubeconfig_all || warn "toolbox/eks/get_kubeconfig_all was not found. Maybe it moved?"