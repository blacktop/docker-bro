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
$ docker run -i -t -v /path/to/folder/pcap:/pcap:rw blacktop/bro -r heartbleed.pcap local protocols/ssl/heartbleed.bro
```
#### Output:
```bash
$ ls -l

-rw-r--r-- 1 root root   617 Jul 27 02:00 conn.log
-rw-r--r-- 1 root root   734 Jul 27 02:00 files.log
-rw-r--r-- 1 root root 15551 Jul 27 02:00 loaded_scripts.log
-rw-r--r-- 1 root root  1938 Jul 27 02:00 'notice.log'
-rw-r--r-- 1 root root   253 Jul 27 02:00 packet_filter.log
-rw-r--r-- 1 root root   781 Jul 27 02:00 ssl.log
-rw-r--r-- 1 root root   901 Jul 27 02:00 x509.log
```
```bash
$ cat notice.log | awk '{ print $11 }' | tail -n4

Heartbleed::SSL_Heartbeat_Attack
Heartbleed::SSL_Heartbeat_Odd_Length
Heartbleed::SSL_Heartbeat_Attack_Success
```
#### Or use your own pcap
```bash
$ docker run -it -v /path/to/pcap:/pcap:rw blacktop/bro -r my.pcap local
```
### Todo
- [x] Install/Run Bro-IDS
- [x] Fix Geolocation feature
- [ ] Start Daemon and watch folder with supervisord
- [ ] Have container take a URL as input and download/scan pcap
- [ ] Add ELK Stack
