# 🧾 MongoDB Config File – Konfigurationsoptionen & Empfehlungen

Diese Datei beschreibt die wichtigsten Optionen für eine **MongoDB-Konfigurationsdatei** (`mongod.conf`) gemäß der aktuellen MongoDB-Version (v8), inklusive **empfohlener sicherer Einstellungen**, unterstützter Werte und Hinweise zur produktiven Nutzung.

Quellen:

* [https://www.mongodb.com/docs/manual/reference/configuration-options/](https://www.mongodb.com/docs/manual/reference/configuration-options/)
* [https://www.mongodb.com/docs/manual/reference/configuration-file-settings-command-line-options-mapping/](https://www.mongodb.com/docs/manual/reference/configuration-file-settings-command-line-options-mapping/)
* [https://www.mongodb.com/docs/mongodb-shell/reference/configure-shell-settings-global/](https://www.mongodb.com/docs/mongodb-shell/reference/configure-shell-settings-global/)
* [https://github.com/kubedb/docs/blob/master/docs/guides/mongodb/configuration/using-config-file.md](https://github.com/kubedb/docs/blob/master/docs/guides/mongodb/configuration/using-config-file.md)

---

## 📄 Beispielhafte `mongod.conf`

```yaml
systemLog:
  destination: file
  path: "/var/log/mongodb/mongod.log"
  logAppend: true

storage:
  dbPath: "/var/lib/mongodb"
  journal:
    enabled: true

net:
  bindIp: 127.0.0.1
  port: 27017
  tls:
    mode: disabled

security:
  authorization: enabled

processManagement:
  fork: true
  pidFilePath: /var/run/mongodb/mongod.pid

replication:
  replSetName: rs0

setParameter:
  enableLocalhostAuthBypass: false
```

---

## ⚙️ Konfigurationsparameter (mit Erklärung und Optionen)

### 🔐 `security`

| Option              | Bedeutung                            | Werte                 | Empfehlung                       |
| ------------------- | ------------------------------------ | --------------------- | -------------------------------- |
| `authorization`     | Zugriffskontrolle aktivieren         | `enabled`, `disabled` | `enabled`                        |
| `keyFile`           | Pfad zu Keyfile für ReplSet-Auth     | Pfad zu `.key` Datei  | Für ReplSets empfohlen           |
| `enableEncryption`  | Daten-at-Rest-Verschlüsselung        | `true`, `false`       | Optional für sensible Daten      |
| `encryptionKeyFile` | Schlüsseldatei für Encrypted Storage | Pfad zu Keyfile       | Nur mit `enableEncryption: true` |

---

### 🌐 `net`

| Option                   | Beschreibung                                | Werte                                  | Empfehlung                             |
| ------------------------ | ------------------------------------------- | -------------------------------------- | -------------------------------------- |
| `bindIp`                 | IP-Adresse(n), an die MongoDB gebunden wird | `127.0.0.1`, `0.0.0.0`, IPs, Hostnamen | `127.0.0.1` (lokal), VPN/IP für extern |
| `port`                   | Listener-Port                               | Zahl (Standard: 27017)                 | Standard ok, aber Firewall setzen      |
| `tls.mode`               | TLS-Verschlüsselung                         | `disabled`, `requireTLS`, `preferTLS`  | `requireTLS` für Produktion            |
| `tls.certificateKeyFile` | TLS-Zertifikat inkl. Private Key            | Pfad zu `.pem` Datei                   | Pflicht bei `requireTLS`               |
| `tls.CAFile`             | Root-CA                                     | Pfad zur Zertifizierungsstelle         | TLS-validierung aktivieren             |

---

### 📦 `storage`

| Option                                | Bedeutung             | Werte             | Empfehlung                     |
| ------------------------------------- | --------------------- | ----------------- | ------------------------------ |
| `dbPath`                              | Datenverzeichnis      | Pfad              | `/var/lib/mongodb` oder Volume |
| `journal.enabled`                     | Journaling aktivieren | `true`, `false`   | `true` für Konsistenz          |
| `wiredTiger.engineConfig.cacheSizeGB` | RAM-Cachegröße        | Float (z. B. 1.0) | < Hälfte des Gesamtram         |

---

### 📘 `systemLog`

| Option        | Bedeutung                          | Werte            | Empfehlung                          |
| ------------- | ---------------------------------- | ---------------- | ----------------------------------- |
| `destination` | Ziel für Logs                      | `file`, `syslog` | `file` (Standard)                   |
| `path`        | Speicherort                        | Pfad             | z. B. `/var/log/mongodb/mongod.log` |
| `logAppend`   | An Log anhängen oder überschreiben | `true`, `false`  | `true`                              |

---

### 🔁 `replication`

| Option        | Bedeutung         | Werte           | Empfehlung           |
| ------------- | ----------------- | --------------- | -------------------- |
| `replSetName` | Name des ReplSets | beliebiger Name | Pflicht für ReplSets |

---

### ⚙️ `setParameter`

| Parameter                   | Bedeutung                                       | Werte           | Empfehlung                        |
| --------------------------- | ----------------------------------------------- | --------------- | --------------------------------- |
| `enableLocalhostAuthBypass` | Erlaubt Admin-Setup ohne Auth nur von localhost | `true`, `false` | `false` für produktive Umgebungen |
| `enableTestCommands`        | Aktiviert nicht-unterstützte Features           | `true`, `false` | `false` in Prod                   |

---

## 🔐 Empfehlungen für sichere Konfiguration

* Aktiviere `authorization: enabled` **immer** außerhalb von Dev-Umgebungen.
* Nutze `bindIp: 127.0.0.1` oder VPNs – **kein** öffentliches `0.0.0.0` ohne Schutz!
* Verwende `tls.mode: requireTLS` mit echten Zertifikaten für Netzwerksicherheit.
* Setze `enableLocalhostAuthBypass: false`, sobald Benutzer eingerichtet sind.
* Nutze `keyFile` oder `x.509` für Authentifizierung im Cluster.

---

## 📦 Nutzung mit Docker

```yaml
services:
  mongo:
    image: mongo:8
    container_name: mongodb
    volumes:
      - ./mongod.conf:/etc/mongo/mongod.conf:ro
    command: ["--config", "/etc/mongo/mongod.conf"]
```
