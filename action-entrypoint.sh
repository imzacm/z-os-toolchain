#! /bin/bash

echo "$1" >> /tmp/action-script.sh
chmod +x /tmp/action-script.sh
bash /tmp/action-script.sh
status=$?
rm /tmp/action-script.sh
exit $status
