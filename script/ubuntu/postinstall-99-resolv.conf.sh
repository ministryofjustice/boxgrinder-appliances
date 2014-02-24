#!/bin/bash

cat > /etc/resolv.conf <<'EOF'
nameserver 8.8.8.8
EOF

cat > /etc/resolvconf/resolv.conf.d/base <<'EOF'
nameserver 8.8.4.4
EOF

rm -f /etc/resolvconf/resolv.conf.d/tail
rm -f /etc/resolvconf/resolv.conf.d/original

# This will get over-written but make sure the version on the image doesn't
# have the invalid DNS server from the build box
cat > /etc/resolv.conf <<'EOF'
nameserver 8.8.4.4
EOF
