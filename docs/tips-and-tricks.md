Tips and Tricks
---------------

### Create a pcap

Capturing packets from an interface and writing them to a file can be done like this:

```bash
$ sudo tcpdump -i en0 -s 0 -w my_capture.pcap
```

To capture packets from a VMWare Fusion VM using **vmnet-sniffer** you can do this:

```bash
sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-sniffer -e -w my_capture.pcap vmnet8
```

### Get rid of the `WARNING: No Site::local_nets have been defined.` message.

```bash
bro -r my_capture.pcap local "Site::local_nets += { 1.2.3.0/24, 5.6.7.0/24 }"
```

### Use **blacktop/bro** like a host binary

Add the following to your bash or zsh profile

```bash
alias bro='docker run --rm -v `pwd`:/pcap:rw blacktop/bro $@'
```
