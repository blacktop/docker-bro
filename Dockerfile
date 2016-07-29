FROM debian:jessie

MAINTAINER blacktop, https://github.com/blacktop

ENV TINI_VERSION v0.9.0
ENV TINI_URL github.com/krallin/tini/releases/download

# Install Bro Required Dependencies
RUN buildDeps='libgoogle-perftools-dev \
               build-essential \
               libgeoip-dev \
               libcurl3-dev \
               libpcap-dev \
               zlib1g-dev \
               python-dev \
               libssl-dev \
               python-dev \
               git-core \
               cmake \
               make \
               gcc \
               g++' \
  && set -x \
  && echo "[INFO] Installing Dependancies =========================================================" \
  && apt-get -qq update \
  && apt-get install -yq $buildDeps \
                         ca-certificates \
                         sendmail \
                         openssl \
                         bison \
                         swig \
                         gawk \
                         flex \
                         curl --no-install-recommends \
  && echo "Grab tini for signal processing and zombie killing =====================================" \
  && curl -sL "https://$TINI_URL/$TINI_VERSION/tini" > /usr/local/bin/tini \
  && curl -sL "https://$TINI_URL/$TINI_VERSION/tini.asc" > /usr/local/bin/tini.asc \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
  && gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
  && rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
  && chmod +x /usr/local/bin/tini \
  && tini -h \
  && echo "[INFO] Installing Bro-IDS ==============================================================" \
  && cd /tmp \
  && git clone --recursive -b v2.4.1 git://git.bro.org/bro \
  && cd /tmp/bro && ./configure --prefix=/opt/bro \
  && make \
  && make install \
  && echo "[INFO] Installing Kafka Bro Plugin =====================================================" \
  && cd /tmp \
  && curl -L https://github.com/edenhill/librdkafka/archive/0.9.1.tar.gz | tar xvz \
  && cd librdkafka-0.9.1 \
  && ./configure \
  && make \
  && make install \
  && cd /tmp/bro/aux/plugins/kafka \
  && ./configure --bro-dist=/opt/bro \
  && make \
  && make install \
  && bro -N Bro::Kafka
  && echo "[INFO] Cleaning image to reduce size ===================================================" \
  && rm -rf /bro \
  && apt-get purge -y $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the GeoIPLite Database
COPY /geoip /usr/share/GeoIP/
RUN gunzip /usr/share/GeoIP/GeoLiteCity.dat.gz \
  && rm -f /usr/share/GeoIP/GeoLiteCity.dat.gz \
  && ln -s /usr/share/GeoIP/GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat

ENV PATH /opt/bro/bin:$PATH

# Add PCAP Test Folder
COPY /pcap/heartbleed.pcap /pcap/
VOLUME ["/pcap"]
WORKDIR /pcap

# Add Scripts Folder
COPY /scripts /scripts
COPY /scripts/local.bro /opt/bro/share/bro/site/local.bro

ENTRYPOINT ["tini","--","bro"]

CMD ["-h"]

  # && curl -sL http://download.opensuse.org/repositories/network:bro/Debian_8.0/Release.key | apt-key add - \
  # && echo 'deb http://download.opensuse.org/repositories/network:/bro/Debian_8.0/ /' >> /etc/apt/sources.list.d/bro.list \
  # && apt-get update \
  # && apt-get install -y bro \
  # && echo "[INFO] Installing Elasticsearch Bro Plugin =============================================" \
  # && sed -i "s/JSON::TS_MILLIS/JSON::TS_ISO8601/g" /tmp/bro/aux/plugins/elasticsearch-deprecated/src/ElasticSearch.cc \
  # && sed -i "s/127.0.0.1/elasticsearch/g" /tmp/bro/aux/plugins/elasticsearch-deprecated/scripts/init.bro \
  # && sed -i "s/2secs/60secs/g" /tmp/bro/aux/plugins/elasticsearch-deprecated/scripts/init.bro \
  # && cd /tmp/bro/aux/plugins/elasticsearch-deprecated \
  # && ./configure --bro-dist=/opt/bro \
  # && make \
  # && make install \
  # && bro -N Bro::ElasticSearch \
