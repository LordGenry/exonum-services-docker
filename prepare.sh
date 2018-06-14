#!/usr/bin/env bash

echo "preparing bitcoind for anchoring"
docker volume create btc_anchoring
docker container run --name btc-anchoring -d --rm --mount source=btc_anchoring,target=/db bitcoind
docker container exec -it btc-anchoring /usr/local/bin/wait-for-bitcoins.py
docker container stop btc-anchoring