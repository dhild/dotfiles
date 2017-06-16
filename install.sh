#!/bin/sh
set -euf -o pipefail

mkdir -p ~/.vim/bundle
git clone git@github.com:VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

for i in .atom .gitconfig .vimrc .zshrc bin; do
  ln -s ~/dotfiles/$i ~/$i
done

apm install --packages-file ~/.atom/packages.list

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

for i in $(cat brew.list); do
  brew install $i
done
