#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "Usage: $0 host[:port] [host[:port]] [...]"
	echo "Default port is 443 (https)"
	exit 1
fi

for SERVER in "$@"
do
	HOST=$(echo $SERVER | cut -f1 -d:)
	if [[ $SERVER == *":"* ]]
	then
		PORT=$(echo $SERVER | cut -f2 -d:)
	else
		PORT="443"
	fi
	SIGALG=$(openssl s_client -connect $HOST:$PORT -servername $HOST -showcerts </dev/null 2>/dev/null | openssl x509 -noout -text 2>/dev/null | grep "Signature Algorithm:" | tail -n1 | cut -c 26-)
	
	if [[ $SIGALG == *"sha1"* ]]
	then
		SIGALG=$SIGALG" (weak!)"
	fi

	echo "Server $SERVER Port $PORT: $SIGALG"
done

exit 0
