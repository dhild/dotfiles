#!/bin/bash
set -euf -o pipefail

# Install Vundle if it is not already present
mkdir -p ~/.vim/bundle
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
  git clone git@github.com:VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
  pushd ~/.vim/bundle/Vundle.vim > /dev/null
  git pull
  popd > /dev/null
fi
