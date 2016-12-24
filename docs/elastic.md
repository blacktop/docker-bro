Integrate with the Elastic Stack
--------------------------------

```bash
$ wget https://github.com/blacktop/docker-bro/raw/master/pcap/heartbleed.pcap
$ docker run -d --name elstack -p 80:80 -p 9200:9200 blacktop/elastic-stack
$ docker run --rm -v `pwd`:/pcap --link elstack:elasticsearch \
             blacktop/bro:elastic -r heartbleed.pcap local "Site::local_nets += { 192.168.11.0/24 }"

# assuming you are using Docker For Mac.             
$ open http://localhost/app/kibana  
```

Configure the Bro index pattern

![index](imgs/index.png)

Click the [Discover](http://localhost/app/kibana#/discover) tab and filter to `_type:notice`

> Shortcut: [https://goo.gl/4Sh9UP](https://goo.gl/4Sh9UP)

![notice](imgs/notice.png)
