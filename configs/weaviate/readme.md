# 🧾 Weaviate Config – Docker Compose & Sicherheitsoptionen

Diese Datei beschreibt empfohlene **sichere Einstellungen** für die Nutzung von **Weaviate mit Docker Compose**, inklusive Konfigurationsparametern für Authentifizierung, Autorisierung, API-Module, Speicherpfade und Netzwerk.

**Quellen:**

* [Weaviate Docker Compose Docs](https://weaviate.io/developers/weaviate/installation/docker-compose?docker-compose=auth)
* [Umgebungsvariablen (env-vars)](https://weaviate.io/developers/weaviate/configuration/env-vars)
* [Auth & API-Key Login](https://weaviate.io/developers/weaviate/configuration/authentication/apikey)
* [RBAC & Autorisierung](https://weaviate.io/developers/weaviate/configuration/authorization/rbac)
* [Modulübersicht](https://weaviate.io/developers/weaviate/modules/overview)
* [OpenAI Modul](https://weaviate.io/developers/weaviate/modules/third-party/openai)
* [Ollama Modul](https://weaviate.io/developers/weaviate/modules/third-party/ollama)
* [Production Best Practices](https://weaviate.io/developers/weaviate/enterprise/production-best-practices)
* [TLS/HTTPS Setup](https://weaviate.io/developers/weaviate/guides/https-setup)
* [Logging & Monitoring](https://weaviate.io/developers/weaviate/guides/logging-monitoring)
* [Backup & Restore](https://weaviate.io/developers/weaviate/backup-restore)
* [Multi-Tenancy](https://weaviate.io/developers/weaviate/concepts/multi-tenancy)

---

## ⚙️ Beispielhafte `docker-compose.yml`

```yaml
version: '3.4'
services:
  weaviate:
    image: semitechnologies/weaviate:latest
    ports:
      - "8080:8080"
    environment:
      QUERY_DEFAULTS_LIMIT: 25
      AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED: 'false'
      AUTHENTICATION_APIKEY_ENABLED: 'true'
      AUTHENTICATION_APIKEY_ALLOWED_KEYS: 'supersecretapikey123'
      AUTHENTICATION_APIKEY_USERS: 'admin'
      AUTHORIZATION_ENABLE_RBAC: 'true'
      AUTHORIZATION_RBAC_ROOT_USERS: 'admin'
      ENABLE_API_BASED_MODULES: 'true'
      ENABLE_MODULES: 'text2vec-ollama,generative-ollama'
      TEXT2VEC_OLLAMA_BASEURL: 'http://ollama:11434'
      TEXT2VEC_OLLAMA_MODEL: 'llama3'
      GENERATIVE_OLLAMA_BASEURL: 'http://ollama:11434'
      GENERATIVE_OLLAMA_MODEL: 'llama3'
    volumes:
      - weaviate_data:/var/lib/weaviate

depends_on:
  - ollama

  ollama:
    image: ollama/ollama
    ports:
      - "11434:11434"

volumes:
  weaviate_data:
```

---

## 🔐 Sicherheitsempfehlungen

| Einstellung                               | Zweck                                | Empfehlung            |
| ----------------------------------------- | ------------------------------------ | --------------------- |
| `AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED` | Zugriff ohne Login                   | `false`               |
| `AUTHENTICATION_APIKEY_ENABLED`           | Zugriff nur mit API-Key              | `true`                |
| `AUTHORIZATION_ENABLE_RBAC`               | Rollensystem aktivieren              | `true`                |
| `AUTHORIZATION_RBAC_ROOT_USERS`           | Admin-Accounts                       | Nur gezielt angeben   |
| `ENABLE_API_BASED_MODULES`                | Fremd-APIs ermöglichen (OpenAI etc.) | Nur bei Bedarf `true` |

---

## 📄 Allgemeine Parameter

| Variable                   | Beschreibung                        | Beispielwert                        |
| -------------------------- | ----------------------------------- | ----------------------------------- |
| `QUERY_DEFAULTS_LIMIT`     | Standard-Ergebnisse bei Queries     | `25`, `100`                         |
| `PERSISTENCE_DATA_PATH`    | Datenpfad innerhalb des Containers  | `/var/lib/weaviate`                 |
| `CLUSTER_HOSTNAME`         | Hostname im Cluster (Raft)          | `node1`                             |
| `ENABLE_API_BASED_MODULES` | Nutzung von API-basierten Modulen   | `true`, `false`                     |
| `ENABLE_MODULES`           | Kommagetrennte Liste aktiver Module | `text2vec-ollama,generative-ollama` |

---

## 🧠 Modulkonfiguration (Beispiele)

### OpenAI

```env
OPENAI_APIKEY=sk-abc...
TEXT2VEC_OPENAI_APIKEY=$OPENAI_APIKEY
TEXT2VEC_OPENAI_MODEL=text-embedding-ada-002
GENERATIVE_OPENAI_APIKEY=$OPENAI_APIKEY
GENERATIVE_OPENAI_MODEL=gpt-4
```

### Ollama 

```env
TEXT2VEC_OLLAMA_BASEURL=http://ollama:11434
TEXT2VEC_OLLAMA_MODEL=llama3
GENERATIVE_OLLAMA_BASEURL=http://ollama:11434
GENERATIVE_OLLAMA_MODEL=llama3
```

---

## 🌐 Netzwerkparameter

| Variable          | Beschreibung     | Beispielwert    |
| ----------------- | ---------------- | --------------- |
| `WEAVIATE_HOST`   | IP oder Hostname | `0.0.0.0`       |
| `WEAVIATE_PORT`   | HTTP-Port        | `8080`          |
| `WEAVIATE_SCHEME` | Protokoll        | `http`, `https` |

---

## ✅ Beispiel `.env`

```env
WEAVIATE_HOST=0.0.0.0
WEAVIATE_PORT=8080
WEAVIATE_SCHEME=http
WEAVIATE_DATA_PATH=/var/lib/weaviate
WEAVIATE_QUERY_LIMIT=25
WEAVIATE_CLUSTER_HOSTNAME=node1

# Auth
WEAVIATE_API_KEYS=supersecretapikey123
WEAVIATE_API_USERS=wadmin
WEAVIATE_ROOT_USERS=wadmin

# Module
ENABLE_MODULES=text2vec-ollama,generative-ollama
TEXT2VEC_OLLAMA_BASEURL=http://ollama:11434
TEXT2VEC_OLLAMA_MODEL=llama3
GENERATIVE_OLLAMA_BASEURL=http://ollama:11434
GENERATIVE_OLLAMA_MODEL=llama3
```
