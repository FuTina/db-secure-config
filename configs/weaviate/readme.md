# 📄 Laden der Config-Datei (Weaviate mit API-Key & RBAC)

Diese Konfigurationsdatei erlaubt es, eine **sicher konfigurierte Weaviate-Instanz** lokal über Docker Compose zu starten – inklusive:

* 🔐 Authentifizierung via API-Key
* 🔐 Autorisierung via RBAC (Rollenbasiert)
* ⚙️ Unterstützung für erweiterbare Module wie `text2vec-ollama` und `generative-ollama` (optional)
* 🔄 Datenpersistenz über ein Docker Volume

---

## ✅ Voraussetzungen

Bevor du startest, stelle sicher, dass Folgendes auf deinem System installiert ist:

* **Docker** (v20+)
* **Docker Compose** (v1.29+ oder Compose v2)
* **Ollama** (optional)

---

## 📁 `.env`-Datei anlegen

Erstelle eine `.env`-Datei im gleichen Verzeichnis mit folgendem Inhalt:

```env
# Beispiel:
WEAVIATE_HOST=0.0.0.0
WEAVIATE_PORT=8080
WEAVIATE_SCHEME=http
WEAVIATE_DATA_PATH=/var/lib/weaviate
WEAVIATE_QUERY_LIMIT=25
WEAVIATE_CLUSTER_HOSTNAME=node1

# Authentifizierung / API-Keys
WEAVIATE_API_KEYS=supersecretapikey123
WEAVIATE_API_USERS=wadmin
WEAVIATE_ROOT_USERS=wadmin
```

> Du kannst mehrere API-Keys durch Komma trennen:
> `WEAVIATE_API_KEYS=key1,key2,key3`
> Und die zugehörigen User entsprechend:
> `WEAVIATE_API_USERS=user1,user2,user3`

---

## 🚀 Starten der Instanz

1. Stelle sicher, dass Docker läuft
2. Starte Weaviate mit:

```bash
docker compose up -d
```

---

## 📦 Inhalt der `docker-compose.yml`

```yaml
version: '3.9'
services:
  weaviate:
    container_name: weaviate
    image: cr.weaviate.io/semitechnologies/weaviate:1.30.3
    command:
      - --host
      - ${WEAVIATE_HOST}
      - --port
      - '${WEAVIATE_PORT}'
      - --scheme
      - ${WEAVIATE_SCHEME}
    ports:
      - "${WEAVIATE_PORT}:${WEAVIATE_PORT}"
      - "50051:50051"
    volumes:
      - weaviate_data:${WEAVIATE_DATA_PATH}
    restart: on-failure:0
    environment:
      QUERY_DEFAULTS_LIMIT: ${WEAVIATE_QUERY_LIMIT}
      PERSISTENCE_DATA_PATH: ${WEAVIATE_DATA_PATH}
      ENABLE_API_BASED_MODULES: 'true'
      CLUSTER_HOSTNAME: ${WEAVIATE_CLUSTER_HOSTNAME}

      # Authentifizierung & Autorisierung
      AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED: 'false'
      AUTHENTICATION_APIKEY_ENABLED: 'true'
      AUTHENTICATION_APIKEY_ALLOWED_KEYS: ${WEAVIATE_API_KEYS}
      AUTHENTICATION_APIKEY_USERS: ${WEAVIATE_API_USERS}
      AUTHORIZATION_ENABLE_RBAC: 'true'
      AUTHORIZATION_RBAC_ROOT_USERS: ${WEAVIATE_ROOT_USERS}

      # Aktivierte Module (optional)
      ENABLE_MODULES: 'text2vec-ollama,generative-ollama'

volumes:
  weaviate_data:
```

