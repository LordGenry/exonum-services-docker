To build and run node with anchoring & service & time:
```bash
./build_and_run.sh
```
Or run commands one by one
```bash
./build_dockers.sh
./prepare.sh
./run.sh
```

`./build_dockers.sh` - build 3 docker images:
1) `bitcoind` - the image with running bitcoind and loaded bitcoin testnet network.
2) `rust` - the iamge with installed rust and cargo
3) `nodes` - the image with running nodes

`./prepare.sh` - run bitcoind image and waiting for balance to be sufficient and save
bitcoin network to btc_anchoring volume

`./run.sh $node_count $validator_count` - run nodes with loaded bitcoin in btc_anchoring
volume with given `$node_count` and `$validator_count`
