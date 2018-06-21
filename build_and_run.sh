#!/usr/bin/env bash

./build_dockers.sh
./prepare.sh
./run.sh $1 $2

