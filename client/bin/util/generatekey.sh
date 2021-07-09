#!/bin/sh

openssl genrsa -des3 -out server.key 1024

openssl rsa -in server.key -out calypso_ers.pem

openssl req -new -key server.key -out server.csr

openssl x509 -req -days 360 -in server.csr -signkey server.key -out calypso_ers.crt
