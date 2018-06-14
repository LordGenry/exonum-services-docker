FROM rust

WORKDIR /usr/src

RUN git clone https://github.com/exonum/exonum-services-docker.git \
    && cd exonum-services-docker \
    && cargo install --example services \
    && cd /usr/src \
    && rm -rf exonum-services-docker

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:bitcoin/bitcoin \
    && apt-get update \
    && apt-get install -y bitcoind iputils-ping netcat curl

COPY bitcoin.conf /root/.bitcoin/bitcoin.conf

EXPOSE 18332:18332
EXPOSE 18333:18333

WORKDIR /exonum/services

COPY launch.sh .

ENTRYPOINT ["./launch.sh"]