#!/bin/sh

# Set up some sensible default nameservers
cat >/etc/resolv.conf <<EOM
nameserver 8.8.8.8
nameserver 8.8.4.4
search localdomain
EOM
