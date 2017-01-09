#!/bin/bash

if [ "$#" -lt 1 ]; then
	>&2 echo "Usage: $0 host[:port] [host[:port]] [...]"
	>&2 echo "Default port is 443 (https)"
	exit 1
fi

TLSA_ALL=''

for SERVER in "$@"
do
	HOST=$(echo $SERVER | cut -f1 -d:)
	if [[ $SERVER == *":"* ]]
	then
		PORT=$(echo $SERVER | cut -f2 -d:)
	else
		PORT="443"
	fi
	SHA256HASH=$(openssl s_client -connect $HOST:$PORT -servername $HOST -showcerts </dev/null 2>/dev/null | openssl x509 -noout -fingerprint -sha256 | tr -d : | cut -c 20-)
	TLSA="_$PORT._tcp.$HOST. "$'\t\t'"IN TLSA "$'\t'"3 0 1 $SHA256HASH"$'\n'
	TLSA_ALL=$TLSA_ALL$TLSA
	CERT=$(openssl s_client -connect $HOST:$PORT -servername $HOST -showcerts </dev/null 2>/dev/null | openssl x509 -noout -text | grep "Subject:" | cut -c 9-)
	>&2 echo "Info: host $HOST"
	>&2 echo "Info: port $PORT"
	>&2 echo "Info: certificate found: $CERT"
	>&2 echo "TLSA record:"
	>&2 echo "$TLSA"
	>&2 echo ""
done

>&2 echo "TLSA records summarized:"
echo "$TLSA_ALL"
>&2 echo ""

exit 0
