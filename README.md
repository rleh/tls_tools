# TLS Tools
Tools for TLS and DANE (DNS-based Authentication of Named Entities)


### TLSA record generator
Generate a TLSA record for BIND.

The certificate is retrieved from the server using ```openssl s_client```.
Servers using SNI (*Server Name Indication* is a TLS extension to allow multiple secure hostnames to be served from a single IP address) are supported.

##### Usage
```
./generate-tlsa.sh host[:port] [host[:port]] [...]
```
The default port is 443 (https).



### Certificate signature algorithm checker
Shows the signature algorithm of the certificate used by the servers.

The certificate is retrieved from the server using ```openssl s_client```.
Servers using SNI (*Server Name Indication* is a TLS extension to allow multiple secure hostnames to be served from a single IP address) are supported.

##### Usage
```
./check-signature-algorithm.sh host[:port] [host[:port]] [...]
```
The default port is 443 (https).


## Bonus

### Server with TLSA records and DNSSEC
The scripts `letsencrypt-renew_tlsa_dnssec.sh` and `bind_dnssec_resign.sh` can be used on servers with TLS enabled services (like HTTPS, IMAPS or SMTPS) with self-hosted primary bind nameserver.

Both script must be adapted to your local DNS zones and subdomains with TLSA records.

`letsencrypt-renew_tlsa_dnssec.sh` renews certs from Let’s Encrypt, restarts (or reloads) the affected services, (re)generates TLSA records for the DNS zones and re-signs the DNSSEC secured zones the pubish the new TLSA records.
