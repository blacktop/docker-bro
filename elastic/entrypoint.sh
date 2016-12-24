#!/bin/sh

set -e

set_up_elasticsearch() {
	# wait for elasticsearch to come online
	until curl -s --output /dev/null -XGET elasticsearch:9200/; do
	  echo "Elasticsearch is unavailable - sleeping 5s"
	  sleep 5
	done
	# wait for .kibana index to be created
	while test $(curl -o /dev/null -s --write-out '%{http_code}' elasticsearch:9200/.kibana/config/_search) -ne 200; do
	  echo "Elasticsearch .kibana index is unavailable - sleeping 5s"
	  sleep 5
	done

	# create template and index-pattern on first run
	KIBANA=$(curl -s 'elasticsearch:9200/.kibana/config/_search' | jq -r '.hits.hits[] ._id')
	if [ "$(curl -s "elasticsearch:9200/.kibana/config/$KIBANA" | jq -r '._source.defaultIndex?')" == "null" ]; then
		echo -e "\nElasticsearch is up"
		echo "===> Set bro template..."
		curl -s -XPUT -H "Content-Type: application/json" --data @/template.json 'elasticsearch:9200/_template/bro'
		echo -e "\n\n===> Set bro index-pattern..."
		curl -s -XPUT -H "Content-Type: application/json" --data @/index-pattern.json \
		'elasticsearch:9200/.kibana/index-pattern/bro-*'
		sleep 3
		echo -e "\n\n===> Set bro-* as kibana default index..."
		curl -s -XPUT "elasticsearch:9200/.kibana/config/$KIBANA" -d '{"defaultIndex" : "bro-*"}'
		echo -e "\n"
	fi
}

# Add bro as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- bro "$@"
fi

if [ "$1" = 'bro-watch' ]; then

	set_up_elasticsearch

	CURPATH=`pwd`
	echo -e "===> Now watching path $CURPATH for new pcap files..."
	inotifywait -m --timefmt '%d/%m/%y %H:%M' --format '%T %w %f' -e moved_to,create /pcap | \
	while read date time dir file; do

		FILECHANGE=${dir}${file}
		# convert absolute path to relative
		FILECHANGEREL=`echo "$FILECHANGE" | sed 's_'$CURPATH'/__'`

		if [[ $FILECHANGEREL == *.pcap ]]; then
			echo "At ${time} on ${date}, pcap $FILECHANGE was analyzed by bro"
			bro -r $FILECHANGEREL local
			echo "Moving analyzed pcap $FILECHANGE to /tmp"
			mv $FILECHANGEREL /tmp
		fi
		sleep 1
	done
fi

if [ "$1" = 'bro' ]; then

	set_up_elasticsearch

	set -- "$@"
fi

exec "$@"
