#!/bin/bash
set -eufx -o pipefail

# Warn user this script will overwrite current dotfiles
while true; do
  read -p "Warning: this will overwrite your current dotfiles. Continue? [y/n] " yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_dir=~/dotfiles_old

echo -n "Creating ${backup_dir} for backup of any existing dotfiles in ~..."
mkdir -p "${backup_dir}"
echo "done"

# Change to the dotfiles directory
echo -n "Changing to the ${dotfiles_dir} directory..."
cd "${dotfiles_dir}"
echo "done"

dotfiles_to_symlink=(
  'atom'

  'shell/vimrc'
  'shell/zshrc'

  'git/gitattributes'
  'git/gitconfig'
)

echo -n "Moving any existing dotfiles from ~ to ${backup_dir}..."
for i in "${dotfiles_to_symlink[@]}"; do
  dest="~/.${i##*/}"
  if [[ -e "${dest}" ]] && [[ ! -h "${dest}" ]]; then
    mv "${dest}" "${backup_dir}/"
  fi
done
echo "done"

echo -n "Installing dotfiles..."
for i in "${dotfiles_to_symlink[@]}"; do
  dest="~/.${i##*/}"
  if [[ ! -e "${dest}" ]]; then
    ln -s "${dotfiles_dir}/${i}" "${dest}"
  fi
done
echo "done"

# Each script sets up any necessary packages, and skips if not applicable:
"${dotfiles_dir}/install/apt.sh"
"${dotfiles_dir}/install/atom.sh"
"${dotfiles_dir}/install/brew.sh"
"${dotfiles_dir}/install/oh-my-zsh.sh"
"${dotfiles_dir}/install/vundle.sh"
