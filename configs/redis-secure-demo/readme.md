
# 🔐 Redis Secure Setup with Docker Compose

Dieses Projekt zeigt ein sicheres Setup von Redis mit Docker Compose - inklusive:

* Nur lokale Verbindung
* Passwortschutz & ACLs (Benutzerrechte)
* Beispieluser mit eingeschränkten Rechten
* Volle Persistenz mit AOF
* Einfaches Starten & Testen per Skript

## ⚙️ Voraussetzungen

* **Docker** und **Docker Compose** installiert

## 📁 Struktur

```
redis-secure-demo/
├── docker-compose.yml
├── .env
├── users.acl.template
├── users.acl  # wird automatisch generiert
├── import.py
├── test_pub_sub.sh
├── start.sh
└── README.md
```

## 🚀 Starten

1. Passwörter in .env setzen
   Passe die Passwörter und Usernamen in der Datei `.env` an. Diese Datei wird nicht ins Repository eingecheckt.

2. Redis & ACL automatisch starten
   Das Skript `start.sh` liest die `.env`, generiert daraus die Datei `users.acl` und startet alles:

```bash
./start.sh
```

3. **Verbindung testen**
   Mit dem App-User aus der `.env`:

```bash
redis-cli -u redis://$REDIS_APPUSER_USERNAME:$REDIS_APPUSER_PASSWORD@localhost:$REDIS_PORT
```

## 🔐 Benutzer und ACL

Die Datei `users.acl` wird bei jedem Start aus `users.acl.template` und den Werten aus `.env` generiert.
Beispiel für einen User in der Template-Datei:

```bash
user ${REDIS_APPUSER_USERNAME} on >${REDIS_APPUSER_PASSWORD} ~app:* +@read +@write
```

Beispiel für eine vollständige users.acl.template:

```bash
user default on >${REDIS_PASSWORD} ~* +@all
user ${REDIS_ADMIN_USERNAME} on >${REDIS_ADMIN_PASSWORD} ~* +@all
user ${REDIS_APPUSER_USERNAME} on >${REDIS_APPUSER_PASSWORD} ~user:* +@read +@write +@connection +ping +select +info +client
```

> **Hinweis:** Passe die Rechte und Präfixe nach Bedarf an.

## 🔑 Passwort-Management

* **Alle Passwörter werden zentral in `.env` gepflegt.**
* Die Datei `.env` ist in `.gitignore` eingetragen und wird nicht ins Repository eingecheckt.
* Die ACL-Datei wird automatisch aus der Template-Datei und den `.env`-Werten erzeugt.

## 🗃️ Benutzer-Datenstruktur & Import

Beim Start des Projekts wird `users_light.csv` automatisch importiert. Die Nutzerdaten werden in folgendem Format gespeichert:

* `user:<id>:name` → Benutzername (Vor- und Nachname)
* `user:<id>:email` → E-Mail-Adresse
* `user:<id>:score` → Punktestand (integer)

### 🔄 Manuelles Setzen von Daten

```bash
redis-cli -u redis://<username>:<password>@127.0.0.1:6379 SET user:42:name "Alice Example"
redis-cli -u redis://<username>:<password>@127.0.0.1:6379 SET user:42:email "alice@example.com"
redis-cli -u redis://<username>:<password>@127.0.0.1:6379 SET user:42:score 555
```

### 🔍 Manuelles Abfragen von Daten

```bash
redis-cli -u redis://<username>:<password>@127.0.0.1:6379 GET user:42:name
redis-cli -u redis://<username>:<password>@127.0.0.1:6379 GET user:42:email
redis-cli -u redis://<username>:<password>@127.0.0.1:6379 GET user:42:score
```

> 🔐 Hinweis: Bei aktivierter ACL ist `username` + `password` erforderlich.

## 🔁 Pub/Sub Beispiel

**Terminal A:**

```bash
docker exec -it redis_secure redis-cli -u redis://$REDIS_APPUSER_USERNAME:$REDIS_APPUSER_PASSWORD@localhost:$REDIS_PORT
> SUBSCRIBE events
```

**Terminal B:**

```bash
docker exec -it redis_secure redis-cli -u redis://$REDIS_APPUSER_USERNAME:$REDIS_APPUSER_PASSWORD@localhost:$REDIS_PORT
> PUBLISH events "Hello from Publisher"
```

## 🛑 Stoppen

```bash
docker compose down
# inkl. Volume löschen:
docker compose down -v
```

---

**Sicherheitshinweis:**
Verwende für Passwörter starke, zufällig generierte Werte. Teile `.env` niemals öffentlich!

