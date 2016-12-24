FROM gliderlabs/alpine:3.4

MAINTAINER blacktop, https://github.com/blacktop

ENV BRO_VERSION v2.5

COPY patches /tmp
RUN apk-install zlib openssl libstdc++ libpcap geoip libgcc tini curl inotify-tools
RUN apk-install -t .build-deps linux-headers \
                                openssl-dev \
                                libpcap-dev \
                                python-dev \
                                geoip-dev \
                                zlib-dev \
                                curl-dev \
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
  && git clone --recursive --branch $BRO_VERSION git://git.bro.org/bro \
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
  && echo "===> Compiling elasticsearch plugin..." \
  # Tweaks to improve elasticsearch plugin's performance in docker
  && cd /tmp/bro/aux/plugins/elasticsearch/scripts && patch -p1 < /tmp/esplung-init.patch \
  && cd /tmp/bro/aux/plugins/elasticsearch/src && patch -p1 < /tmp/ElasticSearch.patch \
  && cd /tmp/bro/aux/plugins/elasticsearch/scripts/Bro/ElasticSearch && patch -p1 < /tmp/logs-to-elasticsearch.patch \
  # Tweaks protocols to improve indexing logs into elasticsearch
  && PROTOS=/usr/local/share/bro/base/protocols \
  && sed -i "s/version:     count           \&log/socks_version:     count           \&log/g" $PROTOS/socks/main.bro \
  && sed -i "s/\$version=/\$socks_version=/g" $PROTOS/socks/main.bro \
  && sed -i "s/version:          string \&log/ssl_version:     string \&log/g" $PROTOS/ssl/main.bro \
  && sed -i "s/\$version=/\$ssl_version=/g" $PROTOS/ssl/main.bro \
  && sed -i "s/version:         count        \&log/ssh_version:         count        \&log/g" $PROTOS/ssh/main.bro \
  && sed -i "s/\$version =/\$ssh_version =/g" $PROTOS/ssh/main.bro \
  && sed -i "s/version: string \&log/snmp_version: string \&log/g" $PROTOS/snmp/main.bro \
  && sed -i "s/\$version=/\$snmp_version=/g" $PROTOS/snmp/main.bro \
  # Build elasticsearch plugin
  && cd /tmp/bro/aux/plugins/elasticsearch \
  && CC=clang ./configure \
  && make \
  && make install \
  # Stop local logging to prevent filling up the container with logs
  && sed -i "s/WRITER_ASCII/WRITER_NONE/g" /usr/local/share/bro/base/frameworks/logging/main.bro \
  && echo "===> Shrinking image..." \
  && strip -s /usr/local/bin/bro \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

ENV BROPATH .:/data/config:/usr/local/share/bro:/usr/local/share/bro/policy:/usr/local/share/bro/site

VOLUME ["/pcap"]
WORKDIR /pcap

# Add some scripts
ADD https://github.com/blacktop/docker-bro/raw/master/scripts/log-passwords.bro \
    /usr/local/share/bro/passwords/log-passwords.bro
ADD https://github.com/blacktop/docker-bro/raw/master/scripts/conn-add-geodata.bro \
    /usr/local/share/bro/geodata/conn-add-geodata.bro

COPY local.bro /usr/local/share/bro/site/local.bro
COPY template.json /template.json
COPY index-pattern.json /index-pattern.json
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "-h" ]
