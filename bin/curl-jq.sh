#!/usr/bin/env sh

curl -s "$1" | jq -rc "$2"
