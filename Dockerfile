FROM ubuntu:latest
MAINTAINER blacktop, https://github.com/blacktop

# Make sure that Upstart won't try to start avgd after dpkg installs it
# https://github.com/dotcloud/docker/issues/446
ADD policy-rc.d /usr/sbin/policy-rc.d
RUN /bin/chmod 755 /usr/sbin/policy-rc.d

RUN apt-get -qq update

# Install Bro Required Dependencies
RUN apt-get install -yq cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev

# Install Bro Optional Dependencies
RUN apt-get install -yq libgeoip-dev libmagic-dev curl git-core wget gawk

# Clean Install Files
RUN apt-get autoclean -yq

# Install the GeoIPLite Database
ADD http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz /usr/share/GeoIP/
ADD http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz /usr/share/GeoIP/
RUN gunzip /usr/share/GeoIP/GeoLiteCity.dat.gz
RUN gunzip /usr/share/GeoIP/GeoLiteCityv6.dat.gz
RUN ln -s /usr/share/GeoIP/GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat
RUN ln -s /usr/share/GeoIP/GeoLiteCityv6.dat /usr/share/GeoIP/GeoIPCityv6.dat

# Install Bro
RUN git clone --recursive git://git.bro.org/bro
RUN cd bro && ./configure --prefix=/nsm/bro
RUN cd bro && make
RUN cd bro && make install
ENV PATH /nsm/bro/bin:$PATH

# Add PCAP Test Folder
ADD /pcap/heartbleed.pcap /pcap/
WORKDIR /pcap

ENTRYPOINT ["bro"]

CMD ["-h"]
