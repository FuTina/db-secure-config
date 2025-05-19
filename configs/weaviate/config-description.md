# ⚙️ Weaviate Docker-Compose Konfigurationsparameter

Diese Datei beschreibt **sämtliche Konfigurationsparameter**, die innerhalb der `docker-compose.yml` für Weaviate genutzt werden können – insbesondere im Kontext von **Authentifizierung**, **Autorisierung**, **Modulen**, **Speicher** und **Netzwerk**.

Quelle: [Weaviate Docker-Compose Doku](https://weaviate.io/developers/weaviate/installation/docker-compose?docker-compose=auth)

---

## 🧾 Allgemeine Parameter (Weaviate)

| Variable                   | Beschreibung                                                                 | Beispielwert(e)                                                          |
| -------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `QUERY_DEFAULTS_LIMIT`     | Anzahl der Standard-Ergebnisse bei Abfragen                                  | `25`, `100`                                                              |
| `PERSISTENCE_DATA_PATH`    | Pfad für persistente Daten im Container                                      | `/var/lib/weaviate`                                                      |
| `CLUSTER_HOSTNAME`         | Name dieses Cluster-Knotens (für Raft intern)                                | `node1`                                                                  |
| `ENABLE_API_BASED_MODULES` | Aktiviert die Nutzung von API-basierten Modulen (z. B. OpenAI, Ollama, etc.) | `true`, `false`                                                          |
| `ENABLE_MODULES`           | Komma-separierte Liste aktivierter Module                                    | `text2vec-openai,generative-openai`, `text2vec-ollama,generative-ollama` |

---

## 🔐 Authentifizierung

| Variable                                  | Beschreibung                                            | Beispielwert                |
| ----------------------------------------- | ------------------------------------------------------- | --------------------------- |
| `AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED` | Ob anonymer Zugriff erlaubt ist                         | `false` (empfohlen), `true` |
| `AUTHENTICATION_APIKEY_ENABLED`           | API-Key-Authentifizierung aktivieren                    | `true`, `false`             |
| `AUTHENTICATION_APIKEY_ALLOWED_KEYS`      | Komma-separierte API-Keys, die gültig sind              | `supersecretkey1,key2,key3` |
| `AUTHENTICATION_APIKEY_USERS`             | Komma-separierte Benutzer, die den Keys zugeordnet sind | `admin,reader,userx`        |

> **Hinweis:** Die Reihenfolge von `ALLOWED_KEYS` und `USERS` muss identisch sein (1:1-Zuordnung).

---

## 🔓 Autorisierung (RBAC)

| Variable                        | Beschreibung                                     | Beispielwert    |
| ------------------------------- | ------------------------------------------------ | --------------- |
| `AUTHORIZATION_ENABLE_RBAC`     | Rollenbasiertes Zugriffsmodell aktivieren        | `true`, `false` |
| `AUTHORIZATION_RBAC_ROOT_USERS` | Nutzer mit vollen Adminrechten (Komma-separiert) | `admin`         |

---

## 🧠 Modulkonfigurationen (Beispiele)

> Nur erforderlich, wenn `ENABLE_MODULES` gesetzt ist. Beispiel: `text2vec-ollama`, `generative-openai` etc.

### Für Ollama (lokal)

```env
TEXT2VEC_OLLAMA_BASEURL=http://host.docker.internal:11434
TEXT2VEC_OLLAMA_MODEL=llama3
GENERATIVE_OLLAMA_BASEURL=http://host.docker.internal:11434
GENERATIVE_OLLAMA_MODEL=llama3
```

### Für OpenAI

```env
OPENAI_APIKEY=sk-abc...
TEXT2VEC_OPENAI_APIKEY=$OPENAI_APIKEY
TEXT2VEC_OPENAI_MODEL=text-embedding-ada-002
GENERATIVE_OPENAI_APIKEY=$OPENAI_APIKEY
GENERATIVE_OPENAI_MODEL=gpt-4
```

> Hinweis: Bei OpenAI-Modulen muss `ENABLE_MODULES` z. B. auf `text2vec-openai,generative-openai` gesetzt werden.

---

## 🗃️ Volumes und Pfade

| Variable                | Beschreibung                                 | Beispielwert        |
| ----------------------- | -------------------------------------------- | ------------------- |
| `PERSISTENCE_DATA_PATH` | Interner Speicherort in der Weaviate-Instanz | `/var/lib/weaviate` |
| Volume-Name (Compose)   | Name des Docker-Volumes                      | `weaviate_data:`    |

---

## 🌐 Netzwerk

| Variable          | Beschreibung                               | Beispielwert    |
| ----------------- | ------------------------------------------ | --------------- |
| `WEAVIATE_HOST`   | IP oder Host, auf dem der Dienst lauscht   | `0.0.0.0`       |
| `WEAVIATE_PORT`   | Port, auf dem Weaviate bereitgestellt wird | `8080`          |
| `WEAVIATE_SCHEME` | Protokoll                                  | `http`, `https` |

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
TEXT2VEC_OLLAMA_BASEURL=http://host.docker.internal:11434
TEXT2VEC_OLLAMA_MODEL=llama3
GENERATIVE_OLLAMA_BASEURL=http://host.docker.internal:11434
GENERATIVE_OLLAMA_MODEL=llama3
```

---

> Tipp: Verwende `docker compose --env-file .env up -d`, um alle Parameter bequem auszulagern und flexibel zu steuern.
