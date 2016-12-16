#!/bin/sh

set -eu

REDUCTOR_IP="10.0.0.1"
REDUCTOR_PORT=22
LOCKFILE=/tmp/fakezone.lock
exec 3>$LOCKFILE

if ! flock -w 60 -x 3; then
	echo "Unable to capture the "$LOCKFILE
	exit 1
fi

# to scp did not ask the password you need to set up ssh-keys and throw them using ssh-copy-id on carbon reductor
scp -P $REDUCTOR_PORT root@$REDUCTOR_IP:/opt/named/reductor.db /usr/local/etc/namedb/reductor.db
scp -P $REDUCTOR_PORT root@$REDUCTOR_IP:/opt/named/reductor.conf /usr/local/etc/namedb/reductor.conf

rndc reload

flock -u 3
