#!/bin/bash

set -e  # Stop on errors

echo "🔄 Loading .env variables safely ..."
set -o allexport
source .env
set +o allexport

echo "🧩 Using username: $REDIS_APPUSER_USERNAME"
echo "🔐 Using password: $REDIS_APPUSER_PASSWORD"

if [[ -z "$REDIS_APPUSER_USERNAME" || -z "$REDIS_APPUSER_PASSWORD" ]]; then
  echo "❌ Username or password not set. Check your .env file."
  exit 1
fi

echo "🛠 Generating users.acl from template ..."
envsubst < users.acl.template > users.acl
cat users.acl

echo "🐳 Starting Redis via Docker Compose ..."
docker compose up -d

echo "⏳ Waiting for Redis to become ready ..."
for i in {1..30}; do
    # Check if Redis is ready by executing a PING command
    if docker exec redis_secure redis-cli -u "redis://${REDIS_APPUSER_USERNAME}:${REDIS_APPUSER_PASSWORD}@localhost:${REDIS_PORT}" PING | grep -q PONG; then
        echo "✅ Redis is ready."
        break
    fi
    echo "…waiting ($i)"
    sleep 1
done

echo "📥 Starting data import via import.py ..."
python import.py

echo "✅ Setup complete. Redis is running at 127.0.0.1:$REDIS_PORT"
