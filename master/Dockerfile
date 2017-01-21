FROM gliderlabs/alpine:3.4

LABEL maintainer "https://github.com/blacktop"

COPY patches /tmp
RUN apk-install zlib openssl libstdc++ libpcap geoip libgcc tini
RUN apk-install -t .build-deps linux-headers \
                                openssl-dev \
                                libpcap-dev \
                                python-dev \
                                geoip-dev \
                                zlib-dev \
                                binutils \
                                fts-dev \
                                cmake \
                                clang \
                                bison \
                                perl \
                                make \
                                flex \
                                git \
                                g++ \
                                fts \
  && set -x \
  && cd /tmp \
  && git clone --recursive git://git.bro.org/bro \
  && echo "===> Applying patches..." \
  && cd /tmp/bro \
  && patch -p1 < /tmp/bro-musl.patch \
  && cp /tmp/FindFTS.cmake cmake \
  && cd /tmp/bro/aux/binpac \
  && patch -p1 < /tmp/binpac-musl.patch \
  && echo "===> Compiling bro..." \
  && cd /tmp/bro \
  && CC=clang ./configure --disable-broker \
                          --disable-broctl --disable-broccoli \
                          --disable-auxtools --prefix=/usr/local \
  && make \
  && make install \
  && echo "===> Compiling af_packet plugin..." \
  && cd /tmp/bro/aux/plugins/af_packet \
  && make distclean \
  && CC=clang ./configure --with-kernel=/usr \
  && make \
  && make install \
  && echo "===> Shrinking image..." \
  && strip -s /usr/local/bin/bro \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

ENV BROPATH .:/data/config:/usr/local/share/bro:/usr/local/share/bro/policy:/usr/local/share/bro/site

VOLUME ["/pcap"]
WORKDIR /pcap

COPY local.bro /usr/local/share/bro/site/local.bro

ENTRYPOINT ["/sbin/tini","--","bro"]

CMD [ "-h" ]
