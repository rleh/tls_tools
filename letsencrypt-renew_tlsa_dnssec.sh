#!/bin/bash

set -e

# First: renew letsencrypt certs
letsencrypt renew

# and restart services
systemctl restart nginx.service
systemctl restart dovecot.service
systemctl restart postfix.service


# Second: re-generate TLSA records (DNS) with generate_tlsa.sh
#   Usage: ./generate-tlsa.sh host[:port[:starttls_prot]] [host[:port[:starttls_prot]]] [...]
#   Default port is 443 (https) and disabled starttls

# Example:
~/bin/generate-tlsa.sh mydomain.tld:443 www.mydomain.tld:443 mail.mydomain.tld:25:smtp mail.mydomain.tld:993 2>/dev/null > /var/named/tlsa_mydomain.tld
# and more for each zone...

# The zone file (e.g. /var/named/mydomain.tld.zone) should include the tlsa record file: '$INCLUDE tlsa_mydomain.tld'

# Third: update & re-sign DNS zone(s)
~/bin/bind_dnssec_resign.sh

exit 0
