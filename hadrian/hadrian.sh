#!/bin/bash

. ./util.sh

repositories=("infra" "voco" "charts")

info "Initializing git-crypt"
# Initialize git-crypt 
git-crypt init || warn "Git Crypt has already been initialized."

# Grab the keys and add them to git-crypt
for key in `gpg --list-keys --with-colons | awk -F':' '/^fpr:/ {print $10}'`; do git-crypt add-gpg-user $key; done

# Install OpenTofu
info "Installing OpenTofu"
brew install opentofu

# Install the Silver Searcher
info "Installling Silver Searcher"
brew install the_silver_searcher

info "Running the secrets BASH script"
[ -f hadrian/hadrian.secrets ] && bash hadrian/hadrian.secrets || warn "hadrian.secrets doesn't exist"

info "Change the directory to the DevPod workspace ID"
cd /workspaces/$DEVPOD_WORKSPACE_ID


for repo in "${repositories[@]}"; do
  info "Clone the $repo repository"
  git clone git@github.com:Hadrian-MTV/$repo
done

$PKG_MGR install -y xdg-utils