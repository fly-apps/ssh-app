#!/usr/bin/env bash

set -euo pipefail

echo $PUBLIC_KEY > /home/${USERNAME}/.ssh/authorized_keys
chmod 644 /home/${USERNAME}/.ssh/authorized_keys

/usr/sbin/sshd -D
