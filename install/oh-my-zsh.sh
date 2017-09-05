#!/bin/bash
set -euf -o pipefail

# Install Oh My Zsh if it isn't already present
if [[ ! -d ~/.oh-my-zsh/ ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
