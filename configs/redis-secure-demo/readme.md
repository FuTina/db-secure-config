
# 🔐 Redis Secure Setup with Docker Compose

Dieses Projekt zeigt ein sicheres Setup von Redis mit Docker Compose – inklusive:
- Nur lokale Verbindung
- Passwortschutz & ACLs (Benutzerrechte)
- Beispieluser mit eingeschränkten Rechten
- Volle Persistenz mit AOF
- Einfaches Starten & Testen per Skript

## ⚙️ Voraussetzungen

- **Docker** und **Docker Compose** installiert
- **Python** (mind. Version 3.7) installiert und im `PATH` verfügbar  
  Prüfe mit:
  ```bash
  python --version
  ```
  > Das Startskript verwendet den Befehl `python` (nicht `python3`).  
  > Stelle sicher, dass du Python so aufrufst:
  > ```bash
  > python import.py
  > ```

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

1. **Passwörter in `.env` setzen**  
   Passe die Passwörter und Usernamen in der Datei `.env` an.  
   Diese Datei wird **nicht** ins Repository eingecheckt.

2. **Redis & ACL automatisch starten**  
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
```
user ${REDIS_APPUSER_USERNAME} on >${REDIS_APPUSER_PASSWORD} ~app:* +@read +@write
```
> **Hinweis:** Passe die Rechte und Präfixe nach Bedarf an.

## 🔑 Passwort-Management

- **Alle Passwörter werden zentral in `.env` gepflegt.**
- Die Datei `.env` ist in `.gitignore` eingetragen und wird nicht ins Repository eingecheckt.
- Die ACL-Datei wird automatisch aus der Template-Datei und den `.env`-Werten erzeugt.

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

## 🧪 Beispielimport (Python)

```bash
python import.py
```

## 🛑 Stoppen

```bash
docker compose down
docker compose down -v  # inkl. Volume löschen
```

---

**Sicherheitshinweis:**  
Verwende für Passwörter starke, zufällig generierte Werte. Teile `.env` niemals öffentlich!
