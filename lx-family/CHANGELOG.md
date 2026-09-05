# Changelog

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
