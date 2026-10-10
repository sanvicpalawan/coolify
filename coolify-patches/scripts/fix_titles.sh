#!/bin/sh
# Replace ALL visible "Coolify" strings with "Palawan Collective" inside the Coolify
# container's Blade sources, then clear compiled views so they rebuild.
# Lowercase "coolify" identifiers (paths, container names, asset files) stay untouched.

# one-time backup of the original sources (out of the container, survives updates)
if [ ! -d /root/brand-backup/views-src ]; then
  mkdir -p /root/brand-backup
  docker cp coolify:/var/www/html/resources/views /root/brand-backup/views-src
  echo "backup: ok"
fi

echo "files with Coolify: $(docker exec coolify sh -c 'grep -rl Coolify /var/www/html/resources/views | wc -l')"

docker exec coolify sh -c 'for f in $(grep -rl Coolify /var/www/html/resources/views); do sed -i "s/Coolify/Palawan Collective/g" "$f"; done'

echo "files left with Coolify: $(docker exec coolify sh -c 'grep -rl Coolify /var/www/html/resources/views | wc -l')"

docker exec coolify php artisan view:clear >/dev/null 2>&1
echo "view cache: cleared"

sleep 2
echo "login-title: $(curl -s http://127.0.0.1:8880/login | grep -o '<title>[^<]*')"
echo "visible-Coolify-hits: $(curl -s http://127.0.0.1:8880/login | grep -o '<body.*</body>' | grep -io 'coolify' | wc -l)"
