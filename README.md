![bro-logo](https://raw.githubusercontent.com/blacktop/docker-bro/master/logo.png)
Bro IDS Dockerfile
==================

This repository contains a **Dockerfile** of [Bro-IDS](http://www.bro.org/index.html) for [Docker](https://www.docker.io/)'s [trusted build](https://index.docker.io/u/blacktop/bro/) published to the public [Docker Registry](https://index.docker.io/).

### Dependencies

* [debian:wheezy](https://index.docker.io/_/debian/)

### Image Sizes
| Image | Virtual Size | Bro v2.3.1| TOTAL     |
|:------:|:-----------:|:---------:|:---------:|
| debian | 85.19 MB    | 432.61 MB | 517.8 MB  |

### Image Tags
```bash
$ docker images

REPOSITORY          TAG                 IMAGE ID           VIRTUAL SIZE
blacktop/bro        latest              3c2c99892865       531.7 MB
blacktop/bro        2.3.1               818430bd5aba       517.8 MB
blacktop/bro        2.2                 ade81f9fc043       527.8 MB
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

### To Run on OSX
 - Install [Homebrew](http://brew.sh)

```bash
$ brew install cask
$ brew cask install virtualbox
$ brew install docker
$ brew install boot2docker
$ boot2docker up
```
Add the following to your bash or zsh profile

```bash
alias bro='docker run -it --rm -v `pwd`:/pcap:rw blacktop/bro $@'
```
#### Usage

Capturing packets from an interface and writing them to a file can be done like this:

```bash
$ sudo tcpdump -i en0 -s 0 -w mypackets.trace
```

```bash
$ bro -r mypackets.trace local
```
To get rid of the `WARNING: No Site::local_nets have been defined.` message.

```bash
bro -r mypackets.trace local "Site::local_nets += { 1.2.3.0/24, 5.6.7.0/24 }"
```

### Todo
- [x] Install/Run Bro-IDS
- [x] Fix Geolocation feature
- [ ] Refine my extract-all.bro script
- [ ] Start Daemon and watch folder with supervisord
- [ ] Have container take a URL as input and download/scan pcap
- [ ] Add ELK Stack
