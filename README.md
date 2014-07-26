![bro-logo](https://raw.githubusercontent.com/blacktop/docker-bro/master/logo.png)
Bro IDS Dockerfile
==================

This repository contains a **Dockerfile** of [Bro-IDS](http://www.bro.org/index.html) for [Docker](https://www.docker.io/)'s [trusted build](https://index.docker.io/u/blacktop/bro/) published to the public [Docker Registry](https://index.docker.io/).

### Dependencies

* [debian:jessie](https://index.docker.io/_/debian/)

### Image Sizes
| Image | Virtual Size | Bro       | TOTAL     |
|:-----:|:------------:|:---------:|:---------:|
| debian | 89.59 MB    | 492.71 MB | 582.3 MB  |
| ubuntu | 192.7 MB    | 432.7 MB  | 625.4 MB  |

<!-- * **base image(**debian**)** *virtual size* - **89.59 MB**
* **total** *virtual size* - **582.3 MB**
___
* **base image(**ubuntu:latest**)** *virtual size* - **192.7 MB**
* **total** *virtual size* - **631 MB** -->

### Installation

1. Install [Docker](https://www.docker.io/).

2. Download [trusted build](https://index.docker.io/u/blacktop/bro/) from public [Docker Registry](https://index.docker.io/): `docker pull blacktop/bro`

#### Alternatively, build an image from Dockerfile
```bash
$ docker build -t blacktop/bro github.com/blacktop/docker-bro
```
### Usage
```bash
$ docker run -i -t -v /path/to/pcap:/pcap:rw blacktop/bro -r heartbleed.pcap local protocols/ssl/heartbleed.bro
```
#### Output:
```bash
$ ls

conn.log  files.log  heartbleed.pcap  loaded_scripts.log  'notice.log'  packet_filter.log  ssl.log  x509.log
```
```bash
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
- [ ] Fix Geolocation feature
- [ ] Start Daemon and watch folder with supervisord
- [ ] Have container take a URL as input and download/scan pcap
- [ ] Add ELK Stack
