#!/bin/bash
cd /var/named/

# This script re-signs dnssec zones in bind.
# The zone files must be located like domain.tld: /var/named/domain.tld.zone
# The command 'dnssec-signzone' creates a /var/named/domain.tld.zone.signed file,
#  this file should be included in the named zone config.
#
# Tested on Fedora (fc24)


# List of zones: Example
ZONES=("mydomain.tld" "blablabla.com")


for ZONE in "${ZONES[@]}"; do
	echo Zone: $ZONE
	# Increase serial number
	# TODO: check for something changed in the given zone...
	SERIAL=`named-checkzone $ZONE $ZONE.zone.signed | egrep -ho '[0-9]{10}'`
	sed -i 's/'$SERIAL'/'$(($SERIAL+3))'/' $ZONE.zone
	# Sign zone
	dnssec-signzone -r /dev/random -3 $(openssl rand -hex 16) -A -o $ZONE -t $ZONE.zone
	# Print serial number of signed zone
	SERIAL=`named-checkzone $ZONE $ZONE.zone.signed | egrep -ho '[0-9]{10}'`
	echo Serial: $SERIAL
done

systemctl reload named.service

exit 0
