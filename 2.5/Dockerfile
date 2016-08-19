FROM debian:jessie

MAINTAINER blacktop, https://github.com/blacktop

ENV TINI_VERSION v0.9.0
ENV TINI_URL github.com/krallin/tini/releases/download

# Install Bro Required Dependencies
RUN set -x \
  && echo "[INFO] Installing Dependancies =========================================================" \
  && apt-get -qq update \
  && apt-get install -yq ca-certificates curl unzip --no-install-recommends \
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
  && curl -sL http://download.opensuse.org/repositories/network:bro/Debian_8.0/Release.key \
    | apt-key add - \
  && echo 'deb http://download.opensuse.org/repositories/network:/bro/Debian_8.0/ /' \
    >> /etc/apt/sources.list.d/bro.list \
  && apt-get update \
  && apt-get install -y bro-beta \
  && echo "[INFO] Add Extras ======================================================================" \
  && curl -sL https://github.com/blacktop/docker-bro/archive/master.zip > /tmp/bro.zip \
  && cd /tmp \
  && unzip bro.zip \
  && cd docker-bro-master \
  && echo "[INFO] Add Scripts..." \
  && mv scripts /scripts \
  && echo "[INFO] Add GeoIPLite Database..." \
  && mv geoip /usr/share/GeoIP/ \
  && gunzip /usr/share/GeoIP/GeoLiteCity.dat.gz \
  && rm -f /usr/share/GeoIP/GeoLiteCity.dat.gz \
  && ln -s /usr/share/GeoIP/GeoLiteCity.dat /usr/share/GeoIP/GeoIPCity.dat \
  && echo "[INFO] Cleaning image to reduce size ===================================================" \
  && apt-get purge -y ca-certificates curl unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH /opt/bro/bin:$PATH

# Add PCAP Test Folder
ADD https://github.com/blacktop/docker-bro/raw/master/pcap/heartbleed.pcap /pcap/
VOLUME ["/pcap"]
WORKDIR /pcap

# Add local.bro
COPY local.bro /opt/bro/share/bro/site/local.bro

ENTRYPOINT ["tini","--","bro"]

CMD ["-h"]
