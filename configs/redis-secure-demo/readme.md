
# 🔐 Sicheres Redis-Setup mit Docker Compose

Dieses Projekt zeigt ein sicheres Setup von Redis mit Docker Compose - inklusive:

* Nur lokale Verbindung (`127.0.0.1`)
* Passwortschutz & ACLs (Benutzerrechte)
* Beispielnutzer mit eingeschränkten Rechten
* Volle Persistenz mit AOF
* Einfaches Starten & Testen per Skript

## ⚙️ Voraussetzungen

* **Docker** und **Docker Compose** installiert

## 📁 Projektstruktur

---
```
redis-secure-demo/
├── docker-compose.yml
├── .env
├── users.acl.template
├── users.acl  # wird automatisch generiert
├── users_light.csv
├── users.csv # größerer Umfang, längerer Import!
├── start.sh
├── test_pub_sub.sh
└── README.md
```
---

## 🚀 Start

1. **Passwörter in `.env` setzen**  
  Erstellen und Anpassen der Environment-Variablen in bspw. `.env`, z. B.:

---
```env
REDIS_VERSION=7.2.4
REDIS_PORT=6379
REDIS_HOST=127.0.0.1
REDIS_ADMIN_USERNAME=radmin
REDIS_ADMIN_PASSWORD=SuperSecretAdminUser456
REDIS_APPUSER_USERNAME=appuser
REDIS_APPUSER_PASSWORD=SuperSecretAppUser456
```
---

2. **Start mit Skript**  
   Das Skript `start.sh` übernimmt:
   - Laden der `.env`
   - Erzeugen der `users.acl` aus der `users.acl.template`
   - Start von Redis mit Docker Compose

---
```bash
./start.sh
```
---

## 🔐 Benutzer & Rechte (ACL)

Die Datei `users.acl` wird bei jedem Start automatisch aus `users.acl.template` generiert.

Beispiel für die `users.acl.template`:

---
```acl
user default off
user ${REDIS_ADMIN_USERNAME} on >${REDIS_ADMIN_PASSWORD} ~* +@all
user ${REDIS_APPUSER_USERNAME} on >${REDIS_APPUSER_PASSWORD} ~user:* +@read +@write +@connection +ping +select +info +client
```
---

> ✏️ Die erlaubten Schlüsselbereiche (`~user:*`) und Befehle (`+@read`, etc.) können je nach Anwendung angepasst werden.

## 🐳 Docker-Konfiguration (`docker-compose.yml`)

---
```yaml
version: "3.8"

services:
  redis:
    image: redis:${REDIS_VERSION}
    container_name: redis_secure
    command: >
      redis-server 
      --bind "${REDIS_HOST}"
      --aclfile /usr/local/etc/redis/users.acl 
      --appendonly yes
      --loglevel notice
    ports:
      - "${REDIS_HOST}:${REDIS_PORT}:6379"  # 127.0.0.1
    volumes:
      - redis-data:/data
      - ./users.acl:/usr/local/etc/redis/users.acl:ro
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true

volumes:
  redis-data:
    driver: local
```
---

## 🔑 Verbindung testen

Mit dem App-User (aus `.env`):

---
```bash
redis-cli -u "redis://${REDIS_APPUSER_USERNAME}:${REDIS_APPUSER_PASSWORD}@${REDIS_HOST}:${REDIS_PORT}"
```
---

Mit dem Admin-User:

---
```bash
redis-cli -u "redis://${REDIS_ADMIN_USERNAME}:${REDIS_ADMIN_PASSWORD}@${REDIS_HOST}:${REDIS_PORT}"
```
---

## 📥 Datenimport & Struktur

Beim Start des Projekts wird `users_light.csv` automatisch importiert. Struktur:

| Redis-Schlüssel       | Inhalt                  |
|------------------------|-------------------------|
| `user:<id>:name`       | Benutzername            |
| `user:<id>:email`      | E-Mail-Adresse          |
| `user:<id>:score`      | Punktestand (Zahl)      |

### 🔄 Manuelles Setzen

---
```bash
redis-cli -u "redis://<username>:<passwort>@${REDIS_HOST}:${REDIS_PORT}" SET user:42:name "Alice Beispiel"
```
---

### 🔍 Manuelles Abfragen

---
```bash
redis-cli -u "redis://<username>:<passwort>@${REDIS_HOST}:${REDIS_PORT}" GET user:42:name
```
---

## 🔁 Pub/Sub Beispiel

**Terminal A:**

---
```bash
docker exec -it redis_secure redis-cli -u "redis://<username>:<passwort>@${REDIS_HOST}:${REDIS_PORT}"
> SUBSCRIBE events
```
---

**Terminal B:**

---
```bash
docker exec -it redis_secure redis-cli -u "redis://<username>:<passwort>@${REDIS_HOST}:${REDIS_PORT}"
> PUBLISH events "Hallo vom Publisher"
```
---

## 🛑 Stoppen

---
```bash
docker compose down
# inkl. Volumes löschen:
docker compose down -v
```
---

## 🔐 Sicherheitshinweise

- Verwende starke, zufällig generierte Passwörter (z. B. `pwgen`, `openssl rand`)
- `.env` niemals ins Repository einchecken
- Redis nur lokal oder in einem privaten Docker-Netzwerk zugänglich machen
- `user default off` verhindert ungewollte Zugriffe

