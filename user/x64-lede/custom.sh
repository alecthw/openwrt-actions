#!/bin/bash

echo "Test custom.sh"

sed -i "s@#src-git helloworld@src-git helloworld@g" feeds.conf.default
