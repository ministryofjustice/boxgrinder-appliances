#!/sh

[ "$provider" = "vmware" ] || exit 0

useradd -m -k /etc/skell -G wheel provisioning
install -d -o provisioning -g provisioning /home/provisioning/.ssh -m 0700
cat > /home/provisioning/.ssh/authorized_keys <<'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHSymXo68tIbSdloc4+25tGbocI9KYyUWTPVWDlinFncli8LOlCn7mSwspOCKeVnZIFZdXITYqO3nAAgZOVdxWsNmX8dhyCCi0I2XOsmwTvEAGL1A8rRptl7NnUVigQE91djxX3n/+cYThu/NcqR2l2bjC1e7tvek80pziTb1Mt08m0sOyivy33NtM3tkd+thi5gnOAlINtRd80c1I3urT9E/BectzL0EKqZ2sPS5Wpb+QER7ifQlmRZMj6+A7twEIHmQ0JM32z6CHYnT4JPF+hT2xhovmIreSKKnv5l9Q9SxArpGMGkNjfBktDrC/DoNqN1IoB4NzOXEqar17buIT provisioning@skyscapecloud
EOF

chown provisioning:provisioning /home/provisioning/.ssh/authorized_keys
chmod 0600 /home/provisioning/.ssh/authorized_keys

cat >> /etc/sudoers <<EOF
provisioning	ALL=(ALL)	NOPASSWD: ALL
EOF
