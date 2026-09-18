# Changelog

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
