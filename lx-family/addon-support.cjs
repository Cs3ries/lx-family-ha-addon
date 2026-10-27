// Optional HA integration only; upstream application files remain untouched.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const warn = message => console.error(`[WARN] ${message}`);

function configureFirebase(configDir, log = warn) {
  const file = path.join(configDir, 'firebase-service-account.json');
  if (!fs.existsSync(file)) return {};
  try {
    const credentials = JSON.parse(fs.readFileSync(file, 'utf8'));
    if (credentials?.type !== 'service_account' ||
        typeof credentials.project_id !== 'string' || !credentials.project_id.trim() ||
        typeof credentials.client_email !== 'string' || !credentials.client_email.includes('@') ||
        typeof credentials.private_key !== 'string') throw new Error();
    const key = crypto.createPrivateKey(credentials.private_key);
    if (key.asymmetricKeyType !== 'rsa') throw new Error();
    return { FIREBASE_SERVICE_ACCOUNT_FILE: file };
  } catch {
    // Never include parser errors: they can contain credential contents.
    log('Firebase-Datei fehlt die gültige Dienstkonto-Struktur oder ist nicht lesbar. Optionale Anbindung übersprungen.');
    return {};
  }
}

function configureApk(configDir, appData, log = warn) {
  const source = path.join(configDir, 'apk');
  const target = path.join(appData, 'apk');
  try {
    // Explicit opt-in: a directory alone must not override the bundled APK.
    if (!fs.statSync(path.join(source, 'latest.apk'), { throwIfNoEntry: false })?.isFile()) return;
    const existing = fs.lstatSync(target, { throwIfNoEntry: false });
    if (existing) {
      if (existing.isSymbolicLink() && fs.readlinkSync(target) === source) return;
      log('Eigene APK nicht eingebunden: /app/data/apk existiert bereits. Keine Dateien überschrieben.');
      return;
    }
    fs.mkdirSync(appData, { recursive: true });
    fs.symlinkSync(source, target, 'dir');
  } catch {
    log('Optionaler APK-Ordner konnte nicht eingebunden werden. Keine Dateien gelöscht.');
  }
}
module.exports = { configureFirebase, configureApk };
