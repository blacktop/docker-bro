# Integrate with the Elastic Stack

```bash
$ wget https://github.com/blacktop/docker-bro/raw/master/pcap/heartbleed.pcap
$ docker run -d --name elasticsearch -p 9200:9200 blacktop/elasticsearch:5.6
$ docker run -d --name kibana --link elasticsearch -p 5601:5601 blacktop/kibana:5.6
$ docker run -it --rm -v `pwd`:/pcap --link elasticsearch \
             blacktop/bro:elastic -r heartbleed.pcap local "Site::local_nets += { 192.168.11.0/24 }"

# assuming you are using Docker For Mac.             
$ open http://localhost:5601/app/kibana
```

> :warning: **NOTE:** I have noticed when running [elasticsearch](https://github.com/blacktop/docker-elasticsearch-alpine) on a **linux** host you need to increase the memory map areas with the following [command](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode)

```bash
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -w vm.max_map_count=262144
```

<!-- Configure the Bro index pattern ![index](imgs/index.png) -->

 Click the [Discover](http://localhost:5601/app/kibana#/discover) tab and filter to `_type:notice`

> Shortcut: <https://goo.gl/e5v7Qr>

![notice](imgs/notice.png)

## Watch a folder

```bash
$ docker run -d --name elstack -p 80:80 -p 9200:9200 blacktop/elastic-stack:5.6
$ docker run -it --rm -v `pwd`:/pcap --link elasticsearch blacktop/bro:elastic bro-watch

# assuming you are using Docker For Mac.             
$ open http://localhost/app/kibana

# download pcap into the watched folder on your host.  
$ wget https://github.com/blacktop/docker-bro/raw/master/pcap/heartbleed.pcap
```
