FROM gliderlabs/alpine:3.4

MAINTAINER blacktop, https://github.com/blacktop

RUN apk-install python perl openssl file flex gawk swig curl bison bash
RUN apk-install -t build-deps qt5-qtbase-dev \
                              protobuf-dev \
                              openssl-dev \
                              libpcap-dev \
                              libedit-dev \
                              python-dev \
                              build-base \
                              geoip-dev \
                              boost-dev \
                              zlib-dev \
                              file-dev \
                              curl-dev \
                              bind-dev \
                              autoconf \
                              libtool \
                              doxygen \
                              autoconf \
                              automake \
                              abuild \
                              binutils \
                              cmake \
                              gcc \
                              g++ \
                              git \
  && set -x \
  && echo "Installing Google Performance Tools (gperftools) ..." \
  && cd /tmp \
  && git clone --recursive --branch gperftools-2.5 https://github.com/gperftools/gperftools.git \
  && cd gperftools \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install \
  && echo "Installing Bro..." \
  && cd /tmp \
  && git clone --recursive --branch v2.4.1 git://git.bro.org/bro \
  && cd bro \
  && ./configure --prefix=/opt/bro --disable-perftools \
  && make \
  && make install \
  && rm -rf /tmp/* \
  && apk del --purge build-deps


  # && echo "Installing Google Performance Tools (gperftools) ..." \
  # && cd /tmp \
  # && git clone --recursive --branch gperftools-2.5 https://github.com/gperftools/gperftools.git \
  # && cd gperftools \
  # && ./autogen.sh \
  # && ./configure \
  # && make \
  # && make install \
  # && echo "Installing LibCAF (actor-framework) ..." \
  # && cd /tmp \
  # && git clone --recursive --branch 0.14.2 https://github.com/actor-framework/actor-framework.git \
  # && cd actor-framework && ./configure --no-examples --no-opencl --no-benchmarks \
  # && make \
  # && make test \
  # && make install \

# ADD https://gperftools.googlecode.com/files/gperftools-2.1.tar.gz /
# RUN tar xfz gperftools-2.1.tar.gz

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
