FROM ubuntu:16.04

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:bitcoin/bitcoin \
    && apt-get update \
    && apt-get install -y bitcoind iputils-ping netcat curl

COPY bitcoin.conf /root/.bitcoin/bitcoin.conf

EXPOSE 18332:18332
EXPOSE 18333:18333

ADD wait-for-bitcoins.py /usr/local/bin

ENTRYPOINT ["/usr/bin/bitcoind"]