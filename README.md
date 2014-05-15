Bro IDS Dockerfile
=============

This repository contains a **Dockerfile** of [Bro-IDS](http://www.bro.org/index.html) for [Docker](https://www.docker.io/)'s [trusted build](https://index.docker.io/u/blacktop/bro/) published to the public [Docker Registry](https://index.docker.io/).

### Dependencies

* [ubuntu:latest](https://index.docker.io/_/ubuntu/)


### Installation

1. Install [Docker](https://www.docker.io/).

2. Download [trusted build](https://index.docker.io/u/blacktop/bro/) from public [Docker Registry](https://index.docker.io/): `docker pull blacktop/bro`

#### Alternatively, build an image from Dockerfile
```bash
$ docker build -t blacktop/bro .
```
### Usage
```bash
$ docker run -i -t -v /pcap:/pcap:rw blacktop/bro -r heartbleed.pcap local protocols/ssl/heartbleed.bro
```
#### Output:
```bash
$ ls

conn.log  files.log  heartbleed.pcap  loaded_scripts.log  'notice.log'  packet_filter.log  ssl.log  x509.log

$ cat notice.log | bro-cut note msg

SSL::Invalid_Server_Cert	SSL certificate validation failed with (self signed certificate)
'Heartbleed::SSL_Heartbeat_Attack_Success'	An Encrypted TLS heartbleed attack was probably detected! First packet client record length 32, first packet server record length 16416
```
#### Or use your own pcap
```bash
$ docker run -it -v /pcap:/pcap:rw blacktop/bro -r my.pcap local
```
### Todo
- [x] Install/Run Bro-IDS
- [ ] Start Daemon and watch folder with supervisord
- [ ] Have container take a URL as input and download/scan file
- [ ] Output Scan Results as formated JSON
- [ ] Attach a Volume that will hold malware for a host's tmp folder
