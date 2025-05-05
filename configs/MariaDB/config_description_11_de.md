# MariaDB 11.8.1 Konfigurationsparameter
Diese Übersicht listet die Konfigurationsparameter für MariaDB 11.8.1 auf, mit spezifischen Hinweisen für Linux- und Windows-Umgebungen sowie Änderungen gegenüber den vorherigen Versionen.
**Offizielle Dokumentation:**
- [MariaDB Server System Variables](https://mariadb.com/kb/en/server-system-variables/)
- [Akutelle PDF-Dokumentation](https://mariadb.org/wp-content/uploads/2025/03/MariaDBServerKnowledgeBase.pdf)
- [MariaDB 11.8.1 Release Notes](https://mariadb.com/kb/en/mariadb-11-8-1-release-notes/)
- [MariaDB 11.8.1 Änderungen und Verbesserungen](https://mariadb.com/kb/en/changes-improvements-in-mariadb-11-8/)
- [MariaDB 11.7.2 Release Notes](https://mariadb.com/kb/en/mariadb-11-7-2-release-notes/)
- [MariaDB 11.4.5 Release Notes](https://mariadb.com/kb/en/mariadb-11-4-5-release-notes/)
- [MariaDB Konfiguration cnf](https://mariadb.com/kb/en/configuring-mariadb-with-option-files/)
- [Konfigurationsvariablen Server System](https://mariadb.com/kb/en/server-system-variables/) - für alle Konfigurationsvariablen!
- [Vollständige Liste von MariaDB Options, System und Status Variabeln](https://mariadb.com/kb/en/full-list-of-mariadb-options-system-and-status-variables/)
- [mariadb-dump](https://mariadb.com/kb/en/mariadb-dump/)

Es gibt keine neuen System Variablen in MariaDB 11.8.
Für MariaDB 11.7, siehe auch: https://mariadb.com/kb/en/system-variables-added-in-mariadb-11-7/

## Allgemeine Servereinstellungen (`[mysqld]`)
### 1. `server_id`
- **Beschreibung**: Eindeutige Identifikation eines Servers in einer MariaDB-Replikationstopologie. Jeder Server benötigt eine **einzigartige `server_id`**, um Konflikte zu vermeiden.  
  - **Galera Cluster**: Spezielle Regeln gelten für `server_id`, siehe [Dokumentation](https://mariadb.com/kb/en/using-mariadb-replication-with-mariadb-galera-cluster-setting-server_id-on-cluster-nodes/).  
  - **Replikation**: Bei `server_id=0` verweigert ein Primärserver Verbindungen von Replikas.  
- **Standardwert**: `1`  
- **Wertebereich**: `1` bis `4.294.967.295` (`2^32 - 1`)  
- **Dynamisch**: `Ja` (Änderung zur Laufzeit möglich)  
- **Gültigkeitsbereich**: `Global, Session`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--server-id=#`  
- **Hinweis**: Bei mehreren Instanzen auf demselben Host müssen unterschiedliche `server_id`-Werte gesetzt werden.

### 2. `port`
- **Beschreibung**: Legt den TCP/IP-Port fest, auf dem der MariaDB-Server lauscht.  
  - Falls auf `0` gesetzt, wird in folgender Reihenfolge ein Wert bestimmt: `my.cnf`, die Umgebungsvariable `MYSQL_TCP_PORT`, `/etc/services` oder der eingebaute Standard (`3306`).  
- **Standardwert**: `3306`  
- **Wertebereich**: `0` bis `65535`  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--port=#`, `-P`

### 3. `basedir`
- **Beschreibung**: Gibt das Basisverzeichnis der MariaDB-Installation an. Andere Pfade werden in der Regel relativ zu diesem Verzeichnis aufgelöst.  
- **Standardwert**:  
  - **Linux**: Abhängig vom Installationspfad, z.B. `/usr/`  
  - **Windows**: Abhängig vom Installationspfad, z.B. `C:\Program Files\MariaDB 11.8\`  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Verzeichnisname`  
- **Befehlszeilenoption**: `--basedir=Pfad`, `-b Pfad`

### 4. `datadir`
- **Beschreibung**: Verzeichnis, in dem die Datenbanken gespeichert werden.  
- **Standardwert**:  
  - **Linux**: `/var/lib/mysql/`  
  - **Windows**: `C:\Program Files\MariaDB 11.8\data\`  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Verzeichnisname`  
- **Befehlszeilenoption**: `--datadir=Pfad`, `-h Pfad`
### 5. `socket`
- **Beschreibung**:  
  - Unter **Unix-ähnlichen Systemen** ist dies der Name der Socket-Datei für lokale Client-Verbindungen. Standardmäßig `/tmp/mysql.sock`, kann je nach Distribution abweichen (z. B. `/var/lib/mysql/mysql.sock`).  
  - Unter **Windows** ist dies der Name der Named Pipe für lokale Client-Verbindungen. Standardmäßig `MySQL`. Diese Einstellung ist unter Windows **nicht** case-sensitiv.  
- **Standardwert**:  
  - **Linux**: `/tmp/mysql.sock` (oder je nach Distribution `/var/lib/mysql/mysql.sock`)  
  - **Windows**: `MySQL`  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Dateiname`  
- **Befehlszeilenoption**: `--socket=Name`

### 6. `pid-file`
- **Beschreibung**: Vollständiger Pfad zur **Prozess-ID-Datei** des MariaDB-Servers.  
  - Falls `--log-basename` ebenfalls gesetzt ist, sollte `pid-file` **danach** in den Konfigurationsdateien definiert werden.  
  - Spätere Einstellungen überschreiben frühere, daher wird `log-basename` jede vorherige Log-Dateinamenkonfiguration überschreiben.  
- **Standardwert**:  
  - **Linux**: `/var/run/mysqld/mysqld.pid`  
  - **Windows**: Nicht anwendbar  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Dateiname`  
- **Befehlszeilenoption**: `--pid-file=Dateiname`

## Netzwerk- und Verbindungsparameter
### 7. `bind_address`
- **Beschreibung**: Bestimmt, an welche IP-Adresse(n) der MariaDB-Server gebunden wird.  
  - Standardmäßig lauscht der Server auf **allen Adressen**.  
  - Eine alternative Adresse kann beim Serverstart festgelegt werden, z. B. ein **Hostname**, eine **IPv4- oder IPv6-Adresse**, `"::"` oder `"*"` (alle Adressen).  
  - Auf manchen Systemen (z. B. **Debian, Ubuntu**) ist `bind_address` standardmäßig auf `127.0.0.1` gesetzt, sodass der Server nur auf **localhost** lauscht.  
  - Seit **MariaDB 10.3.3** auch als Systemvariable verfügbar.  
  - Vor **MariaDB 10.6.0** bedeutete `"::"` auch IPv4-Unterstützung (`"*"`) – ab 10.6.0 ist `"::"` strikt nur für IPv6.  
  - Seit **MariaDB 10.11** kann eine **kommagetrennte Liste von Adressen** angegeben werden.  
  - Siehe auch [MariaDB Remote Client Access](https://mariadb.com/kb/en/configuring-mariadb-for-remote-client-access/).  
- **Standardwert**: *(Leere Zeichenkette, lauscht auf allen Adressen)*  
- **Wertebereich**: Hostname, IPv4-Adresse, IPv6-Adresse, `"::"`, `"*"`  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `String`  
- **Befehlszeilenoption**: `--bind-address=addr`  
- **Eingeführt**: **MariaDB 10.3.3** (als Systemvariable)

### 8. `skip_networking`
- **Beschreibung**: Deaktiviert TCP/IP-Verbindungen zum MariaDB-Server.  
  - Falls aktiviert (`1`), lauscht der Server **nicht** auf TCP/IP-Verbindungen.  
  - Alle Interaktionen mit dem Server erfolgen dann über **Socket-Dateien (Unix)**, **Named Pipes (Windows)** oder **Shared Memory (Windows)**.  
  - Empfohlen, wenn **nur lokale Clients** auf den Server zugreifen sollen.  
- **Standardwert**: `0` (TCP/IP ist aktiviert)  
- **Wertebereich**: `0` (TCP/IP aktiv) / `1` (nur lokale Verbindungen)  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Boolean`  
- **Befehlszeilenoption**: `--skip-networking`

### 9. `max_connections`
- **Beschreibung**: Legt die maximale Anzahl gleichzeitiger Client-Verbindungen zum MariaDB-Server fest.  
  - Hat direkten Einfluss auf die **benötigten Dateideskriptoren** des Betriebssystems.  
  - **Mindestens 10 Verbindungen erforderlich**, da ein niedrigerer Wert zu unerwarteten Problemen führen kann (**seit MDEV-18252** geändert).  
  - **Eine Verbindung ist immer für SUPER/CONNECTION ADMIN reserviert**, sodass ein Administrator sich auch dann verbinden kann, wenn das Limit erreicht ist.  
  - Kann zusätzlich auf einem separaten Port lauschen, um auch bei **maximaler Verbindungsanzahl** verfügbar zu bleiben.  
  - Siehe auch: [Handling Too Many Connections](https://mariadb.com/kb/en/handling-too-many-connections/)  
- **Standardwert**: `151`  
- **Wertebereich**: `10` bis `100000`  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--max-connections=#`

## Speicher- und Performance-Parameter
### 10. `innodb_buffer_pool_size`
- **Beschreibung**: Legt die Größe des **InnoDB-Buffer-Pools** in Bytes fest. Dies ist die wichtigste Variable für die Optimierung eines Servers, der hauptsächlich InnoDB-Tabellen verwendet.  
  - **Empfohlen:** Bis zu **80% des gesamten RAMs** für dedizierte InnoDB-Server.  
  - Siehe: [InnoDB Buffer Pool](https://mariadb.com/kb/en/innodb-buffer-pool/) für detaillierte Optimierungshinweise.  
  - Dynamische Anpassung möglich, siehe [Setting InnoDB Buffer Pool Size Dynamically](https://mariadb.com/kb/en/setting-innodb-buffer-pool-size-dynamically/).  
- **Standardwert**: `134217728` (128 MiB)  
- **Wertebereich**:  
  - **Mindestwert** (abhängig von der InnoDB-Page-Größe):  
    - `2 MiB` für `4k`  
    - `3 MiB` für `8k`  
    - `5 MiB` für `16k`  
    - `10 MiB` für `32k`  
    - `20 MiB` für `64k`  
  - **Für MariaDB-Versionen vor 10.2.42**:  
    - `5 MiB` für **Page Size ≤ 16k**  
    - `24 MiB` für **Page Size > 16k**  
  - **Maximalwert**: `9223372036854775807` (8192 PB)  
  - **Blockgröße**: `1048576`  
  - **Mindestwert für `innodb_buffer_pool_instances > 1`** (bis MariaDB 10.7): `1 GiB`  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--innodb-buffer-pool-size=#`

### 11. `innodb_log_file_size`
- **Beschreibung**: Größe (in Bytes) jeder **InnoDB Redo-Logdatei** in der Log-Gruppe.  
  - **Höhere Werte reduzieren die Anzahl der Checkpoint-Schreibvorgänge**, was zu weniger Festplatten-I/O führt.  
  - **Nachteile hoher Werte**: Längere Wiederherstellungszeit nach einem Absturz.  
  - **Seit MariaDB 10.5**: Verbesserte Absturz-Wiederherstellung, sodass größere Werte sicher verwendet werden können.  
  - **Seit MariaDB 10.9**: Dynamisch änderbar, Server-Neustart nicht mehr erforderlich.  
  - Falls das Log nicht in einem **persistenten Speicher (PMEM)** liegt, wird `SET GLOBAL innodb_log_file_size` verweigert, wenn es kleiner als `innodb_log_buffer_size` ist.  
  - **Log-Resizing kann abgebrochen werden**, indem die ausführende Verbindung beendet wird.  
- **Standardwert**:  
  - `96MB` (ab **MariaDB 10.5**)  
  - `48MB` (bis **MariaDB 10.4**)  
- **Wertebereich**:  
  - **Ab MariaDB 10.8.3**: `4MB – 512GB`  
  - **Bis MariaDB 10.8.2**: `1MB – 512GB`  
- **Blockgröße**: `4096`  
- **Dynamisch**:  
  - **Ja** (ab **MariaDB 10.9**)  
  - **Nein** (bis **MariaDB 10.8**)  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--innodb-log-file-size=#`

### 12. `innodb_file_per_table`
- **Beschreibung**: Gibt an, ob InnoDB jede Tabelle in einer eigenen `.ibd`-Datei speichert (anstatt im gemeinsamen Tablespace).  
  - **Nachteile bei OFF**: Alle Daten landen in einer Datei, was das File Management und das Shrinking erschwert.  
  - **Vorteile bei ON**:  
    - Tabellen können einzeln gelöscht und Dateien von Speicher entfernt werden.  
    - Ermöglicht separate Tablespace-Verschlüsselung.  
- **Standardwert**:  
  - `ON` (1)
- **Wertebereich**: `ON` oder `OFF`  
- **Dynamisch**:  
  - **Ja**  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Boolean`  
- **Befehlszeilenoption**: `--innodb_file_per_table=#`

### 13. `innodb_flush_log_at_trx_commit`
- **Beschreibung**: Steuert, wie häufig **InnoDB den Log-Puffer (Redo-Log)** auf die Festplatte schreibt und spiegelt den **Kompromiss zwischen Datensicherheit (ACID-Konformität) und Systemleistung** wieder.  
  - **Vorteile bei 1**: Maximale Datensicherheit und ACID-Konformität, empfohlen für produktive Umgebungen und Replikation.  
  - **Nachteile bei 1**: Höhere I/O-Belastung.  
  - **Vorteile bei 2**: Bessere Leistung bei akzeptablen Risiko, geeignet für Anwendungen, bei denen gelegentlicher Datenverlust tolerierbar ist.  
  - **Nachteile bei 2**: Möglichkeit des Datenverlusts bei Systemabsturz, nicht vollständig ACID-konform.  
  - **Vorteile bei 0**: Maximale Leistung.  
  - **Nachteile bei 0**: Hohes Risiko von Datenverlust, nicht für produktive Systeme empfohlen.  
- **Standardwert**:  
  - `1` 
- **Wertebereich**:  
  - `0-3`  
- **Blockgröße**: `4096`  
- **Dynamisch**:  
  - **Ja**  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--innodb_flush_log_at_trx_commit=#`


## **Character Set und Collation**
### 14. `character_set_server`
- **Beschreibung**: Bestimmt den **Standardzeichensatz** des MariaDB-Servers. Dieser wird als Voreinstellung für neu erstellte Datenbanken und Tabellen verwendet, sofern kein spezifischer Zeichensatz angegeben wird.  
- **Standardwert**:  
  - **Ab MariaDB 11.6.0**: `utf8mb4`  
  - **Bis einschließlich MariaDB 11.5**: `latin1`  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global, Session`  
- **Datentyp**: `Zeichenkette`  
- **Befehlszeilenoption**: `--character-set-server`  
- **Hinweis**:  
  - Der Standardwert kann je nach System variieren.  
  - Es wird empfohlen, den Zeichensatz entsprechend den Anforderungen der Anwendung anzupassen.  
- **Weitere Informationen**: [MariaDB Server System Variables](https://mariadb.com/kb/en/server-system-variables/)

### 13. `collation_server`
- **Beschreibung**: Bestimmt die **Standard-Kollation** des Servers, welche definiert, wie Zeichenfolgen sortiert und verglichen werden.  
  - Wird **automatisch gesetzt**, wenn `character_set_server` geändert wird, kann jedoch auch **manuell** angepasst werden.  
  - Standardwerte können auf verschiedenen Systemen abweichen, siehe z. B. [Unterschiede in MariaDB in Debian](https://mariadb.com/kb/en/differences-in-mariadb-in-debian/).  
- **Standardwert**: `latin1_swedish_ci`  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global, Session`  
- **Datentyp**: `Zeichenkette`  
- **Befehlszeilenoption**: `--collation-server=name`

## **Protokollierung und Fehlersuche**
### 15. `log_error`
- **Beschreibung**: Legt den Namen der **Fehlerprotokolldatei** fest.  
  - Falls `--console` (nur Windows) später in der Konfiguration angegeben wird oder `--log-error` nicht gesetzt ist, werden Fehler standardmäßig an `stderr` ausgegeben.  
  - Wenn kein Name angegeben wird, werden Fehler weiterhin unter `hostname.err` im `datadir` gespeichert.  
  - Falls eine Konfigurationsdatei `--log-error` setzt, kann dies mit `--skip-log-error` überschrieben werden (nützlich, um systemweite Konfigurationen zu übersteuern).  
  - MariaDB schreibt immer ein **Fehlerprotokoll**, jedoch ist das **Ziel konfigurierbar** (siehe [Error Log](https://mariadb.com/kb/en/error-log/)).  
  - Falls `--log-basename` ebenfalls gesetzt ist, sollte `log_error` danach in der Konfiguration definiert werden, da spätere Einstellungen frühere überschreiben.  
- **Standardwert**: *(leere Zeichenkette, schreibt in `hostname.err` im `datadir`)*  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Dateiname`  
- **Befehlszeilenoption**: `--log-error[=name]`, `--skip-log-error`

### 16. `slow_query_log`
- **Beschreibung**: Aktiviert oder deaktiviert das **Protokollieren langsamer Abfragen**.  
  - Falls `0` (Standardwert, außer `--slow-query-log` ist gesetzt), bleibt das **Slow Query Log deaktiviert**.  
  - Falls `1`, werden langsame Abfragen protokolliert.  
  - **Seit MariaDB 10.11.0**: `slow_query_log` ist ein Alias für `log_slow_query`.  
  - Siehe auch [`log_output`](https://mariadb.com/kb/en/log-output/), da keine Logs geschrieben werden, wenn diese Variable auf `NONE` gesetzt ist – selbst wenn `slow_query_log=1`.  
- **Standardwert**: `0` (deaktiviert)  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global, Session`  
- **Datentyp**: `Boolean`  
- **Befehlszeilenoption**: `--slow-query-log`

### 17. `slow_query_log_file`
- **Beschreibung**: Legt den **Namen der Slow Query Log-Datei** fest.  
  - **Seit MariaDB 10.11** ist `slow_query_log_file` ein Alias für `log_slow_query_file`.  
  - Falls `--log-basename` ebenfalls gesetzt ist, sollte `slow_query_log_file` danach in der Konfiguration definiert werden, da spätere Einstellungen frühere überschreiben.  
- **Standardwert**: `host_name-slow.log`  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Dateiname`  
- **Befehlszeilenoption**: `--slow-query-log-file=file_name`

### 18. `long_query_time`
- **Beschreibung**: Legt die **Mindestdauer (in Sekunden) fest**, ab der eine Abfrage als **langsam** gilt.  
  - Falls eine Abfrage länger als dieser Wert dauert, wird die **Statusvariable `Slow_queries` erhöht**.  
  - Falls das **Slow Query Log aktiviert** ist, wird die Abfrage dort protokolliert.  
  - **Seit MariaDB 10.11.0** ist `long_query_time` ein Alias für `log_slow_query_time`.  
  - Der Wert kann mit **Mikrosekunden-Präzision** angegeben werden.  
- **Standardwert**: `10.000000` Sekunden  
- **Wertebereich**: `0` und höher  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global, Session`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--long-query-time=#`

### 19. `log_queries_not_using_indexes`
- **Beschreibung**: Steuert, ob alle **SQL-Abfragen, die keine Indexe verwenden** unabhängig von ihrer Ausführungszeit, im **Slow Query Log** protokolliert werden.  
  - Vorteile: Hilft dabei, Abfragen zu identifizieren, die durch fehlende Indexnutzung ineffizient sind.  
  - Nachteile: Log-Größe - kann zu einem sehr umfangreichen Slow Query Log führen.  
- **Standardwert**: `OFF`   
- **Wertebereich**: `ON` oder `OFF`  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Boolean`  
- **Befehlszeilenoption**: `--log_queries_not_using_indexes`

### 20. `general_log`
- **Beschreibung**: Aktiviert oder deaktiviert das **General Query Log**, welches **alle SQL-Abfragen** protokolliert, die an den Server gesendet werden.  
  - Falls `0` (Standardwert, außer `--general-log` ist gesetzt), bleibt das **General Query Log deaktiviert**.  
  - Falls `1`, werden **alle SQL-Anfragen** protokolliert.  
  - Siehe auch [`log_output`](https://mariadb.com/kb/en/log-output/), da keine Logs geschrieben werden, wenn diese Variable auf `NONE` gesetzt ist – selbst wenn `general_log=1`.  
- **Standardwert**: `0` (deaktiviert)  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Boolean`  
- **Befehlszeilenoption**: `--general-log`

### 21. `general_log_file`
- **Beschreibung**: Legt den **Namen der General Query Log-Datei** fest.  
  - Falls kein Name angegeben ist, wird der Name aus **`log-basename`** übernommen oder standardmäßig auf **`host_name.log`** gesetzt.  
  - Falls `--log-basename` ebenfalls gesetzt ist, sollte `general_log_file` danach in der Konfiguration definiert werden, da spätere Einstellungen frühere überschreiben.  
- **Standardwert**: `host_name.log`  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Dateiname`  
- **Befehlszeilenoption**: `--general-log-file=file_name`

### 22. `log_slow_filter`
- **Beschreibung**: Ermöglicht das **Filtern von Abfragen**, die in das **Slow Query Log** geschrieben werden.  
  - **Abfragen werden nur geloggt**, wenn sie mindestens **so lange dauern wie `long_query_time`**, **außer `not_using_index`**, das unabhängig von der Abfragezeit protokolliert wird.  
  - Aktiviert automatisch **`log_slow_admin_statements=ON`**.  
  - Siehe auch [`log_slow_disabled_statements`](https://mariadb.com/kb/en/log_slow_disabled_statements/).  
- **Standardwert**:  
  - `admin, filesort, filesort_on_disk, filesort_priority_queue, full_join, full_scan, query_cache, query_cache_miss, tmp_table, tmp_table_on_disk`  
- **Gültige Werte**:  
  - **`admin`** → Administrative Abfragen (`CREATE`, `OPTIMIZE`, `DROP` etc.)  
  - **`filesort`** → Abfragen, die `ORDER BY` mit Filesort nutzen  
  - **`filesort_on_disk`** → Abfragen, die Filesort **auf der Festplatte** durchführen  
  - **`filesort_priority_queue`** → Sortierung mit Prioritätswarteschlange  
  - **`full_join`** → Joins ohne Index  
  - **`full_scan`** → Vollständige Tabellenscans  
  - **`not_using_index`** → Abfragen ohne Index oder mit vollem Index-Scan (unabhängig von `long_query_time`)  
  - **`query_cache`** → Abfragen, die aus dem Query Cache bedient werden  
  - **`query_cache_miss`** → Abfragen, die nicht im Query Cache gefunden wurden  
  - **`tmp_table`** → Abfragen, die eine **temporäre Tabelle** erstellen  
  - **`tmp_table_on_disk`** → Abfragen, die eine **temporäre Tabelle auf Festplatte** erstellen  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global, Session`  
- **Datentyp**: `Enumeration (kommagetrennte Liste)`  
- **Befehlszeilenoption**: `--log-slow-filter=value1[,value2...]`

### 23. `log_bin`
- **Beschreibung**: Aktiviert oder deaktiviert das **binäre Logging** für Replikation und Wiederherstellung.  
  - Falls `--log-bin` gesetzt ist, wird `log_bin=ON`, andernfalls bleibt es `OFF`.  
  - Falls kein Name angegeben ist, wird das **Binärlog unter einem Standardpfad gespeichert**:  
    - Falls `--log-basename` gesetzt ist → `datadir/'log-basename'-bin`  
    - Falls `--log-basename` nicht gesetzt ist → `datadir/mysql-bin`  
  - Es wird **empfohlen**, `--log-basename` oder einen **eindeutigen Namen** zu setzen, um zu verhindern, dass die Replikation bei einer Hostnamensänderung fehlschlägt.  
  - Der Name kann optional eine **absolute Pfadangabe enthalten**. Falls kein Pfad angegeben wird, wird das **Binärlog im Datenverzeichnis gespeichert**.  
  - Falls der Name eine Dateiendung enthält, wird diese entfernt und nur der Basisname verwendet.  
- **Standardwert**: `OFF`  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Boolean`  
- **Befehlszeilenoption**: `--log-bin[=name]`  
- **Verwandte Variablen**: `sql_log_bin`

### 24. `log_bin_index`
- **Beschreibung**: Speichert die **Liste der Binärlog-Dateien**, die vom Server erstellt wurden.  
  - Falls `--log-basename` ebenfalls gesetzt ist, sollte `log_bin_index` **danach** in der Konfigurationsdatei definiert werden.  
  - Spätere Einstellungen überschreiben frühere, daher wird `log-basename` jede vorherige Logdateinameneinstellung überschreiben.  
- **Standardwert**: `None` (kein Standardwert)  
- **Dynamisch**: `Nein`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `String`  
- **Befehlszeilenoption**: `--log-bin-index=name`

### 25. `binlog_format`
- **Beschreibung**: Bestimmt das **Format des Binärlogs**, das für Replikation verwendet wird.  
  - **Verfügbare Formate**:  
    - `ROW`: Speichert Änderungen **auf Zeilenebene**.  
    - `STATEMENT`: Speichert **SQL-Anweisungen**.  
    - `MIXED`: Kombination aus **`ROW` und `STATEMENT`**.  
  - **Standardwerte je nach Version**:  
    - **Ab MariaDB 10.2.4**: `MIXED`  
    - **Bis MariaDB 10.2.3**: `STATEMENT`  
  - **Achtung bei Änderungen**: Falls eine Replikation bereits aktiv ist, sollte das Binärlog-Format **nicht während des Betriebs geändert werden**, um Inkonsistenzen zu vermeiden.  
  - Seit **MariaDB 10.0.22** wird `binlog_format` **nur auf normale (nicht replizierte) Updates angewendet**. Replikas übernehmen **jedes Event vom Primärserver**, unabhängig vom Binärlog-Format.  
  - Siehe auch: [Binary Log Formats](https://mariadb.com/kb/en/binary-log-formats/)  
- **Standardwert**:  
  - `MIXED` (ab **MariaDB 10.2.4**)  
  - `STATEMENT` (bis **MariaDB 10.2.3**)  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global, Session`  
- **Datentyp**: `Enumeration`  
- **Befehlszeilenoption**: `--binlog-format=format`  
- **Gültige Werte**: `ROW`, `STATEMENT`, `MIXED`

### 26. `sync_binlog`
- **Beschreibung**: Steuert, wie oft MariaDB das **Binärlog auf die Festplatte synchronisiert**.  
  - **Standardwert `0`**: Das Betriebssystem verwaltet das Schreiben auf die Festplatte.  
  - **Wert `1`**: Sicherste Option – das Binärlog wird **nach jeder Transaktion** synchronisiert.  
  - **Höhere Werte (`>1`)**: Bessere Performance, aber höheres Risiko eines Datenverlusts bei einem Absturz.  
  - Falls **`autocommit` aktiviert ist** → eine Synchronisierung pro **Anweisung**.  
  - Falls **`autocommit` deaktiviert ist** → eine Synchronisierung pro **Transaktion**.  
  - Falls die **Festplatte über einen Batterie-gesicherten Cache verfügt**, kann ein höherer Wert gewählt werden, da Synchronisierung schneller erfolgt.  
- **Standardwert**: `0` (OS-gesteuertes Schreiben)  
- **Wertebereich**: `0` bis `4.294.967.295` (`2^32 - 1`)  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--sync-binlog=#`

### 27. `expire_logs_days`
- **Beschreibung**: Gibt an, **nach wie vielen Tagen** Binärlog-Dateien **automatisch entfernt** werden.  
  - Standardmäßig `0` → **keine automatische Entfernung**.  
  - Sollte bei **Replikation** immer höher gesetzt werden als der maximale Lag eines Replikas.  
  - Entfernung erfolgt in folgenden Fällen:  
    - Beim Serverstart  
    - Wenn das Binärlog **manuell oder automatisch geflusht** wird  
    - Wenn eine neue Binärlog-Datei erstellt wird, weil die vorherige ihre maximale Größe erreicht hat  
    - Wenn `PURGE BINARY LOGS` ausgeführt wird  
  - Bis **MariaDB 10.6.0**: Wert in **ganzen Tagen (Integer)**.  
  - Ab **MariaDB 10.6.1**: Wert mit **1/1.000.000 Präzision (Double)**.  
  - Seit **MariaDB 10.6.1**: `expire_logs_days` und `binlog_expire_logs_seconds` sind **gegenseitig verknüpfte Aliase** – eine Änderung an einer Variable ändert automatisch die andere.  
- **Standardwert**:  
  - `0.000000` (ab **MariaDB 10.6.1**)  
  - `0` (bis **MariaDB 10.6.0**)  
- **Wertebereich**: `0` bis `99`  
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--expire-logs-days=#`


## **mysqldump-Optionen**
### 28. `quick` (Kommandozeilen-Option)
- **Beschreibung**: Aktiviert den **zeilenweisen Datenabruf** während des Dumps.  
  - Anstatt alle Daten einer Tabelle in den Speicher zu laden, liest mysqldump die Daten Zeile für Zeile direkt vom Server.  
  - **Vorteile**: Reduziert den Speicherverbrauch auf dem Client, insbesondere bei großen Tabellen und vermeidet mögliche Speicherprobleme bei begrenztem RAM.  
  - **Nachteile**: Kann die Dump-Geschwindigkeit bei kleinen Tabellen leicht verringern.  
  - **standardmäßig** aktiviert
- **Befehlszeilenoption**: `--quick`  
- **Deaktivierung**: `--skip-quick` 

### 29. `max_allowed_packet`
- **Beschreibung**: Legt die maximale Größe (in Bytes) eines Pakets fest, das der Client (hier mysqldump) vom Server empfangen oder an ihn senden kann.  
  - Dies ist besonders relevant beim Export großer BLOBs oder langer Insert-Anweisungen.  
  - **Vorteile**: Ermöglicht den Export großer Tabellen mit umfangreichen Datenfeldern.  
  - **Nachteile**: Ein zu hoher Wert kann zu erhöhtem Speicherverbrauch führen. 
  - Der Wert muss sowohl auf dem Client als auch auf dem Server entsprechend konfiguriert sein, um Fehler zu vermeiden.  
- **Standardwert**:  
  - `64M`  
- **Wertebereich**: `1024` bis `1G`  
- **Dynamisch**: `Ja` (Global), `Nein` (Session)  
- **Gültigkeitsbereich**: `Global, Session`  
- **Datentyp**: `Numerisch`  
- **Befehlszeilenoption**: `--max_allowed_packet=#` 

### 30. `quote-names` (Kommandozeilen-Option)
- **Beschreibung**: veranlasst mysqldump, **Bezeichner** wie Datenbank-, Tabellen- und Spaltennamen in **Backticks** (`) einzuschließen.  
  - Dies ist besonders nützlich, wenn Bezeichnet **reservierte Schlüsselwörter** oder **Sonderzeichen** enthalten.  
  - Standardmäßig aktiviert  
- **Standardwert**:  
  - `1`
- **Dynamisch**: `Ja`  
- **Gültigkeitsbereich**: `Global`  
- **Datentyp**: `Boolean`  
- **Befehlszeilenoption**: `--quote-names`/ `-Q`  
- **Deaktivierung**: `--skip-quote-names`.



