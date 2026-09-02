# LX Family – Home Assistant Add-on

Dieses Repository enthält das offizielle Home Assistant Add-on für **[LX Family](https://github.com/laxxx-lab/lx-family-planner)** (ehemals *LX Family Planner*) – dem privaten Family OS für gemeinsame Termine, Aufgaben, Essensplan, Einkäufe, Chat und Kinderabenteuer.

![LX Family Logo](lx-family/logo.png)

---

## Funktionen des Add-ons

- 🚀 **Schnelle Installation:** Verwendet das offizielle Multi-Arch Docker-Image (`ghcr.io/laxxx-lab/lx-family-planner:latest`), kompatibel mit **ARM64 / aarch64** (Raspberry Pi 4/5, HA Green/Yellow) und **x86_64 / amd64** (Intel NUC, Proxmox, VMs).
- 💾 **Sichere Daten-Persistenz:** SQLite-Datenbank, Sicherungen und Secrets liegen im persistenten `/data`-Speicher von Home Assistant und werden bei Add-on-Updates nicht überschrieben.
- 🛡️ **Automatische Sicherungen:** Home Assistant Backups sichern die Familiendatenbank und Backups automatisch mit.
- 🔑 **Automatisches Secret Management:** Generiert beim ersten Start automatisch ein sicheres 48-Byte `APP_SECRET` und bewahrt es dauerhaft auf.
- 🌐 **Webinterface-Integration:** Direkter "Web-UI öffnen"-Button in Home Assistant auf Port `3001`.
- 🏠 **Home Assistant Integration:** Geräte und Entitäten aus Home Assistant können direkt in LX Family eingebunden werden (über die Elternzentrale).

---

## Installation in Home Assistant

Es gibt zwei Wege, das Add-on in Home Assistant zu installieren:

### Weg A: Als Add-on Repository (Empfohlen)

1. Lade dieses Repository auf GitHub/GitLab hoch (z. B. in deinen eigenen Account).
2. Öffne Home Assistant und navigiere zu:
   **Einstellungen** → **Add-ons** → **Add-on Store** (unten rechts).
3. Klicke oben rechts auf das Drei-Punkte-Menü (⋮) und wähle **Repositories**.
4. Füge die URL deines Repositories hinzu und klicke auf **Hinzufügen**.
5. Lade die Seite neu. Das Add-on **LX Family** erscheint in der Liste.
6. Klicke auf **LX Family** und anschließend auf **Installieren**.

---

### Weg B: Lokale Installation (Direkt auf dem Server ohne Git)

1. Verbinde dich per **Samba Share**, **SSH** oder dem **Studio Code Server Add-on** mit deinem Home Assistant.
2. Kopiere den Ordner `lx-family` aus diesem Repository direkt in das Home Assistant Verzeichnis `/addons/`:
   ```
   /addons/lx-family/
   ├── config.yaml
   ├── build.yaml
   ├── Dockerfile
   ├── run.sh
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
app_secret: ""                     # Leer lassen für automatische Generierung
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

1. Klicke auf **Starten** und aktiviere optional **Bei Systemstart ausführen** sowie **Immer neu starten**.
2. Klicke auf **Web-UI öffnen** (oder rufe `http://<HOME-ASSISTANT-IP>:3001` im Browser auf).
3. Folge dem Einrichtungsassistenten, erstelle deine Familie und lege das Master-Passwort fest.
4. Viel Freude mit eurem privaten Family OS!
