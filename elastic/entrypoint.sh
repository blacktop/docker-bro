#!/bin/sh

set -e

# Add bro as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- bro "$@"
fi

if [ "$1" = 'watch' ]; then
		CURPATH=`pwd`

		inotifywait -mr --timefmt '%d/%m/%y %H:%M' --format '%T %w %f' \
		-e close_write /tmp/test | while read date time dir file; do

			   FILECHANGE=${dir}${file}
			   # convert absolute path to relative
			   FILECHANGEREL=`echo "$FILECHANGE" | sed 's_'$CURPATH'/__'`

				 if [[ $FILECHANGEREL == *.pcap ]]; then
					   /sbin/tini bro -r $FILECHANGEREL local \
					   && echo "At ${time} on ${date}, pcap $FILECHANGE was analyzed by bro"
			 	 fi
		done
fi

if [ "$1" = 'bro' ]; then
		until curl -s -XGET elasticsearch:9200/; do
			  >&2 echo "Failed to configure Elasticsearch, it's unavailable - sleeping 5s"
			  sleep 5
		done

		>&2 echo "Elasticsearch is up."
		>&2 echo "===> Set bro template..."
		curl -s -XPUT -H "Content-Type: application/json" --data @/template.json 'elasticsearch:9200/_template/bro'
		>&2 echo "===> Set bro index-pattern..."
		curl -s -XPUT -H "Content-Type: application/json" --data @/index-pattern.json \
		'elasticsearch:9200/.kibana/index-pattern/bro-*'
		>&2 echo "===> Set bro-* as kibana default index..."
		KIBANA=$(curl -s 'elasticsearch:9200/.kibana/config/_search' | jq -r '.hits.hits[] ._id')
		curl -s -XPUT "elasticsearch:9200/.kibana/config/$KIBANA" -d '{"defaultIndex" : "bro-*"}'

		set -- /sbin/tini -- "$@"
fi

exec "$@"
