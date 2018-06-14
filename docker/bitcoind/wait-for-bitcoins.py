#!/usr/bin/env python3

import subprocess
import json
from time import sleep


class BitcoinCli:
    def __init__(self):
        self.args = ["bitcoin-cli", "-testnet"]

    def blockchain_info(self):
        args = self.args + ["getblockchaininfo"]
        proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out = proc.stdout.read().decode("UTF-8", "strict")
        try:
            response = json.loads(out)
            return response
        except Exception:
            return None

    def actual_balance(self):
        args = self.args + ["getwalletinfo"]
        proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out = proc.stdout.read().decode("UTF-8", "strict")
        try:
            response = json.loads(out)
            return response["balance"]
        except Exception:
            return 0

    def new_address(self):
        args = self.args + ["getnewaddress"]
        proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return proc.stdout.read().decode("UTF-8", "strict")[:-1]


bitcoin_cli = BitcoinCli()

print("Waiting for bitcoind...")
info = None
while not info:
    print('.', end='', flush=True)
    info = bitcoin_cli.blockchain_info()
    sleep(5)
print()

btc_address = bitcoin_cli.new_address()

print("Creating a new address: {}".format(btc_address))
print("\n<<<<< !!! Please send some btc to address: {} !!! >>>>>".format(btc_address))
print("\nWaiting for some btc on the balance of address: {} ...".format(btc_address))
while True:
    balance = bitcoin_cli.actual_balance()
    if balance > 0:
        print("Received btc: current balance is {}".format(balance))
        break
    info = bitcoin_cli.blockchain_info()
    print("Waiting for the next attempt, blocks: [{}/{}]".format(info["blocks"], info["headers"]))
    sleep(15)