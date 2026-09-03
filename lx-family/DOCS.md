# Home Assistant Add-on: LX Family

**LX Family** (vormals *LX Family Planner*) ist ein privates, selbst gehostetes Family OS für gemeinsame Termine, Aufgaben, Essensplan, Einkaufsliste, Chat und Kinderabenteuer.

---

## Erste Schritte

1. **Add-on starten:** Klicke nach der Installation auf **Starten**. Aktiviere optional **In Seitenleiste anzeigen**.
2. **Web-UI / Ingress öffnen:** Klicke in der Seitenleiste auf **Familienplaner** (Ingress) oder auf **Web-UI öffnen**. Für externe Apps oder direkten LAN-Zugriff ist das Webinterface auch direkt unter `http://<DEINE-HA-IP>:3001` erreichbar.
3. **Erste Familie anlegen:** Beim ersten Aufruf wirst du durch die Ersteinrichtung geführt und legst deine Familie sowie das Master-Passwort an.
4. **Profile erstellen:** Lege Profile für Eltern, Kinder, Großeltern und ggf. Haustiere an.

---

## Konfigurationsoptionen

Unter dem Reiter **Konfiguration** können folgende Einstellungen angepasst werden:

| Option | Standard | Beschreibung |
|---|---|---|
| `app_secret` | *(leer)* | Ein mindestens 32 Zeichen langer Schlüssel zur Verschlüsselung von Sitzungen und Passwörtern. **Empfehlung:** Leer lassen – das Add-on generiert automatisch einen sicheren 48-Byte-Schlüssel in `/data/.app_secret` und bewahrt ihn dauerhaft im Add-on-Speicher auf. |
| `registration_mode` | `first-family` | Registrierungsmodus für neue Familien:<br>• `first-family`: Nur die allererste Familie darf sich registrieren, danach wird die Registrierung geschlossen.<br>• `invite`: Neue Familien benötigen einen Einladungscode (`registration_invite_code`).<br>• `closed`: Keine weiteren Registrierungen möglich.<br>• `open`: Offene Registrierung. |
| `registration_invite_code` | *(leer)* | Einladungscode, falls `registration_mode` auf `invite` steht. |
| `public_family_directory` | `false` | Zeigt Familiennamen auf der Anmeldeseite öffentlich an. Sollte im Normalfall deaktiviert bleiben. |
| `app_language` | `de` | Standardsprache der Benutzeroberfläche (`de`, `en`, `fr`, `es`, `it`, `nl`, `pl`). |
| `timezone` | `Europe/Berlin` | Zeitzone für Kalender, Wecker und Erinnerungen (z. B. `Europe/Berlin`, `Europe/Vienna`, `Europe/Zurich`). |
| `calendar_sync_interval_minutes` | `60` | Abfrageintervall für externe Kalender / ICS-Abonnements in Minuten. |
| `event_reminder_interval_seconds` | `30` | Prüfintervall für Terminerinnerungen in Sekunden. |
| `calendar_allow_private_hosts` | `true` | Erlaubt CalDAV-/Kalender-Verbindungen zu lokalen IP-Adressen im Heimnetzwerk (z. B. lokales Nextcloud oder Synology). |

---

## Daten & Sicherungen

- Alle Familiendaten (SQLite-Datenbank, Sicherungen, Einstellungen und Secrets) werden im persistenten Home Assistant Speicherbereich `/data` abgelegt.
- **Home Assistant Backups:** Wenn du in Home Assistant ein Backup (Vollsicherung oder Add-on-Sicherung) erstellst, werden alle Familiendaten automatisch mitgesichert!
- Interne Backups von LX Family werden im Unterordner `/data/backups` abgelegt und können über die **Elternzentrale** in LX Family verwaltet werden.

---

## Home Assistant Integration (Kacheln & Geräte)

LX Family kann deine Home Assistant Entitäten (Lichter, Schalter, Sensoren) direkt auf dem Familiendashboard anzeigen:

1. Öffne in Home Assistant dein **Benutzerprofil** (unten links).
2. Scrolle ganz nach unten zu **Langlebige Zugriffstoken** und erstelle ein neues Token.
3. Öffne LX Family und navigiere zu **Elternzentrale → Home Assistant**.
4. Trage die interne Adresse deines Home Assistant (z. B. `http://homeassistant.local:8123` oder die lokale IP `http://192.168.x.x:8123`) sowie das Zugriffstoken ein.
5. Wähle aus, welche Entitäten für die Familie sichtbar und schaltbar sein sollen.

---

## Mobile App & Android

LX Family verfügt über eine native Android-App (APK) sowie vollen PWA-Support (im mobilen Browser auf "Zum Startbildschirm hinzufügen" tippen).
In der Android-App trägst du einfach die Adresse `http://<DEINE-HA-IP>:3001` (bzw. deine externe Domain bei Fernzugriff) ein.

---

## Automatische Updates & Ingress-Sicherheit

Aktiviere in den Add-on-Einstellungen in Home Assistant den Schalter **"Automatische Aktualisierungen"** (Auto update).
Sobald im Original-Repository (`laxxx-lab/lx-family-planner`) eine neue Version veröffentlicht wird, aktualisiert der GitHub Actions Workflow dieses Repositories die Version, und Home Assistant führt das Update vollautomatisch durch.

Dank des integrierten Nginx Ingress Reverse Proxies werden alle Ingress-Pfade dynamisch zur Laufzeit umgeschrieben. Upstream-Codeänderungen oder neue Web-Assets funktionieren sofort und ohne manuelles Eingreifen, während deine Daten in `/data` dauerhaft sicher bleiben.
