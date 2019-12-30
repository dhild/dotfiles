#!/bin/sh
set -euf -o pipefail

gen_ssh_key() {
  KEY_PATH="$HOME/.ssh/id_ed25519"
  if [ -f "$KEY_PATH" ]; then
    echo "SSH key already generated, skipping..."
  else
    echo "Generating a ssh key, please use default name"
    ssh-keygen -t ed25519 -a 100
    echo "Adding ssh key to ssh-agent"
    ssh-add ~/.ssh/id_ed25519
    pbcopy < ~/.ssh/id_ed25519.pub
    echo "Pub key has been copied to the paste buffer. Please paste it into a new SSH key."
    open https://github.com/settings/keys
    read  -n 1 -p "Press enter to continue." resp
  fi
}

xcode_setup() {
  xcode-select -p 1>/dev/null
  if [ $? -gt 0 ]; then
    echo "Installing XCode so that we can use git to clone the dotfiles repo"
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    PROD=$(softwareupdate -l |
      grep "\*.*Command Line" |
      head -n 1 | awk -F"*" '{print $2}' |
      sed -e 's/^ *//' |
      tr -d '\n')
    softwareupdate -i "$PROD" --verbose
    rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  fi
}

setup_dotfiles() {
  echo "Cloning the dotfiles repository"
  read -p "Enter github username for dotfiles repo [$(id -un)]: " username
  username=${username:-$(id -un)}
  git clone git@github.com:${username}/dotfiles ~/dotfiles
  cd ~/dotfiles

  git submodule update --init --recursive

  echo "Repository cloned and initialized. Running bootstrap script:"
  ~/dotfiles/scripts/bootstrap
  ~/dotfiles/scripts/setup
}

gen_ssh_key
xcode_setup
setup_dotfiles

for i in gitconfig vim vimrc zshrc; do
  ln -s ~/dotfiles/$i ~/.$i
done

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install default homebrew stuff:

brew update
brew bundle install --file Brewfile
