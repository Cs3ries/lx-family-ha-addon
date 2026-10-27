# Changelog

## 1.22.1-1

- Optionale Firebase-Dienstkontodatei über den Add-on-Konfigurationsordner.
- Persistenter optionaler APK-Ordner ohne Überschreiben vorhandener Dateien; Upstream-Auswahl nach versionCode bleibt unverändert.
- Add-on-Revision und Upstream-Image-Version getrennt, damit automatische Updates erhalten bleiben.
- Regressionstests vor automatischem Update-Commit und in PR-Builds.

## 1.22.1 (2026-10-26)

### Neuheiten im Original-Release (laxxx-lab/lx-family-planner):

Calendar import fixes, clearer favorites and security maintenance.

- Preview ICS files before importing. Recurrence rules, excluded/moved occurrences, categories, time zones and nested alarms are retained as series rather than duplicated historical events.
- Manage new file import groups and move a selected group into the 30-day recycle bin. Import requests are atomic and safe to retry without overwriting later edits.
- Edit imported series text, categories and LX reminders while protecting their original schedule. File exports and Nextcloud/CalDAV write sync preserve the stored series and original UID.
- Clearly explain the five navigation favorites limit in all eight interface languages.
- Update Capacitor, undici, Vite and affected transitive dependencies. npm audit reports zero known vulnerabilities at release verification.
- Include an updated, signed Android APK using the existing signing key.

Keep original ICS files. Data already lost in older imports cannot be reconstructed automatically. Reimporting a file creates additional entries; remove the old import group deliberately first. Unsupported alarm actions are preserved for export, not executed by LX. Imports are limited to 4 MB and 2,000 events/series; sub-daily recurrence is not supported.

Verified with automated API/unit tests, Chromium end-to-end tests, WebKit at exactly 440 × 956 CSS pixels and an Android build. No physical iOS device was available for verification.

#### Deutsch

Der ICS-Import zeigt vor dem Speichern eine Vorschau und erhält Serienregeln,
Ausnahmen, Kategorien, Zeitzonen und Alarme. Neue Importgruppen lassen sich
gezielt in den 30-Tage-Papierkorb verschieben. Text, Kategorie und LX-Erinnerungen
bleiben bearbeitbar; die importierte Zeitplanung wird geschützt. Export und
Nextcloud-/CalDAV-Schreibsynchronisierung erhalten die Serieninformationen.

Die Begrenzung auf fünf Navigationsfavoriten wird verständlich erklärt.
Sicherheitsabhängigkeiten und die signierte Android-App sind aktualisiert.

Bitte Originaldateien aufbewahren. Frühere verlustbehaftete Importe werden nicht
automatisch repariert oder gelöscht. Vor einem neuen Import die alte Gruppe
bewusst entfernen, um doppelte Einträge zu vermeiden. Store-Pakete sind vorbereitet;
die Aufnahme in offizielle App-Stores hängt weiterhin von deren Betreibern ab.


### Add-on Änderungen:
- Automatische Aktualisierung auf LX Family 1.22.1 aus dem Original-Repository (laxxx-lab/lx-family-planner).
- Ingress-Proxy Schicht (Nginx) und Pfad-Rewriting aktiv.


## 1.22.0 (2026-10-12)

### Neuheiten im Original-Release (laxxx-lab/lx-family-planner):

Community follow-ups for calendars, wall tablets, tasks and the pinboard.

- Personal Nextcloud calendars: assign one writable calendar per family member. Family/multi-person events use the shared calendar. Credentials stay encrypted; destination export must succeed before the old LX copy is removed. Foreign remote events are preserved.
- Wall tablets: the Tiles button works; disabled/profile-restricted modules are hidden and the selected layout persists on the device.
- Tasks: optional emoji symbols and zero-star chores, including the child dashboard.
- Pinboard: optional emojis and adult-only notes. Child, teen, pet, wall and no-profile sessions do not receive protected notes.
- School: define family lesson periods once and reuse subjects. Existing custom times remain unchanged unless a lesson is assigned to the template.
- Android: native HTTP supports proxies that strip CORS headers; server settings offer a separate proxy login window. Cosmos protection and LX family/profile authentication remain active.
- Cosmos: latest allows later release images to be fetched. Existing fixed-tag installs need one change to latest, preserving volumes and APP_SECRET. Updates remain administrator-controlled.

OIDC remains deferred. The new Android transport and proxy-login flow have automated boundary checks and a signed build; the reporter's Cosmos deployment and a physical Android login are not available for direct verification.

Calendar safety: remote entries with unknown creation provenance, including older exports, are conservatively retained when changing calendar assignment. This may leave an old remote copy, but avoids deleting someone else's original appointment.

#### Deutsch

Die Wünsche aus den Discussions sind umgesetzt: persönliche Nextcloud-Kalender,
funktionierende Kachelauswahl am Wanddisplay, Aufgaben mit Emoji und null Sternen,
geschützte Pinnwand-Notizen sowie zentrale Stundenzeiten und Fachvorschläge.

In der Android-App gibt es unter den Server-Einstellungen eine Anmeldung am
vorgeschalteten Server. Bei Cosmos zuerst dort anmelden, zu LX zurückkehren,
Verbindung prüfen und speichern. Anschließend bleibt die gewohnte LX-Anmeldung
für Familie und Profil erforderlich.

Bestehende Cosmos-Installationen einmal von einem festen Image-Tag auf latest
umstellen und das Image aktualisieren. Vorher eine Datenbanksicherung erstellen;
die vorhandenen Daten-/Backup-Volumes und APP_SECRET beibehalten. Automatische,
unbeaufsichtigte Updates werden nicht aktiviert.

OIDC bleibt zurückgestellt. Ein Test am Cosmos-Server des Meldenden und eine
Anmeldung auf einem physischen Android-Gerät konnten nicht durchgeführt werden.


### Add-on Änderungen:
- Automatische Aktualisierung auf LX Family 1.22.0 aus dem Original-Repository (laxxx-lab/lx-family-planner).
- Ingress-Proxy Schicht (Nginx) und Pfad-Rewriting aktiv.


## 1.21.4 (2026-10-02)

### Neuheiten im Original-Release (laxxx-lab/lx-family-planner):

- Vereinfachtes Chinesisch (`zh`) ist optional in der Sprachauswahl verfügbar,
  sowohl vor der Anmeldung als auch innerhalb der App.
- **Deutsch bleibt die Standardsprache** auf Server und Client. Bestehende
  Sprachpräferenzen bleiben erhalten. `APP_LANGUAGE=zh` ist nur eine freiwillige
  Einstellung für Installationen, die Chinesisch als Standard wünschen.
- Die WebDAV-Einrichtung verwendet übersetzte Beschriftungen und Meldungen.
- Enthält alle [Korrekturen aus 1.21.3](v1.21.3.md): sichere Kalenderrechte,
  bedienbare Wandansicht, lesbare Themes und übersetzte Sternefehler.
- Neue signierte Android-APK und aktualisierte Pakete für CasaOS, Cosmos,
  Umbrel und Unraid.

Danke für den chinesischen Sprachbeitrag aus PR #37. Die darin vorgeschlagene
Umstellung der Standardsprache wurde bewusst nicht übernommen.

Native Android-Meldungen benötigen weiterhin Firebase-Zugangsdaten auf dem
eigenen Server und eine aktivierte Geräteverbindung. Die Zustellung auf einem
physischen Android-Gerät wurde in dieser Runde nicht geprüft.

#### English

Adds optional Simplified Chinese while preserving German as the default on
both server and client. Saved device language choices and existing family data
are preserved. WebDAV setup is translated. Includes all calendar, wall-display,
notification activation and theme fixes from 1.21.3, with an updated signed APK
and platform packages.


### Add-on Änderungen:
- Automatische Aktualisierung auf LX Family 1.21.4 aus dem Original-Repository (laxxx-lab/lx-family-planner).
- Ingress-Proxy Schicht (Nginx) und Pfad-Rewriting aktiv.


## 1.21.2 (2026-09-18)

### Neuheiten im Original-Release (laxxx-lab/lx-family-planner):

#### Ruhiger planen, leichter bedienen

- **iPhone-Eingaben bleiben erreichbar:** Quick Add und Familie verwalten
  richten sich bei geöffneter Tastatur am sichtbaren Bildschirmbereich aus.
  Die Seite im Hintergrund springt dabei nicht mehr.
- **Essensplan nach Kalenderwochen:** Mit Vor, Zurück und „Diese Woche“ lassen
  sich Wochen getrennt planen. Bestehende Mahlzeiten bleiben in der aktuellen
  Woche sichtbar und werden beim nächsten Bearbeiten sauber zugeordnet.
- **Bring! im Hintergrund aktuell:** Verbundene Listen werden regelmäßig,
  fehlertolerant und ohne unnötige Aktualisierungen abgeglichen.
- **Deutlichere Fächerfarben:** Die ausgewählte Fachfarbe ist im Stundenplan
  schneller erkennbar, ohne die Lesbarkeit zu beeinträchtigen.

Bestehende Familieninhalte, Bring!-Verbindungen, Essenspläne und Einstellungen
bleiben erhalten.


### Add-on Änderungen:
- Automatische Aktualisierung auf LX Family 1.21.2 aus dem Original-Repository (laxxx-lab/lx-family-planner).
- Ingress-Proxy Schicht (Nginx) und Pfad-Rewriting aktiv.


## 1.21.1 (2026-09-06)

### Neuheiten im Original-Release (laxxx-lab/lx-family-planner):

#### Sicherere Verbindungen zu externen Diensten

Dieses Sicherheitsupdate schließt ein DNS-Rebinding-Risiko bei externen
Rezeptseiten. LX löst den Servernamen jetzt nur einmal auf, prüft sämtliche
gelieferten Adressen und baut die Verbindung ausschließlich zu einer dieser
geprüften Adressen auf.

Der gleiche Schutz gilt für Kalender-Feeds, WebDAV, CalDAV und Nextcloud. Bei
Weiterleitungen wird das Ziel vor dem Abruf erneut geprüft. Auch der besondere
Synology-CalDAV-Kompatibilitätsweg verwendet nun die fest geprüfte Adresse.

Bestehende Cloud- und Kalenderverbindungen müssen nicht neu eingerichtet
werden. Lokale Verbindungen, die bewusst über die vorhandenen Einstellungen
freigegeben wurden, behalten ihr bisheriges Verhalten.


### Add-on Änderungen:
- Automatische Aktualisierung auf LX Family 1.21.1 aus dem Original-Repository (laxxx-lab/lx-family-planner).
- Ingress-Proxy Schicht (Nginx) und Pfad-Rewriting aktiv.


## 1.20.3 (2026-09-04)

### Neuheiten im Original-Release (laxxx-lab/lx-family-planner):

#### Einkauf auf einen Blick
Dieser Hotfix gibt jedem typischen Einkaufsartikel ein passendes Symbol. Eier, Butter, Milch, Käse, Brot, Obst, Gemüse, Nudeln, Getränke und Haushaltsartikel sind dadurch ohne genaues Lesen besser unterscheidbar.

Die Zuordnung gilt im Katalog, in der aktiven Einkaufsliste, im Dashboard und auf der Küchenansicht. Bereits gespeicherte allgemeine Bereichssymbole werden beim Anzeigen automatisch verbessert. Bewusst vergebene eigene Symbole bleiben unverändert.

### Add-on Änderungen:
- Automatische Aktualisierung auf LX Family 1.20.3 aus dem Original-Repository (laxxx-lab/lx-family-planner).
- Ingress-Proxy Schicht (Nginx) und Pfad-Rewriting aktiv.
- Korrektur der YAML-Syntax in build.yaml für fehlerfreie Installation in Home Assistant.

## 1.20.0

- Erstes Release des Home Assistant Add-ons basierend auf LX Family 1.20.0.
- Multi-Architektur-Unterstützung für `aarch64` und `amd64`.
- Automatische Secret-Generierung und Persistenz in `/data`.
- Vollständige Integration in Home Assistant Web-UI auf Port 3001.
- Unterstützung für lokale CalDAV-Server (`CALENDAR_ALLOW_PRIVATE_HOSTS`).
- Automatische Berücksichtigung in Home Assistant Backups.
