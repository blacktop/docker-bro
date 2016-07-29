![bro-logo](https://raw.githubusercontent.com/blacktop/docker-bro/master/logo.png)

Bro IDS Dockerfile
==================

[![CircleCI](https://circleci.com/gh/blacktop/docker-bro.png?style=shield)](https://circleci.com/gh/blacktop/docker-bro)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)
[![Docker Stars](https://img.shields.io/docker/stars/blacktop/bro.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/bro.svg)][hub]
[![Docker Image](https://img.shields.io/badge/docker image-243.4 MB-blue.svg)][hub]

This repository contains a **Dockerfile** of [Bro-IDS](http://www.bro.org/index.html) **blacktop/bro**.

### Dependencies

* [debian:jessie (*125.2  MB*)](https://index.docker.io/_/debian/)

### Image Tags
```bash
$ docker images

REPOSITORY          TAG                 VIRTUAL SIZE
blacktop/bro        latest              676.3 MB
blacktop/bro        elastic             691 MB
blacktop/bro        2.4.1               488.4 MB
blacktop/bro        2.4                 488.4 MB
blacktop/bro        2.3.2               531 MB
blacktop/bro        2.2                 527.9 MB
```

### Installation

1. Install [Docker](https://www.docker.io/).
2. Download [trusted build](https://hub.docker.com/r/blacktop/bro/) from public [Docker Registry](https://index.docker.io/): `docker pull blacktop/bro`

### Usage
```bash
$ docker run -i -t -v /path/to/folder/pcap:/pcap:rw blacktop/bro -r heartbleed.pcap local
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

Add the following to your bash or zsh profile

```bash
alias bro='docker run -it --rm -v `pwd`:/pcap:rw blacktop/bro $@'
```

### Documentation

#### Usage

Capturing packets from an interface and writing them to a file can be done like this:

```bash
$ sudo tcpdump -i en0 -s 0 -w my_capture.pcap
```

To capture packets from a VMWare Fusion VM using **vmnet-sniffer** you can do this:

```bash
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-sniffer -e -w my_capture.pcap vmnet8
```

```bash
$ bro -r my_capture.pcap local
```
> To get rid of the `WARNING: No Site::local_nets have been defined.` message.

```bash
bro -r my_capture.pcap local "Site::local_nets += { 1.2.3.0/24, 5.6.7.0/24 }"
```

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/bro/issues/new) and I'll get right on it.

### Credits

### Todo
- [x] Install/Run Bro-IDS
- [x] Fix Geolocation feature
- [x] Refine my extract-all.bro script
- [ ] Start Daemon and watch folder with supervisord
- [ ] Have container take a URL as input and download/scan pcap
- [ ] Add ELK Stack

### License

MIT Copyright (c) 2015-2016 **blacktop**

[hub]: https://hub.docker.com/r/blacktop/bro/
