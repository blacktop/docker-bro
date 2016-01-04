FROM debian:jessie

MAINTAINER blacktop, https://github.com/blacktop

# Install Bro Required Dependencies
RUN buildDeps='libgoogle-perftools-dev \
              build-essential \
              ca-certificates \
              libcurl3-dev \
              libgeoip-dev \
              libpcap-dev \
              libssl-dev \
              python-dev \
              zlib1g-dev \
              git-core \
              cmake \
              make \
              g++ \
              gcc \
              python-dev' \
  && set -x \
  && echo "[INFO] Installing Dependancies..." \
  && apt-get -qq update \
  && apt-get install -yq $buildDeps \
                      php5-curl \
                      sendmail \
                      openssl \
                      bison \
                      flex \
                      gawk \
                      swig \
                      curl --no-install-recommends \
  && echo "Installing LibCAF (actor-framework) ..." \
  && cd /tmp \
  && git clone --recursive --branch 0.14.2 https://github.com/actor-framework/actor-framework.git \
  && cd actor-framework && ./configure --no-examples --no-benchmarks --no-opencl \
  && make \
  && make test \
  && make install \
  && echo "[INFO] Cloning Bro Source..." \
  && cd /tmp \
  && git clone --recursive git://git.bro.org/bro \
  && echo "[INFO] Installing Bro..." \
  && cd /tmp/bro && ./configure --prefix=/nsm/bro \
  && make \
  && make install \
  && echo "[INFO] Installing Elasticsearch Bro Plugin..." \
  && sed -i "s/JSON::TS_MILLIS/JSON::TS_ISO8601/g" /tmp/bro/aux/plugins/elasticsearch/src/ElasticSearch.cc \
  && sed -i "s/127.0.0.1/elasticsearch/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro \
  && sed -i "s/2secs/60secs/g" /tmp/bro/aux/plugins/elasticsearch/scripts/init.bro \
  && cd /tmp/bro/aux/plugins/elasticsearch \
  && ./configure \
  && make \
  && make install \
  && echo "[INFO] Cleaning image to reduce size..." \
  && rm -rf /bro \
  && apt-get remove -y $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the GeoIPLite Database
ADD /geoip /usr/share/GeoIP/
RUN \
  gunzip /usr/share/GeoIP/GeoLiteCityv6.dat.gz && \
  gunzip /usr/share/GeoIP/GeoLiteCity.dat.gz && \
  rm -f /usr/share/GeoIP/GeoLiteCityv6.dat.gz && \
  rm -f /usr/share/GeoIP/GeoLiteCity.dat.gz && \
  ln -s /usr/share/GeoIP/GeoLiteCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat && \
  ln -s /usr/share/GeoIP/GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat

ENV PATH /nsm/bro/bin:$PATH

# Add PCAP Test Folder
ADD /pcap/heartbleed.pcap /pcap/
VOLUME ["/pcap"]
WORKDIR /pcap

# Add Scripts Folder
ADD /scripts /scripts
ADD /scripts/local.bro /nsm/bro/share/bro/site/local.bro

ENTRYPOINT ["bro"]

CMD ["-h"]
