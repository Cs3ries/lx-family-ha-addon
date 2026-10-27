# LX Family Beta – Firebase-Testversion

Version **1.22.1-beta.1**, auf Basis des unveränderten Original-Images **1.22.1**
und [PR #4](https://github.com/Cs3ries/lx-family-ha-addon/pull/4).
Dieser Beta-Kanal liegt ausschließlich auf dem Branch `beta`. Er ist eine
separate Installation mit eigenem Daten- und Konfigurationsordner.
Die stabile Installation und der Branch `main` werden nicht ersetzt.

## Direkt in Home Assistant installieren

[Beta-Repository in Home Assistant hinzufügen](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FCs3ries%2Flx-family-ha-addon%23beta)

Oder unter **Einstellungen → Add-ons / Apps → Store → ⋮ → Repositories**
diese zusätzliche Adresse eintragen (einschließlich `#beta`):

```text
https://github.com/Cs3ries/lx-family-ha-addon#beta
```

1. Das bestehende stabile Repository behalten.
2. **LX Family Beta** im Abschnitt **LX Family – Beta-Testkanal** installieren.
   Home Assistant baut das Image bei der Installation; das kann einige Minuten dauern.
3. Die Beta manuell starten, über **Web-UI öffnen** aufrufen und eine Testfamilie anlegen.
   Der automatische Start beim Hochfahren ist standardmäßig aus.
4. Für die Android-App die Beta-Adresse `http://<HA-IP>:3002` verwenden.
   Falls Port 3002 schon belegt ist, unter Netzwerk einen anderen freien Hostport wählen.
5. Den Firebase-Dienstkontoschlüssel in
   `/addon_configs/<Beta-Repository-ID>_lx_family_beta/firebase-service-account.json`
   ablegen. Dazu einen Dateizugriff verwenden, der den Add-on-Konfigurationsordner
   freigibt. Im Beta-Container lautet der Pfad `/config/firebase-service-account.json`.
6. Beta neu starten und mit einer zum Firebase-Projekt passenden Android-APK testen.
   Die Datei niemals in `apk/`, in ein Git-Repository oder in einen Fehlerbericht legen.

Ein bestehendes Familienkonto aus der stabilen Installation ist nicht automatisch
in der Beta vorhanden. Für den ersten Test eine eigene Testfamilie verwenden.
Nicht dieselbe Datenbank gleichzeitig in beiden Installationen öffnen.

## Was wird getestet?

- Optionale Firebase-Schlüsseldatei über den zugänglichen Konfigurationsordner.
- Fehlende oder ungültige Schlüssel verhindern nicht den normalen App-Start.
- Optionaler persistenter Ordner `apk/` für `latest.apk` und `version.json`.
- Getrennte Original-Image- und Add-on-Versionen.

Die offizielle APK erhält noch keine dynamische Firebase-Konfiguration. APK und
Dienstkontoschlüssel müssen aus demselben Firebase-Projekt stammen. Außerdem
wählt Upstream 1.22.1 die APK mit dem höchsten `versionCode`; die eigene APK
hat deshalb keinen garantierten Vorrang. Sie benötigt passende Release-Metadaten
in `version.json`. Siehe die [ausführliche Dokumentation](lx-family/DOCS.md).

## Beta-Updates und Rückkehr zur stabilen Version

Der automatische Upstream-Update-Workflow ist auf dem Beta-Branch entfernt.
Neue Betaversionen werden bewusst auf `beta` veröffentlicht und im Store nach
**Nach Aktualisierungen suchen** angeboten. Automatische Add-on-Updates für
diesen Test zunächst ausgeschaltet lassen. Der normale stabile Update-Kanal
bleibt davon unabhängig.

Zum Beenden des Tests die Beta stoppen und die Android-App wieder mit der
stabilen Serveradresse verbinden. Die stabile Installation muss nicht neu
installiert werden. Vor dem Löschen der Beta bei Bedarf ihre Testdaten sichern.

## Teststatus

Die Quellbasis aus PR #4 hat AMD64- und ARM64-Builds bestanden. Diese Beta
bekommt eigene Builds und Regressionstests. Ein GitHub-Pre-Release wird erst
nach erfolgreichen Beta-Builds erstellt. Ein echter Home-Assistant-/Android-
End-to-End-Test steht noch aus und ist Zweck dieser Beta.

[Beta-Builds](https://github.com/Cs3ries/lx-family-ha-addon/actions?query=branch%3Abeta)

Rückmeldungen bitte in [Issue #3](https://github.com/Cs3ries/lx-family-ha-addon/issues/3)
mit Beta-Version, Architektur und bereinigtem Log; ohne Dienstkontoschlüssel.
