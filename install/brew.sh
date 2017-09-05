#!/bin/bash
set -euf -o pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Mac OS not detected, exiting brew install script"
  exit
fi

if [[ -x $(command -v brew) ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
  brew upgrade
fi

brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

apps=(
  awscli
  gdbm
  go
  hadolint
  jq
  kubernetes-cli
  libpng
  oniguruma
  openssl
  openssl@1.1
  packer
  pcre
  python
  readline
  sqlite
  terraform
  tree
  vault
  wget
  zsh
  zsh-completions
)

for i in "${apps[@]}"; do
  brew install $i
done
