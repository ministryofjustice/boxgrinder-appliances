#!/bin/sh

set -e

export provider=$1

[ "$provider" ] || { echo "Provider type arg missing!" 1>&2; exit 2; }

base=$(dirname $0)

# Run parts (from any sub-directory) in order:
for f in $(find $base -wholename '*/postinstall-[0-9]*.sh' | awk -F/ '{print $NF"/"$0}' | sort | cut -d/ -f2-)
do
  bash -x $f
done

exit

yum clean all

# And, finally, truncate any and all log files
find /var/log/ -name "*log" -type f | xargs -I % sh -c "cat /dev/null >%"
[ -f /var/log/wtmp ] && cat /dev/null >/var/log/wtmp || true
[ -f /var/log/syslog ] && cat /dev/null >/var/log/syslog || true
[ -f /var/log/auth.log ] && cat /dev/null >/var/log/auth.log || true
[ -f /root/.bash_history ] && cat /dev/null >/root/.bash_history || true
