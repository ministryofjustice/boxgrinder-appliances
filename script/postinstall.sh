#!/bin/bash

set -e

[ "$1" ] || { echo "Provider type arg missing!" 1>&2; exit 2; }

export provider="$1"
shift;

[ $# -gt 0 ] || { echo "Missing dir arguments. e.g. common ubuntu" 1>&2; exit 3; }

base="$(dirname $0)"
# Take every entry in $@ (argv) and prepend our current directory to it
dirs=("${@/#/$base/}")

# Create a base file that other postinstall scripts can append to
cat >/etc/rc.local <<EOM
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
EOM

# Run parts (from any sub-directory) in order:
for f in $(find "${dirs[@]}" -name 'postinstall-[0-9]*.sh' | awk -F/ '{print $NF"/"$0}' | sort | cut -d/ -f2-)
do
  bash -x $f
done

cat >>/etc/rc.local <<EOM

exit 0
EOM

# Clean up after ourselves
rm -rf "$base"

# And, finally, truncate any and all log files
find /var/log/ -name "*log" -type f | xargs -I % sh -c "cat /dev/null >%"
[ -f /var/log/wtmp ] && cat /dev/null >/var/log/wtmp || true
[ -f /var/log/syslog ] && cat /dev/null >/var/log/syslog || true
[ -f /var/log/auth.log ] && cat /dev/null >/var/log/auth.log || true
[ -f /root/.bash_history ] && cat /dev/null >/root/.bash_history || true
