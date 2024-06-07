#!/bin/bash

# Execute after install feeds
# patch -> [update & install feeds] -> custom -> config

source ../lib.sh

echo "Execute custom custom.sh"

cat package/emortal/default-settings/files/99-default-settings
