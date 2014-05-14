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
$ docker run -i -t blacktop/bro -r MY.pcap local
```
#### Or
```bash
$ docker run -it -v /pcap:/pcap:rw blacktop/bro -r -C /pcap/test.pcap
```
#### Output:
```bash

```
### Todo
- [x] Install/Run Bro-IDS
- [ ] Start Daemon and watch folder with supervisord
- [ ] Have container take a URL as input and download/scan file
- [ ] Output Scan Results as formated JSON
- [ ] Attach a Volume that will hold malware for a host's tmp folder
