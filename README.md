![bro-logo](https://raw.githubusercontent.com/blacktop/docker-bro/master/logo.png)
Bro IDS Dockerfile
==================

This repository contains a **Dockerfile** of [Bro-IDS](http://www.bro.org/index.html) for [Docker](https://www.docker.io/)'s [trusted build](https://index.docker.io/u/blacktop/bro/) published to the public [Docker Registry](https://index.docker.io/).

### Dependencies

* [debian:wheezy](https://index.docker.io/_/debian/)

### Image Sizes
| Image | Virtual Size | Bro v2.3.1| TOTAL     |
|:------:|:-----------:|:---------:|:---------:|
| debian | 85.19 MB    | 443 MB    | 528.2 MB  |

### Image Tags
```bash
$ docker images

REPOSITORY          TAG                 IMAGE ID           VIRTUAL SIZE
blacktop/bro        latest              dc3d2ae6f8b4       528.2 MB
blacktop/bro        2.3.1               5da3974e6531       517.8 MB
blacktop/bro        2.2                 fd161df89829       586.5 MB
```

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
