#!/usr/bin/env bash

node_count=$1
port_start=$((17032 - node_count))
port_end=$((17032 + 2 * node_count))

docker container run -p ${port_start}-${port_end}:${port_start}-${port_end} --name run-nodes --rm --mount source=btc_anchoring,target=/db nodes ${node_count}
