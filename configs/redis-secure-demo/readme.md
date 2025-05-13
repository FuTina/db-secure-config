
# 🔐 Redis Secure Setup with Docker Compose

Dieses Projekt zeigt ein sicheres Setup von Redis mit Docker Compose - inklusive:
- Nur lokale Verbindung
- Passwortschutz & ACLs (Benutzerrechte)
- Beispieluser mit eingeschränkten Rechten
- Volle Persistenz mit AOF
- Einfaches Starten & Testen per Skript

## ⚙️ Voraussetzungen

- **Docker** und **Docker Compose** installiert

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
└── [README.md](http://_vscodecontentref_/0)
```

## 🚀 Starten

1. Passwörter in .env setzen
Passe die Passwörter und Usernamen in der Datei .env an.
Diese Datei wird nicht ins Repository eingecheckt.

2. Redis & ACL automatisch starten
Das Skript start.sh liest die .env, generiert daraus die Datei users.acl und startet alles:

```
   ./start.sh
```
---
```

3. **Verbindung testen**  
   Mit dem App-User aus der `.env`:
```
---
```
redis-cli -u redis://$REDIS_APPUSER_USERNAME:$REDIS_APPUSER_PASSWORD@localhost:$REDIS_PORT
```

## 🔐 Benutzer und ACL

Die Datei `users.acl` wird bei jedem Start aus `users.acl.template` und den Werten aus `.env` generiert.  
Beispiel für einen User in der Template-Datei:
```
user ${REDIS_APPUSER_USERNAME} on >${REDIS_APPUSER_PASSWORD} ~app:* +@read +@write
```

Beispiel für eine vollständige users.acl.template:

---
```go
user default on >${REDIS_PASSWORD} ~* +@all
user ${REDIS_ADMIN_USERNAME} on >${REDIS_ADMIN_PASSWORD} ~* +@all
user ${REDIS_APPUSER_USERNAME} on >${REDIS_APPUSER_PASSWORD} ~app:* +@read +@write +@connection +ping +select +info +client
```
---

> **Hinweis:** Passe die Rechte und Präfixe nach Bedarf an.

## 🔑 Passwort-Management

- **Alle Passwörter werden zentral in `.env` gepflegt.**
- Die Datei `.env` ist in `.gitignore` eingetragen und wird nicht ins Repository eingecheckt.
- Die ACL-Datei wird automatisch aus der Template-Datei und den `.env`-Werten erzeugt.

## 🔁 Pub/Sub Beispiel

**Terminal A:**
---
```go
docker exec -it redis_secure redis-cli -u redis://$REDIS_APPUSER_USERNAME:$REDIS_APPUSER_PASSWORD@localhost:$REDIS_PORT
> SUBSCRIBE events
---
```
---

**Terminal B:**
---
```go
docker exec -it redis_secure redis-cli -u redis://$REDIS_APPUSER_USERNAME:$REDIS_APPUSER_PASSWORD@localhost:$REDIS_PORT
> PUBLISH events "Hello from Publisher"
---
```
---

## 🛑 Stoppen

---
```go
docker compose down
docker compose down -v  # inkl. Volume löschen
---
```
---

---

**Sicherheitshinweis:**  
Verwende für Passwörter starke, zufällig generierte Werte. Teile `.env` niemals öffentlich!

