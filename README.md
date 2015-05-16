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

