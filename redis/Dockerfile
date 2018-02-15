FROM alpine:3.7

LABEL maintainer "https://github.com/blacktop"

ENV BRO_VERSION 2.5.1

COPY patches /tmp
RUN apk add --no-cache zlib openssl libstdc++ libpcap geoip libgcc tini
RUN apk add --no-cache -t .build-deps \
  linux-headers \
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
  curl \
  git \
  g++ \
  fts \
  && cd /tmp \
  && git clone --recursive --branch v$BRO_VERSION git://git.bro.org/bro \
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
  && cd /tmp/bro/aux/plugins \
  && git clone https://github.com/J-Gras/bro-af_packet-plugin \
  && cd /tmp/bro/aux/plugins/bro-af_packet-plugin \
  && make distclean \
  && CC=clang ./configure --with-kernel=/usr \
  && make \
  && make install \
  && echo "===> Compiling redis plugin..." \
  && apk add --no-cache hiredis-dev \
  && cd /tmp/bro/aux/plugins/redis \
  && CC=clang ./configure --bro-dist=/tmp/bro \
  && make \
  && make install \
  && echo "===> Shrinking image..." \
  && strip -s /usr/local/bin/bro \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

# Install the GeoIPLite Database
RUN mkdir -p /usr/share/GeoIP/ \
  && GEOIP=geolite.maxmind.com/download/geoip/database \
  && apk add --no-cache curl \
  && curl -s http://${GEOIP}/GeoLiteCity.dat.gz | zcat > /usr/share/GeoIP/GeoIPCity.dat \
  && curl -s http://${GEOIP}/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz | zcat > /usr/share/GeoIP/GeoIPCityv6.dat \
  && rm -rf /tmp/* \
  && apk del --purge curl

ENV BROPATH .:/data/config:/usr/local/share/bro:/usr/local/share/bro/policy:/usr/local/share/bro/site

WORKDIR /pcap

COPY local.bro /usr/local/share/bro/site/local.bro

ENTRYPOINT ["/sbin/tini","--","bro"]
CMD [ "-h" ]
