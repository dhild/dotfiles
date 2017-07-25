#!/bin/bash
set -eu

base_dir="${1:-$(pwd)}"
base_dir="$(cd "${base_dir}" && pwd)"

for g in $(find "${base_dir}" -type d | grep -e '.*/\.git$'); do
  d="$(dirname "${g}")"
  if [[ $(echo "${d}" | grep -q '/\.terraform/') ]]; then
    continue
  fi
  if [[ "$(git -C "${d}" remote | wc -l)" -eq 0 ]]; then
    continue
  fi
  echo "Fetching ${d}"
  git -C "${d}" fetch

  # Go ahead and update to latest if we're clean
  if [[ "$(git -C "${d}" status --porcelain | wc -l)" -eq 0 ]]; then
    if [[ "$(git -C "${d}" rev-parse --symbolic-full-name HEAD)" == "refs/heads/master" ]] ||
       [[ "$(git -C "${d}" rev-parse --symbolic-full-name HEAD)" == "refs/heads/develop" ]]; then
      echo "Pull time in ${d}"
      git -C "${d}" pull
    fi
  fi
done
