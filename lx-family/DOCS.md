# Home Assistant Add-on: LX Family Beta

**LX Family** (vormals *LX Family Planner*) ist ein privates, selbst gehostetes Family OS für gemeinsame Termine, Aufgaben, Essensplan, Einkaufsliste, Chat und Kinderabenteuer.

---

## Erste Schritte

1. **Add-on starten:** Klicke nach der Installation auf **Starten**. Aktiviere optional **In Seitenleiste anzeigen**.
2. **Web-UI / Ingress öffnen:** Klicke in der Seitenleiste auf **Familienplaner** (Ingress) oder auf **Web-UI öffnen**. Für externe Apps oder direkten LAN-Zugriff ist das Webinterface auch direkt unter `http://<DEINE-HA-IP>:3002` erreichbar.
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
In der Android-App trägst du einfach die Adresse `http://<DEINE-HA-IP>:3002` (bzw. deine externe Domain bei Fernzugriff) ein.

---

## Beta-Kanal

Dies ist eine separate Beta mit eigenen Daten. Die Installation läuft standardmäßig
auf Hostport **3002**, die stabile Version weiterhin auf 3001. Automatischer Start
ist standardmäßig deaktiviert. Beta-Updates werden manuell auf dem Branch `beta`
veröffentlicht; der automatische Upstream-Update-Workflow ist hier entfernt.
Für den Test automatische Aktualisierungen ausgeschaltet lassen.

## Optional: Firebase für Android-Push

Lege `firebase-service-account.json` im Add-on-Konfigurationsordner
`/addon_configs/<Beta-Repository-ID>_lx_family_beta/` ab (im Container: `/config`).
Nutze einen Dateizugriff, der diesen Ordner freigibt, z. B. entsprechend
konfiguriertes Samba oder Studio Code Server. Danach das Add-on neu starten.
Der Schlüssel muss für den Backend-Prozess lesbar sein; nicht öffentlich
freigeben, nicht ins Repository hochladen und niemals unter `apk/` ablegen.
Die Datei wird lokal auf Dienstkonto-Felder und einen RSA-Schlüssel geprüft.
Das prüft nicht die Berechtigungen oder Erreichbarkeit bei Google. Fehler werden
ohne Schlüsselinhalte gemeldet; die optionale Anbindung wird dann übersprungen.
Ohne Datei bleibt die bisherige Konfiguration erhalten.

APK und Dienstkontoschlüssel müssen aus demselben Firebase-Projekt stammen.
Für ein eigenes Projekt ist derzeit eine passend gebaute APK erforderlich.
Diese Änderung konfiguriert die offizielle APK nicht dynamisch.

Optional kann eine eigene `apk/latest.apk` samt passender `apk/version.json`
im selben Konfigurationsordner abgelegt werden. Beim nächsten Start wird der
Ordner nur eingebunden, wenn `latest.apk` vorhanden und `/app/data/apk` frei
ist. Vorhandene Dateien oder fremde Links werden nicht ersetzt. Bei einem
Konflikt erscheint eine Warnung. Zum Deaktivieren den eigenen APK-Ordner aus
dem Konfigurationsordner verschieben und das Add-on neu starten.
Wichtig: Upstream 1.22.1 wählt aus allen APKs die höchste `versionCode`
(bei Gleichstand die neueste Datei). Der eigene Ordner hat keinen garantierten
Vorrang. `version.json` muss `buildKind: "release"` und passende Metadaten
enthalten. Ein neueres Original-Image kann wieder die offizielle APK anbieten.
Die Persistenz ist daher keine Lösung für automatische Updates eigener APKs;
dafür ist die dynamische Firebase-Konfiguration im Hauptprojekt erforderlich.
Eigene APKs müssen selbst aktuell gehalten und mit demselben Android-Schlüssel
signiert werden. Ein automatisches Server-Update baut keine eigene APK.

Die Dateien im Konfigurationsordner bleiben über Image-Updates erhalten.
Vor dem ersten produktiven Update ein HA-Backup erstellen und prüfen, dass
auch der Add-on-Konfigurationsordner enthalten und wiederherstellbar ist.
Interne Datenbank-Backups von LX ersetzen keine Sicherung dieser Dateien.

## Versionierung für Maintainer

`build.yaml` bestimmt die unveränderte Upstream-Image-Version. `config.yaml`
kann zusätzlich eine Add-on-Revision tragen, etwa `1.22.1-1`. Beide Update-Wege
vergleichen die neue Originalversion mit `build.yaml`, damit eine reine
Add-on-Revision erhalten bleibt. Bei einem neuen Originalrelease werden beide
Versionen auf dessen Versionsnummer gesetzt. Build CI liest ebenfalls
`build.yaml`, nicht den Add-on-Revisionssuffix.

Vor Freigabe auf einem separaten HA-Testsystem: Installation ohne Schlüssel,
Push mit passender APK/Schlüssel, Ingress und direkter Zugriff, Neustart,
Update und Wiederherstellung der persistenten Dateien prüfen. CI prüft die
lokale Anbindung und Update-Logik, nicht Google-Zustellung oder HA selbst.
