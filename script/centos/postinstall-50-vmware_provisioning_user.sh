#!/sh

[ "$provider" = "vmware" ] || exit 0

useradd -m -k /etc/skell -G wheel provisioning
install -d -o provisioning -g provisioning /home/provisioning/.ssh -m 0700
cat > /home/provisioning/.ssh/authorized_keys <<'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBJRpoB53BKBxvDwdniZTZHv1jmizSKaKvZkkiUiE2MTCcB4QfJeb4TpjfAzuM7fmh1EXtQEjE3OU4IFPnbUfHb38O2ySFIg7ELHA4C64xo6RAyV5SvIzWqdsfQAJI8gwviMgXqSPhaVzrhVaH21l6lsR/nGQoxePRoAlRaMPxe5DDZlR8nkCEkuLxvqtmBhvmu20KsDmuYoCqGuaDLSC9r5lmii4wdvFh/ZBrVtDGqYagfnz7mpf/IJDsAU5nBJbw5mheXi3q272UvOe86Y8SB7ErsLX9fwtgg/7i2iyOdVFRI7evTvCitS0Qybm11lVDH8I8ptIl7pWxJ/ZgIyhe9UAnfp5rWOfuWUJtik+s0COscCqdVpbMXmp/Xer6ApSTI9xBLdQm8gTwA1kyfweD/aLBsofJTxd6AARwVbUF9lzyZ9xDm3szUXyWCrJfAb6XsX0lirkmqYUzQH7r0h73XOPEtoXAXVChPXk6CVaQGKJjrQkmPVLRDXzh/ALTjb9EuFK1vWcCKW9E3j+RQMFmqV5chCT57ZWJh9Zt3fEzjIjlAFdUQDFIRnJCxmkAqEB2AVOhSIq0rWfSIgsgfAoKCclt2hPv2oIa331hdMjKLlnXSEX6dVqqFkJWdpbb1P9RQ+mDe07BlRtJ/lUi7+iUzndl3osbV78CIkM+I3jzXQ== provisioning@skyscapecloud
EOF

chown provisioning:provisioning /home/provisioning/.ssh/authorized_keys
chmod 0600 /home/provisioning/.ssh/authorized_keys

cat >> /etc/sudoers <<EOF
provisioning	ALL=(ALL)	NOPASSWD: ALL
EOF
