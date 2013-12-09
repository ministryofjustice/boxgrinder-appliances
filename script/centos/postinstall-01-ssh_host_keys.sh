#!/bin/sh

# Set up the machine to regenerate its SSH host keys on boot. On CentOS this is
# as easy as just removing the host keys.
rm -f /etc/ssh/ssh_host_*

sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config
sed -i "s/#PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
