#!/usr/bin/env bash

docker build -t bitcoind docker/bitcoind
docker build -t rust docker/rust
docker build -t nodes docker/nodes