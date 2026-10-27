## Installierbare Home-Assistant-Beta

[Beta in Home Assistant hinzufügen](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FCs3ries%2Flx-family-ha-addon%23beta)

Alternativ im Add-on-/App-Store unter Repositories hinzufügen:

```text
https://github.com/Cs3ries/lx-family-ha-addon#beta
```

Danach **LX Family Beta** installieren und manuell starten. Home Assistant baut
das Image auf dem Gerät. Die Beta verwendet separate Daten und standardmäßig
Hostport **3002**. Die stabile Installation und `main` bleiben unverändert.

Enthält die optionale Firebase-Dateianbindung und APK-Persistenz aus PR #4,
basiert auf dem unveränderten Original-Image 1.22.1. Der Konfigurationsordner
lautet `/addon_configs/<Beta-Repository-ID>_lx_family_beta/`.

APK und Dienstkontoschlüssel müssen weiterhin zum selben Firebase-Projekt gehören.
Die Auswahl eigener APKs nach `versionCode` wird nicht verändert. Automatische
Updates für den Beta-Test zunächst ausgeschaltet lassen.

Die Beta-Builds für AMD64 und ARM64 sowie Regressionstests sind Voraussetzung
für dieses Pre-Release. Ein echter HA-/Android-End-to-End-Test steht noch aus.

[Installations- und Testanleitung](https://github.com/Cs3ries/lx-family-ha-addon/blob/beta/README.md)
