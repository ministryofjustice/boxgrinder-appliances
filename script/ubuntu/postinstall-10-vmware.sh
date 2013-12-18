#!/bin/bash

set -x

[ "$provider" = "vmware" ] || exit 0

cat > /etc/apt/sources.list.d/vmware-tools.list <<EOF
deb http://packages.vmware.com/tools/esx/5.1latest/ubuntu/ precise main
EOF

apt-key adv --import <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.1.4
Comment: Hostname: pgp.mit.edu

mI0ESAP+VwEEAMZylR8dOijUPNn3He3GdgM/kOXEhn3uQl+sRMNJUDm1qebi2D5bQa7GNBIl
Xm3DEMAS+ZlkiFQ4WnhUq5awEXU7MGcWCEGfums5FckV2tysSfn7HeWd9mkEnsY2CUZF54ly
KfY0f+vdFd6QdYo6b+YxGnLyiunEYHXSEo1TNj1vABEBAAG0QlZNd2FyZSwgSW5jLiAtLSBM
aW51eCBQYWNrYWdpbmcgS2V5IC0tIDxsaW51eC1wYWNrYWdlc0B2bXdhcmUuY29tPoi8BBMB
AgAmBQJIA/5XAhsDBQkRcu4ZBgsJCAcDAgQVAggDBBYCAwECHgECF4AACgkQwLXgq2b9SUkw
0AP/UlmWQIjMNcYfTKCOOyFxCsl3bY5OZ6HZs4qCRvzESVTyKs0YN1gX5YDDRmE5EbaqSO7O
LriA7p81CYhstYIDGjVTBqH/zJz/DGKQUv0A7qGvnX4MDt/cvvgEXjGpeRx42le/mkPsHdwb
G/8jKveYS/eu0g9IenS49i0hcOnjShGIRgQQEQIABgUCSAQWfAAKCRD1ZoIQEyn810LTAJ9k
IOziCqa/awfBvlLq4eRgN/NnkwCeJLOuL6eAueYjaODTcFEGKUXlgM4=
=bXtp
-----END PGP PUBLIC KEY BLOCK-----
EOF

export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical

apt-get -y update
apt-get -y install vmware-tools-esx-nox

service vmware-tools-services stop
