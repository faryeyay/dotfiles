#!/bin/bash

. ./util.sh

info "Initializing git-crypt"
# Initialize git-crypt 
git-crypt init || warn "Git Crypt has already been initialized."

# Grab the keys and add them to git-crypt
for key in `gpg --list-keys --with-colons | awk -F':' '/^fpr:/ {print $10}'`; do git-crypt add-gpg-user $key; done

# Install Terraform
info "Installing Terraform"
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Install the Silver Searcher
info "Installling Silver Searcher"
brew install the_silver_searcher

info "Running the secrets BASH script"
bash hadrian/hadrian.secrets