#!/bin/bash

set -e  # Stop on errors

echo "🔄 Loading .env variables safely ..."
set -o allexport
source .env
set +o allexport

echo "🧩 Using username: $REDIS_ADMIN_USERNAME"
echo "🔐 Using password: $REDIS_ADMIN_PASSWORD"
# default user is disabled

if [[ -z "$REDIS_ADMIN_USERNAME" || -z "$REDIS_ADMIN_PASSWORD" ]]; then
    echo "❌ Username or password not set. Check your .env file."
    exit 1
fi

echo "🛠 Generating users.acl from template ..."
envsubst < users.acl.template > users.acl
cat users.acl

echo "🐳 Starting Redis via Docker Compose ..."
docker compose up -d


function redis_safe() {
    docker exec redis_secure redis-cli -u "redis://${REDIS_ADMIN_USERNAME}:${REDIS_ADMIN_PASSWORD}@localhost:${REDIS_PORT}" "$@" 2>/dev/null
}

echo "⏳ Waiting for Redis to become ready ..."
for i in {1..30}; do
    # Check if Redis is ready by executing a PING command
    if redis_safe PING | grep -q PONG; then
        echo "✅ Redis is ready."
        break
    fi
    echo "…waiting ($i)"
    sleep 1
done

echo "📥 Importing users_light.csv via redis-cli ..."

tail -n +2 users_light.csv | while IFS=',' read -r id name email score; do
    echo "→ Importing user ID $id: $name"
    
    redis_safe SET "user:$id:name" "$name"
    redis_safe SET "user:$id:email" "$email"
    redis_safe SET "user:$id:score" "$score"
done

echo "✅ CSV import completed."

# echo "🔒 Disabling default user for security ..."
# if redis_safe ACL SETUSER default off; then
#     echo "✅ default user successfully disabled."
# else
#     echo "❌ Failed to disable default user. Check permissions."
# fi

echo "✅ Setup complete. Redis is running at 127.0.0.1:$REDIS_PORT"
