#!/usr/bin/env bash

export RUST_LOG="exonum=info,exonum_btc_anchoring=info"
export RUST_BACKTRACE=1

PATH=$PATH:~/.cargo/bin/

if [ $# -lt 2 ]; then
    echo "Not enough arguments, please provide node count and validator count"
    exit
fi

node_count=$1
validator_count=$2

if [ $((node_count)) -lt $((validator_count)) ] || [ $((validator_count)) -eq 0 ]; then
    echo "Please enter valid count of validators"
    exit
fi

bitcoind

echo "Waiting for bitcoind..."

OK=2
while [ $OK -ne 0 ]; do
    sleep 5s
    OUT=$(bitcoin-cli -testnet getwalletinfo 2>/dev/null)
   
    if grep -q balance <<<$OUT; then
        OK=0
    else
        echo -n "."
    fi
done

echo ""

services generate-template common.toml --validators-count ${validator_count} \
    --anchoring-network testnet \
    --anchoring-fee 10000 \
    --anchoring-frequency 200 \
    --anchoring-utxo-confirmations 1

for i in $(seq 1 $((validator_count)) )
do
    port=$((17031 - $((node_count)) + i))
    services generate-config common.toml \
        pub_${i}.toml \
        sec_${i}.toml \
        --anchoring-host=http://127.0.0.1:18332 \
        --peer-address 127.0.0.1:${port} \
        --anchoring-user=testnet \
        --anchoring-password=testnet

    VALIDATORS="${VALIDATORS} pub_${i}.toml"
#    echo "==============================="
    echo "generated config for node ${i}:"
#    echo "$(cat pub_${i}.toml) $(cat sec_${i}.toml)"
    echo ""
done

for i in $(seq $(( $((validator_count)) + 1 )) $((node_count)) )
do
    port=$((17031 - $((node_count)) + i))
    services generate-config common.toml \
        pub_${i}.toml \
        sec_${i}.toml \
        --anchoring-host=http://127.0.0.1:18332 \
        --peer-address 127.0.0.1:${port} \
        --anchoring-user=testnet \
        --anchoring-password=testnet

    VALIDATORS="${VALIDATORS} pub_${i}.toml"
#    echo "==============================="
    echo "generated config for node ${i}:"
#    echo "$(cat pub_${i}.toml) $(cat sec_${i}.toml)"
    echo ""
done

tx_ret=$(services finalize \
            --public-api-address 0.0.0.0:17032 \
            --private-api-address 0.0.0.0:$((17032 + node_count)) \
            sec_1.toml node_1_cfg.toml \
            --public-configs ${VALIDATORS} \
            --anchoring-create-funding-tx 10000 \
)
tx_id="${tx_ret##* }"

if grep -q error <<<${tx_ret};
then
    echo "Problems with finalization:"
    echo ${tx_ret}
    exit
fi

echo "Funding transaction with id ${tx_id} created."

#cat common.toml

for i in $(seq 2 $((node_count)) )
do
    public_port=$((17031 + i))
    private_port=$((public_port + node_count))

    services finalize \
        --public-api-address 0.0.0.0:${public_port} \
        --private-api-address 0.0.0.0:${private_port} \
        sec_${i}.toml node_${i}_cfg.toml \
        --public-configs ${VALIDATORS} \
        --anchoring-funding-txid ${tx_id}
    echo "new node with ports: ${public_port} (public) and ${private_port} (private)"
done

for i in $(seq 1 $((node_count)) )
do
    echo "running node ${i}..."
    services run --node-config node_${i}_cfg.toml -d db_${i} &
    # echo "node ${i} launched"
done

echo "${node_count} nodes configured and launched"

while :
do
    sleep 5m
done