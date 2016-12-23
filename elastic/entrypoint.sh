#!/bin/sh

set -e

# Add bro as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- bro "$@"
fi

if [ "$1" = 'bro' ]; then

  until curl -XGET elasticsearch:9200/; do
    >&2 echo "Failed to configure Elasticsearch, it's unavailable - sleeping 5s"
    sleep 5
  done

  >&2 echo "Elasticsearch is up - Set bro mapping"
  curl -XPUT -H "Content-Type: application/json" --data @template.json elasticsearch:9200/_template/bro

	set -- /sbin/tini -- "$@"
fi

exec "$@"
