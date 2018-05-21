#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m' # No Color

function command_exists {
#  this should be a very portable way of checking if something is on the path
#  usage: "if command_exists foo; then echo it exists; fi"
  type "$1" &> /dev/null
}

#if ! command_exists bitcoin; then
#    echo -e ${RED} please install bitcoin ${NC}
#    exit 0
#fi

services --help