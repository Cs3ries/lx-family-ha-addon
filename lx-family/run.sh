#!/bin/sh
set -e

echo "[INFO] Starte LX Family Home Assistant Add-on..."

# Persistent data directory
mkdir -p /data/backups

# Parse options and export environment variables using Node.js
ENV_FILE="/tmp/ha_options.env"

node - << 'EOF' > "$ENV_FILE"
const fs = require('fs');
const crypto = require('crypto');

let options = {};
try {
  if (fs.existsSync('/data/options.json')) {
    options = JSON.parse(fs.readFileSync('/data/options.json', 'utf8'));
  }
} catch (err) {
  console.error('[WARN] Konnte /data/options.json nicht lesen:', err.message);
}

// Secret handling
let secret = (options.app_secret || '').trim();
const secretFile = '/data/.lx-family-app-secret';
if (!secret) {
  if (fs.existsSync(secretFile)) {
    secret = fs.readFileSync(secretFile, 'utf8').trim();
  } else {
    secret = crypto.randomBytes(48).toString('hex');
    fs.writeFileSync(secretFile, secret, { mode: 0o600 });
    console.error('[INFO] Neues dauerhaftes APP_SECRET in /data generiert.');
  }
}

const envs = {
  NODE_ENV: 'production',
  PORT: '3001',
  DATABASE_FILE: '/data/family_planner.sqlite',
  LEGACY_DATABASE_FILE: '/data/family_db.json',
  BACKUP_DIRECTORY: '/data/backups',
  APP_SECRET: secret,
  REGISTRATION_MODE: options.registration_mode || 'first-family',
  REGISTRATION_INVITE_CODE: options.registration_invite_code || '',
  PUBLIC_FAMILY_DIRECTORY: options.public_family_directory ? 'true' : 'false',
  APP_LANGUAGE: options.app_language || 'de',
  TZ: options.timezone || 'Europe/Berlin',
  CALENDAR_SYNC_INTERVAL_MINUTES: String(options.calendar_sync_interval_minutes || 60),
  EVENT_REMINDER_INTERVAL_SECONDS: String(options.event_reminder_interval_seconds || 30),
  CALENDAR_ALLOW_PRIVATE_HOSTS: options.calendar_allow_private_hosts !== false ? 'true' : 'false'
};

for (const [key, val] of Object.entries(envs)) {
  const escaped = String(val).replace(/'/g, "'\\''");
  process.stdout.write(`export ${key}='${escaped}'\n`);
}
EOF

# shellcheck disable=SC1090
. "$ENV_FILE"
rm -f "$ENV_FILE"

# Prepare permissions for node user (PUID 1000, PGID 1000)
data_uid="${PUID:-1000}"
data_gid="${PGID:-1000}"
chown -R "$data_uid:$data_gid" /data 2>/dev/null || true

# Symlink into /app/data so any internal references resolve correctly
mkdir -p /app/data
ln -sf /data/family_planner.sqlite /app/data/family_planner.sqlite 2>/dev/null || true
ln -sf /data/.lx-family-app-secret /app/data/.lx-family-app-secret 2>/dev/null || true

echo "[INFO] LX Family gestartet auf Port ${PORT} (Sprache: ${APP_LANGUAGE}, Zeitzone: ${TZ}, Registrierung: ${REGISTRATION_MODE})"

# Asynchrone Prüfung auf neuere Versionen aus dem Original-Repository
(
  latest_tag=$(curl -sL --max-time 3 "https://api.github.com/repos/laxxx-lab/lx-family-planner/releases/latest" 2>/dev/null | grep -m1 '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' || true)
  latest_ver="${latest_tag#v}"
  if [ -z "$latest_ver" ]; then
    latest_ver=$(curl -sL --max-time 3 "https://raw.githubusercontent.com/laxxx-lab/lx-family-planner/main/package.json" 2>/dev/null | grep -m1 '"version":' | sed -E 's/.*"version":[[:space:]]*"([^"]+)".*/\1/' || true)
  fi
  if [ -n "$latest_ver" ]; then
    current_ver=$(node -p "require('./package.json').version" 2>/dev/null || echo "")
    if [ -n "$current_ver" ] && [ "$latest_ver" != "$current_ver" ]; then
      echo "[HINWEIS] Ein Update für LX Family ist verfügbar: v${latest_ver} (aktuell: v${current_ver}). Aktualisiere das Add-on über Home Assistant!"
    fi
  fi
) &

if [ -x "/usr/local/bin/lx-family-entrypoint" ]; then
  exec /usr/local/bin/lx-family-entrypoint node server.js
else
  exec node server.js
fi
