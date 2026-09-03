# LX Family – Home Assistant Add-on

Dieses Repository enthält das offizielle Home Assistant Add-on für **[LX Family](https://github.com/laxxx-lab/lx-family-planner)** (ehemals *LX Family Planner*) – dem privaten Family OS für gemeinsame Termine, Aufgaben, Essensplan, Einkäufe, Chat und Kinderabenteuer.

![LX Family Logo](lx-family/logo.png)

---

## Funktionen des Add-ons

- 🚀 **Schnelle Installation:** Verwendet das offizielle Multi-Arch Docker-Image (`ghcr.io/laxxx-lab/lx-family-planner:latest`), kompatibel mit **ARM64 / aarch64** (Raspberry Pi 4/5, HA Green/Yellow) und **x86_64 / amd64** (Intel NUC, Proxmox, VMs).
- 🌐 **Nahtlose Ingress-Integration:** Erscheint als **"Familienplaner"** direkt in der Home Assistant Seitenleiste. Ein integrierter Nginx Reverse Proxy fängt Ingress-Anfragen auf Port 3001 ab und schreibt absolute Web- und API-Pfade update-sicher via `sub_filter` um.
- 📱 **Direkter Zugriff & Android-App:** Port `3001` steht weiterhin für den direkten Aufruf im lokalen Netzwerk sowie die Verbindung mit der nativen Android-App (APK) zur Verfügung.
- 💾 **Sichere Daten-Persistenz:** SQLite-Datenbank, Sicherungen und Secrets liegen im persistenten `/data`-Speicher von Home Assistant und werden bei Add-on-Updates nicht überschrieben.
- 🛡️ **Automatische Sicherungen:** Home Assistant Backups sichern die Familiendatenbank und Sicherungen automatisch mit.
- 🔑 **Automatisches Secret Management:** Generiert beim ersten Start automatisch ein sicheres 48-Byte `APP_SECRET` in `/data/.app_secret` und bewahrt es dauerhaft auf.
- 🏠 **Home Assistant Integration:** Geräte und Entitäten aus Home Assistant können direkt in LX Family eingebunden werden (über die Elternzentrale).

---

## Installation in Home Assistant

### Weg A: Als Add-on Repository (Empfohlen)

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FCs3ries%2Flx-family-ha-addon)

**1-Klick-Installation:**
Klicke einfach auf den obigen Button, um dieses Repository direkt zu deinem Home Assistant hinzuzufügen.

**Oder manuell hinzufügen:**
1. Öffne Home Assistant und navigiere zu:
   **Einstellungen** → **Add-ons** → **Add-on Store** (unten rechts).
2. Klicke oben rechts auf das Drei-Punkte-Menü (⋮) und wähle **Repositories**.
3. Füge folgende Repository-URL ein und klicke auf **Hinzufügen**:
   ```
   https://github.com/Cs3ries/lx-family-ha-addon
   ```
4. Das Repository **LX Family Add-ons** erscheint nun in deiner Liste.
5. Suche im Add-on Store nach **LX Family**, klicke darauf und wähle **Installieren**.

---

### Weg B: Lokale Installation (Manuell ohne Git)
*(Nur nötig für eigene Anpassungen, lokale Entwicklung oder Offline-Umgebungen)*

1. Verbinde dich per **Samba Share**, **SSH** oder dem **Studio Code Server Add-on** mit deinem Home Assistant.
2. Kopiere den Ordner `lx-family` aus diesem Repository direkt in das Home Assistant Verzeichnis `/addons/`:
   ```
   /addons/lx-family/
   ├── config.yaml
   ├── build.yaml
   ├── Dockerfile
   ├── run.sh
   ├── rootfs/
   │   └── etc/
   │       └── nginx/
   │           └── nginx.conf
   ├── icon.png
   ├── logo.png
   ├── DOCS.md
   └── CHANGELOG.md
   ```
3. Gehe in Home Assistant auf **Einstellungen** → **Add-ons** → **Add-on Store**.
4. Klicke oben rechts auf das Drei-Punkte-Menü (⋮) und wähle **Nach Aktualisierungen suchen**.
5. Das Add-on erscheint ganz oben im Abschnitt **Lokale Add-ons**.
6. Klicke auf **Installieren**.

---

## Konfiguration

Nach der Installation findest du unter dem Reiter **Konfiguration** folgende Optionen:

```yaml
app_secret: ""                     # Leer lassen für automatische Generierung in /data/.app_secret
registration_mode: "first-family"  # first-family, invite, open oder closed
registration_invite_code: ""       # Code bei registration_mode: invite
public_family_directory: false     # Familiennamen auf Loginseite anzeigen
app_language: "de"                 # de, en, fr, es, it, nl, pl
timezone: "Europe/Berlin"          # Deine Zeitzone
calendar_sync_interval_minutes: 60 # Synchronisationsintervall für ICS
event_reminder_interval_seconds: 30# Prüfintervall für Terminerinnerungen
calendar_allow_private_hosts: true # Zugriff auf lokale CalDAV/Nextcloud-Server im LAN
```

---

## Erste Schritte nach dem Start

1. Klicke auf **Starten** und aktiviere optional **In Seitenleiste anzeigen**, **Bei Systemstart ausführen** sowie **Immer neu starten**.
2. Öffne **Familienplaner** direkt in der linken Seitenleiste von Home Assistant (Ingress) oder klicke auf **Web-UI öffnen**.
3. Folge dem Einrichtungsassistenten, erstelle deine Familie und lege das Master-Passwort fest.
4. Viel Freude mit eurem privaten Family OS!

---

## Automatische Updates

Dieses Repository wird kontinuierlich auf dem neuesten Stand von [laxxx-lab/lx-family-planner](https://github.com/laxxx-lab/lx-family-planner) gehalten.

### Für Anwender: Automatische Updates in Home Assistant aktivieren
1. Gehe in Home Assistant auf die Add-on Detailseite von **LX Family**.
2. Aktiviere den Schalter **"Automatische Aktualisierungen"** (Auto update).
3. Home Assistant lädt und installiert neue Versionen vollautomatisch im Hintergrund, sobald sie veröffentlicht werden. Deine Familiendaten in `/data` bleiben dabei unverändert erhalten.

---

### Für Maintainer & Forks: Wie Updates funktionieren
- **Automatisierter Cron-Job (GitHub Actions):** Ein täglicher Workflow (`.github/workflows/update.yml`) prüft automatisch auf neue Releases im Original-Repository (`laxxx-lab/lx-family-planner`), testet den Multi-Arch Build inklusive Nginx Ingress Proxy Schicht und aktualisiert die Konfigurationsdateien in diesem Repository.
- **Manuelles Update-Skript:** Für lokale Entwicklungen oder manuelle Prüfungen kann jederzeit `./update.sh` im Terminal ausgeführt werden:

```bash
./update.sh
```
