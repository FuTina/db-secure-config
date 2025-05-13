import csv
import os
from dotenv import load_dotenv
import redis

# Load .env variables
load_dotenv()

host = os.getenv("REDIS_HOST", "127.0.0.1")
port = int(os.getenv("REDIS_PORT", 6379))
username = os.getenv("REDIS_APPUSER_USERNAME", "appuser")
password = os.getenv("REDIS_APPUSER_PASSWORD")

# try:
pool = redis.ConnectionPool(
    host=host,
    port=port,
    username=username,
    password=password,
    decode_responses=True
)
r = redis.Redis(connection_pool=pool)
#     print("🔁 Testing connection with PING...")
#     print("✅ Redis PING response:", r.ping())
# except redis.exceptions.ConnectionError as e:
#     print("❌ Redis connection failed:", e)
#     exit(1)
# except redis.exceptions.AuthenticationError as e:
#     print("❌ Authentication failed:", e)
#     exit(1)


print(f"🔌 Connecting to Redis at {host}:{port}...")

# Open and import users.csv
with open("users.csv", newline='', encoding="utf-8") as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        user_id = row["id"]
        r.set(f"user:{user_id}:name", row["name"])
        r.set(f"user:{user_id}:email", row["email"])
        r.set(f"user:{user_id}:score", row["score"])

print("✅ CSV import completed.")
