FROM debian:wheezy

MAINTAINER blacktop, https://github.com/blacktop

#Prevent daemon start during install
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Install Bro Required Dependencies
RUN \
  apt-get -qq update && \
  apt-get install -yq libgoogle-perftools-dev \
                      build-essential \
                      libcurl3-dev \
                      libgeoip-dev \
                      libpcap-dev \
                      libssl-dev \
                      python-dev \
                      zlib1g-dev \
                      php5-curl \
                      git-core \
                      sendmail \
                      bison \
                      cmake \
                      flex \
                      gawk \
                      make \
                      swig \
                      curl \
                      g++ \
                      gcc --no-install-recommends && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the GeoIPLite Database
ADD /geoip /usr/share/GeoIP/
RUN \
  gunzip /usr/share/GeoIP/GeoLiteCityv6.dat.gz && \
  gunzip /usr/share/GeoIP/GeoLiteCity.dat.gz && \
  rm -f /usr/share/GeoIP/GeoLiteCityv6.dat.gz && \
  rm -f /usr/share/GeoIP/GeoLiteCity.dat.gz && \
  ln -s /usr/share/GeoIP/GeoLiteCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat && \
  ln -s /usr/share/GeoIP/GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat

# Install Bro and remove install dir after to conserve space
RUN  \
  git clone --recursive git://git.bro.org/bro && \
  cd bro && ./configure --prefix=/nsm/bro && \
  make && \
  make install && \
  rm -rf /bro && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
