#!/sh

[ "$provider" = "vmware" ] || exit 0

useradd -m -k /etc/skell -G wheel provisioning
install -d -o provisioning -g provisioning /home/provisioning/.ssh -m 0700
