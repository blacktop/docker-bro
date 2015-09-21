FROM alpine

MAINTAINER blacktop, https://github.com/blacktop

RUN buildDeps='autoconf \
              file-dev \
              cmake \
              git \
              geoip-dev \
              libtool \
              build-base \
              curl-dev \
              zlib-dev \
              bind-dev \
              libpcap-dev \
              openssl-dev \
              python-dev \
              qt5-qtbase-dev \
              protobuf-dev \
              doxygen \
              boost-dev \
              libedit-dev' \
  && set -x \
  && apk --update add python openssl file flex gawk swig curl bison $buildDeps \
  && echo "Installing Google Performance Tools (gperftools) ..." \    
  && cd /tmp \
  && git clone --recursive --branch gperftools-2.4 https://github.com/gperftools/gperftools.git \
  && cd gperftools \
  &&
  && echo "Installing LibCAF (actor-framework) ..." \
  && cd /tmp \
  && git clone --recursive --branch 0.14.1 https://github.com/actor-framework/actor-framework.git \
  && cd actor-framework && ./configure --no-examples --no-opencl --no-benchmarks \
  && make \
  && make test \
  && make install \
  && echo "Installing Bro..." \
  && cd /tmp \
  && git clone --recursive git://git.bro.org/bro \
  && cd bro && ./configure --prefix=/nsm/bro \
  && make \
  && make install \
  && apk del --purge $buildDeps \
  && rm -rf /tmp/* /root/.cache /var/cache/apk/*

ADD https://gperftools.googlecode.com/files/gperftools-2.1.tar.gz /
RUN tar xfz gperftools-2.1.tar.gz

# # Install Bro Required Dependencies
# RUN \
#   apt-get -qq update && \
#   apt-get install -yq libgoogle-perftools-dev \
#                       build-essential \
#                       libcurl3-dev \
#                       libgeoip-dev \
#                       libpcap-dev \
#                       libssl-dev \
#                       python-dev \
#                       zlib1g-dev \
#                       php5-curl \
#                       git-core \
#                       sendmail \
#                       openssl \
#                       bison \
#                       cmake \
#                       flex \
#                       gawk \
#                       make \
#                       swig \
#                       curl \
#                       g++ \
#                       gcc --no-install-recommends && \
#   apt-get clean && \
#   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
# # Install the GeoIPLite Database
# ADD /geoip /usr/share/GeoIP/
# RUN \
#   gunzip /usr/share/GeoIP/GeoLiteCityv6.dat.gz && \
#   gunzip /usr/share/GeoIP/GeoLiteCity.dat.gz && \
#   rm -f /usr/share/GeoIP/GeoLiteCityv6.dat.gz && \
#   rm -f /usr/share/GeoIP/GeoLiteCity.dat.gz && \
#   ln -s /usr/share/GeoIP/GeoLiteCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat && \
#   ln -s /usr/share/GeoIP/GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat
#
# # Install Bro and remove install dir after to conserve space
# RUN  \
#   git clone --recursive git://git.bro.org/bro && \
#   cd bro && ./configure --prefix=/nsm/bro && \
#   make && \
#   make install && \
#   rm -rf /bro && \
#   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
# ENV PATH /nsm/bro/bin:$PATH
#
# # Add PCAP Test Folder
# ADD /pcap/heartbleed.pcap /pcap/
# VOLUME ["/pcap"]
# WORKDIR /pcap
#
# # Add Scripts Folder
# ADD /scripts /scripts
# ADD /scripts/local.bro /nsm/bro/share/bro/site/local.bro

ENTRYPOINT ["bro"]

CMD ["-h"]
