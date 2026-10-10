#!/bin/sh
# Fix: quote APP_NAME so dotenv accepts the space, then rebuild config cache.
sed -i "s/^APP_NAME=Palawan Collective$/APP_NAME='Palawan Collective'/" /data/coolify/source/.env
grep -n APP_NAME /data/coolify/source/.env
c=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8880/login)
echo "first:$c"
if [ "$c" != "200" ]; then
  docker restart coolify
  sleep 25
  c2=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8880/login)
  echo "after-restart:$c2"
fi
docker exec coolify php artisan config:cache
sleep 2
c3=$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8880/login)
echo "final:$c3"
curl -s http://127.0.0.1:8880/login | grep -o '<title>[^<]*'
