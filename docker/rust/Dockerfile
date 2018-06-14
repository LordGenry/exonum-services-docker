FROM ubuntu:16.04

ENV ROCKSDB_LIB_DIR=/usr/lib/x86_64-linux-gnu
ENV SNAPPY_LIB_DIR=/usr/lib/x86_64-linux-gnu

RUN apt-get update \
    && apt-get install -y curl git gcc cpp make \
    libssl-dev pkg-config libsodium-dev libsnappy-dev librocksdb-dev \
    iputils-ping netcat curl

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable

RUN mv /root/.cargo/bin/* /usr/bin

ENTRYPOINT ["cargo"]

CMD ["build"]