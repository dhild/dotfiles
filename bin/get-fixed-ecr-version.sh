#!/bin/bash
## Usage: get-fixed-ecr-version.sh <repository_name> [image_tag] [tag_regex]
##
## Defaults:
##  image_tag        latest
##  tag_regex        \d+\.\d+\.\d+
##
## Translates an ECR tag into the version number with a corresponding tag (outputs to stdout).
## If there is no corresponding tag, outputs the SHA hash of the tag to stdout.
## If the tag does not exist, outputs an error message to stderr and nothing to stdout.
##
## Expects that the aws cli tools are available and configured.
##
set -eu
set -o pipefail

function usage() {
  [ "$*" ] && echo "$0: $*"
  sed -n '/^##/,/^$/s/^## \{0,1\}//p' "$0"
  exit 2
}

if [ $# -lt 1 ]; then
  >&2 usage
fi

repo_name=$1
tag=${2:-latest}
tag_regex=${3:-\\\\d+\\\\.\\\\d+\\\\.\\\\d+}

tag_sha=$(aws ecr list-images \
  --repository-name $repo_name \
  | jq -r ".imageIds[] \
    | select(.imageTag==\"$tag\") \
    | .imageDigest")

if [ -z "$tag_sha" ]; then
  >&2 echo "Repository $repo_name has no such tag \"$tag\""
fi

version=$(aws ecr list-images \
  --repository-name $repo_name \
  | jq -r ".imageIds[] \
    | select(has(\"imageTag\")) \
    | select(.imageTag | test(\"$tag_regex\")) \
    | select(.imageDigest==\"$tag_sha\") \
    | .imageTag")

if [ -z "$version" ]; then
  echo "$tag_sha"
else
  echo "$version"
fi
