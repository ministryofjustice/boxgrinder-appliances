#!/bin/bash
#
# This installs VMware Tools from VMware's own Operating System Specific
# Packages (OSP). They allow Guest Customization to modify a VM's hostname
# and static network configuration.
#
# The VMware kernel drivers are currently omitted because they are
# troublesome to build and not essential for provisioning. They could be
# subsequently managed by Puppet, if need be.
#
set -x

[ "$provider" = "vmware" ] || exit 0

cat > /etc/yum.repos.d/vmware.repo <<EOF
[wmware-tools]
name=VMWare Tools
baseurl=http://packages.vmware.com/tools/esx/5.1latest/rhel6/x86_64/
EOF

# https://bugzilla.redhat.com/show_bug.cgi?id=493777 - looks like VMWare's GPG key is *still* broken
yum -y install vmware-tools-esx-nox --nogpgcheck
