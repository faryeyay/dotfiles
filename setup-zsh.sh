#!/bin/bash

. ./util.sh

info "Copy .zshrc over to the home directory"
cp .zshrc $HOME/

# clone zsh-autocomplete and set it up
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
mkdir -p $HOME/.bin
mv zsh-autocomplete $HOME/.bin/

echo 'source $HOME/.bin/zsh-autocomplete/zsh-autocomplete.plugin.zsh' >> $HOME/.zshrc

# Specifically for UBuntu
echo 'skip_global_compinit=1' >> $HOME/.zshenv