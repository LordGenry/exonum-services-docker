FROM rust:1.26.0

WORKDIR /usr/src
#RUN git clone https://github.com/exonum/exonum-services-docker \
#  && cd exonum-services-docker \
#  && cargo install --example services \
#  && cd /usr/src \
#  && rm -rf exonum-services-docker
#WORKDIR /exonum/services
COPY launch.sh .

ENTRYPOINT ["./launch.sh"]