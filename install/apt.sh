#!/bin/bash
set -euf -o pipefail

if [[ "$(uname -s)" != "Linux" ]] || [[ ! -e "/etc/lsb-release" ]]; then
  echo "Ubuntu not detected, exiting apt install script"
  exit
fi
