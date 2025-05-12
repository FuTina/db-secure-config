#!/bin/bash

APPUSER="$REDIS_APPUSER_USERNAME"

echo "Start the subscriber in Terminal A (run manually in a second window):"
echo "docker exec -it redis_secure redis-cli -u redis://$APPUSER:$REDIS_APPUSER_PASSWORD@localhost:6379"
echo "> SUBSCRIBE events"

sleep 2

echo "Sending message:"
docker exec -it redis_secure redis-cli -u "redis://$APPUSER:$REDIS_APPUSER_PASSWORD@localhost:6379" PUBLISH events "Hello from Publisher"
