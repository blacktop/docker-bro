FROM debian:wheezy

MAINTAINER blacktop, https://github.com/blacktop

# Install Bro Required Dependencies
RUN buildDeps='libgoogle-perftools-dev \
              build-essential \
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
  && echo "[INFO] Installing Bro..." \
  && git clone --recursive --branch v2.4 git://git.bro.org/bro \
  && cd bro && ./configure --prefix=/nsm/bro \
  && make \
  && make install \
  && rm -rf /bro \
  && echo "[INFO] Cleaning image to reduce size..." \
  && apt-get purge -y $buildDeps \
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
