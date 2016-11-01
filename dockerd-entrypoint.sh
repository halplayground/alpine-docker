#!/bin/sh
set -e

#clean pid after unexpected kill
if [ -f "/var/run/docker.pid" ]; then
		rm -rf /var/run/docker.pid
fi

# Add docker daemon as command if needed
if [[ "$1" != 'docker' ]]; then
	docker daemon \
			--host=unix:///var/run/docker.sock \
			--host=tcp://$HOSTNAME:2375 1>/dev/null &
fi

# set docker settings
echo "export DOCKER_HOST='tcp://$HOSTNAME:2375'" >> /etc/profile
# reread all config
source /etc/profile

exec "$@"
