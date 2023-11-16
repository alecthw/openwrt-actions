#!/bin/bash

# Execute after install feeds
# patch -> [update & install feeds] -> custom -> config

source ../lib.sh

echo "Execute custom custom.sh"

cat package/lean/default-settings/files/zzz-default-settings
