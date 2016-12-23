Integrate with the Elastic Stack
--------------------------------

```bash
$ wget https://github.com/blacktop/docker-bro/raw/master/pcap/heartbleed.pcap
$ docker run -d --name elstack -p 80:80 -p 9200:9200 blacktop/elastic-stack
$ docker run --rm -it -v `pwd`:/pcap --link elstack:elasticsearch bro:elastic -r heartbleed.pcap local "Site::local_nets += { 192.168.11.0/24 }"
$ open http://localhost/app/kibana  # assuming you are using Docker For Mac.
```

Configure the Bro index pattern

![index](imgs/index.png)

Click the [Discover](http://localhost/app/kibana#/discover) tab and filter to `_type:notice`

> Shortcut: http://localhost/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:'2014-04-10T21:03:16.403Z',mode:absolute,to:'2014-04-10T21:03:16.425Z'))&_a=(columns:!(note,msg),index:'bro-*',interval:auto,query:(query_string:(analyze_wildcard:!t,query:'_type:notice')),sort:!(ts,desc))

![notice](imgs/notice.png)
