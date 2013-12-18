
rm /etc/ssh/ssh_host_*
touch /etc/ssh/regenerate_host_keys
cat >>/etc/rc.local <<EOM
if [ -f /etc/ssh/regenerate_host_keys ]; then
  rm -f /etc/ssh/ssh_host_*
  /usr/sbin/dpkg-reconfigure openssh-server
  rm /etc/ssh/regenerate_host_keys
fi

EOM
