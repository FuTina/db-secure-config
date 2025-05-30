# 🧾 MariaDB Config File – Konfigurationsoptionen & Empfehlungen (Version 11.8.1)

Diese Datei beschreibt die wichtigsten Optionen für die `my.cnf` (MariaDB 11.8.1), inklusive **sicherer Voreinstellungen**, unterstützter Werte und Empfehlungen für produktive Systeme.

**Quellen:**

* [System Variables](https://mariadb.com/kb/en/server-system-variables/)
* [Binary Logging & Replikation](https://mariadb.com/kb/en/binary-log-formats/)
* [Konfiguration `my.cnf`](https://mariadb.com/kb/en/configuring-mariadb-with-option-files/)

---

## 📄 Beispielhafte `my.cnf`

```ini
[client]
port = 3306
socket = /var/run/mysqld/mysqld.sock

[mysqld]
server_id = 1
port = 3306
basedir = /usr
datadir = /var/lib/mysql
socket = /var/run/mysqld/mysqld.sock
pid-file = /var/run/mysqld/mysqld.pid

bind_address = 127.0.0.1
skip_networking = 0
skip_name_resolve = 1
max_connections = 200

innodb_buffer_pool_size = 4G
innodb_log_file_size = 256M
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit = 1

character_set_server = utf8mb4
collation_server = utf8mb4_general_ci

log_error = /var/log/mysql/error.log
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 2
log_queries_not_using_indexes = 1
general_log = 0
general_log_file = /var/log/mysql/mysql-general.log

log_bin = /var/log/mysql/mysql-bin.log
log_bin_index = /var/log/mysql/mysql-bin.index
binlog_format = MIXED
sync_binlog = 1
expire_logs_days = 10

[mysqldump]
quick
quote-names
max_allowed_packet = 64M
```

---

## ⚙️ Wichtige Parameter & Empfehlungen

### 🔐 Sicherheit & Netzwerk

| Option              | Bedeutung                   | Empfehlung                   |
| ------------------- | --------------------------- | ---------------------------- |
| `bind_address`      | IP-Bindung                  | `127.0.0.1` oder VPN-IP      |
| `skip_networking`   | TCP/IP-Zugriff deaktivieren | `1`, falls nur lokal nötig   |
| `skip_name_resolve` | DNS-Lookups deaktivieren    | `1` zur Login-Beschleunigung |
| `max_connections`   | Maximale Clients            | 100–500 je nach Anforderung  |

---

### 💾 Speicher & Performance

| Option                           | Bedeutung              | Empfehlung                      |
| -------------------------------- | ---------------------- | ------------------------------- |
| `innodb_buffer_pool_size`        | RAM für InnoDB Caching | 50–80 % vom Server-RAM          |
| `innodb_log_file_size`           | Redo-Log-Größe         | 128–512 MB                      |
| `innodb_file_per_table`          | Separate Tablespaces   | `1` aktivieren                  |
| `innodb_flush_log_at_trx_commit` | Transaktionssicherheit | `1` (ACID), `2` bei Performance |

---

### 🌐 Zeichensätze

| Option                 | Bedeutung           | Empfehlung           |
| ---------------------- | ------------------- | -------------------- |
| `character_set_server` | Standardzeichensatz | `utf8mb4`            |
| `collation_server`     | Sortierreihenfolge  | `utf8mb4_general_ci` |

---

### 🧑‍💻 Protokollierung

| Option                          | Bedeutung                         | Empfehlung                 |
| ------------------------------- | --------------------------------- | -------------------------- |
| `log_error`                     | Fehlerprotokoll                   | Immer setzen               |
| `slow_query_log`                | Langsame Abfragen loggen          | Aktivieren                 |
| `slow_query_log_file`           | Datei für langsame Abfragen       | z. B. `/var/log/mysql/...` |
| `long_query_time`               | Schwellenwert für langsam         | 1–2 Sekunden               |
| `log_queries_not_using_indexes` | Ineffiziente Abfragen erkennen    | Aktivieren                 |
| `general_log`                   | Alle Anfragen loggen (debug only) | `0` in Produktion          |

---

### 🔁 Replikation & Binärlog

| Option             | Bedeutung                | Empfehlung             |
| ------------------ | ------------------------ | ---------------------- |
| `server_id`        | Replikations-ID          | Einzigartig je Instanz |
| `log_bin`          | Binärlog aktivieren      | Pfad setzen            |
| `log_bin_index`    | Indexdatei für Binärlogs | Pfad setzen            |
| `binlog_format`    | Binärlog-Format          | `ROW` oder `MIXED`     |
| `sync_binlog`      | Synchronisation          | `1` für ACID           |
| `expire_logs_days` | Binlog-Aufbewahrung      | 7–14 Tage              |

---

### 📦 mysqldump-Einstellungen

| Option               | Bedeutung                   | Empfehlung       |
| -------------------- | --------------------------- | ---------------- |
| `quick`              | Zeilenweiser Export         | Aktivieren       |
| `quote-names`        | Sonderzeichen in Backticks  | Aktivieren       |
| `max_allowed_packet` | Paketgröße bei großen Dumps | `64M` oder höher |

