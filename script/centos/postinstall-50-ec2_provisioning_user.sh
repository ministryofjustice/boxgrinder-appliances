#!/sh

[ "$provider" = "ec2" ] || exit 0

useradd -m -k /etc/skell -G wheel ec2-user
install -d -o ec2-user -g ec2-user  /home/ec2-user/.ssh -m 0700

# Don't start up sshd at first boot - the user script will start it up once the provisining key is installed
chkconfig sshd off

cat > /etc/init.d/ec2-run-user-dat <<'end_of_init_script'
#!/bin/bash
#
# ec2-run-user-data Run user-data scripts, taken from http://www.linkedin.com/groups/CloudInit-49531.S.170794081
#
# chkconfig: 234 98 02
#
# description: On first boot of EC2 instance, runs user-data if it starts with #!
#
### BEGIN INIT INFO
# Provides: ec2-run-user-data
### END INIT INFO
#
# ec2-run-user-data - Run instance user-data if it looks like a script.
#
# Only retrieves and runs the user-data script once per instance. If
# you want the user-data script to run again (e.g., on the next boot)
# then add this command in the user-data script:
# rm -f /var/ec2/ec2-run-user-data.*
set -x

# Some context from the golden image creation process for this AMI

. /etc/rc.d/init.d/functions

# See how we were called.
case "$1" in
start)
echo -n "Running ec2-run-user-data: "
prog=$(basename $0)
logger="logger -t $prog"
instance_data_url=http://169.254.169.254/latest
curl="curl --retry 3 --silent --show-error --fail"

# Wait until meta-data is available.
perl -MIO::Socket::INET -e '
until(new IO::Socket::INET("169.254.169.254:80")){print"Waiting for meta-data...n";sleep 1}
' | $logger

# Exit if we have already run on this instance (e.g., previous boot).
been_run_file=/var/ec2/$prog.$ami_id
mkdir -p $(dirname $been_run_file)
if [ -f $been_run_file ]; then
  $logger < $been_run_file
  exit
fi

# Fetch some useful instance meta-data
instance_id=$($curl $instance_data_url/meta-data/instance-id)
instance_type=$($curl $instance_data_url/meta-data/instance-type)
ami_id=$($curl $instance_data_url/meta-data/ami-id)
public_hostname=$($curl $instance_data_url/meta-data/public-hostname)
kernel_id=$($curl $instance_data_url/meta-data/kernel-id)

# Append instance-runtime data to motd
cat <<EOF >> /etc/motd

$instance_id from $ami_id running $kernel_id
Public hostname: $public_hostname

EOF

# Retrieve the instance user-data and run it if it looks like a script
user_data_file=$(mktemp ec2-user-data.XXXXXXXXXX)
chmod 0700 $user_data_file

$logger "Retrieving user-data"
$curl -o $user_data_file $instance_data_url/user-data 2>&1 | $logger
$curl -o /home/ec2-user/.ssh/authorized_keys $instance_data_url/meta-data/public-keys/0/openssh-key 2>&1 | $logger

if [ "$(file -bi $user_data_file| cut -f1 -d';')" = 'application/x-gzip' ]; then
  $logger "Uncompressing gzip'd user-data"
  mv $user_data_file $user_data_file.gz
  gunzip $user_data_file.gz
fi

if [ ! -s $user_data_file ]; then
  $logger "No user-data available"
  echo "user-data was not available" > $been_run_file
elif head -1 $user_data_file | egrep -v '^#!'; then
  $logger "Skipping user-data as it does not begin with #!"
  echo "user-data did not begin with #!" > $been_run_file
else
  $logger "Running user-data"
  echo "user-data has already been run on this instance" > $been_run_file
  echo "user_data_file to be executed is $user_data_file" >> $been_run_file
  ./$user_data_file 2>&1 | logger -t "user-data"
  $logger "user-data exit code: $?"
fi

rm -f $user_data_file
hostname $hostname
chkconfig sshd on
/etc/init.d/sshd start
;;

stop)
echo "Stop isn't really implemented for ec2-run-ser-data..."
;;

status)
exit 0
;;

esac

exit 0
end_of_init_script
chmod +x /etc/init.d/ec2-run-user-dat

chkconfig ec2-run-user-data on


