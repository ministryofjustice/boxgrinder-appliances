#!/bin/bash

set -e

# Can't install this as the package in the .appl file as the ubuntu plugin doesn't yet support adding PPAs

apt-key adv --import <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: SKS 1.1.4
Comment: Hostname: pgp.mit.edu

mI0ETs4aowEEALDRpPyebQ5JlJNmleRzZYzxO4Ia8hpCSHzLm6DaMvXcFesfP4OTN0J9JjAv
xbRxw8ROBz4SZ4iPhzPOZlXHBaI/5BF8Cc8CFW/HDqhPNH3qdOC9Te2q0QZgzd7WS94GXgzK
nKCi1bmZ5pCvoJEvu3XK24/jmfLijp/1iO46xuofABEBAAG0HExhdW5jaHBhZCBQUEEgZm9y
IFNhbHQgU3RhY2uIuAQTAQIAIgUCTs4aowIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AA
CgkQR1n6lg4nwKYQMwP9FQpta7rMNj2kgIvv3pXOr4z+Rgp3Vd8NmoHlIt6ZyigiisGfuht9
0PyvBLlJxpqGZt7bdz5QzV3HYSkk1K/L6CzpAgC/o/LPiir/Xi4ur/tgmRp30ONGPrLvSyRk
dv1pIkMqEekOSdTgjyvRq7+rYpqh5obYFJPoxSqDYOND9lo=
=woTM
-----END PGP PUBLIC KEY BLOCK-----
EOF

cat > /etc/apt/sources.list.d/ppa-salt.list <<EOF
deb http://ppa.launchpad.net/saltstack/salt/ubuntu $(lsb_release -sc) main
EOF

export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical

apt-get -y update
apt-get -y install salt-minion
