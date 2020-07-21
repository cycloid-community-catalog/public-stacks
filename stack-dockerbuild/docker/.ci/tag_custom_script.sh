#!/usr/bin/env bash

set -e
declare -a tags
DIR=$(dirname $(readlink -f $0))

# extract tag from VERSION file
#tags+=( "$(cat ${DIR}/../VERSION)" )

# extract tag from package.json
#tags+=( "$(jq -r ".version" < ${DIR}/../package.json)" )

# extract tag from pom.xml
#pip${PYTHON_VERSION} install -q --no-cache-dir yq
#tags+=( "$(xq -r ".project.version" < ${DIR}/../pom.xml)" )

# the script must be a space-separated string list of tags (eg. `tag1 tag2`)
printf "%s " "${tags[@]}" | xargs
