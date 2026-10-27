const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { execFileSync } = require('node:child_process');
const { generateKeyPairSync } = require('node:crypto');
const { configureFirebase, configureApk } = require('../lx-family/addon-support.cjs');
const root = path.resolve(__dirname, '..');
function fixture(t) {
 const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'lx-addon-'));
 t.after(() => fs.rmSync(dir, { recursive: true, force: true }));
 return dir;
}
test('Firebase absent, malformed and valid; no credential logging', t => {
 const dir = fixture(t), file = path.join(dir, 'firebase-service-account.json'), logs = [];
 assert.deepEqual(configureFirebase(dir, s => logs.push(s)), {});
 for (const content of ['SECRET-BROKEN-JSON', 'null', '{}', JSON.stringify({type:'service_account',project_id:'demo',client_email:'test@example.com',private_key:'SECRET'})]) {
  fs.writeFileSync(file, content);
  assert.deepEqual(configureFirebase(dir, s => logs.push(s)), {});
 }
 const { privateKey } = generateKeyPairSync('rsa', { modulusLength: 2048 });
 fs.writeFileSync(file, JSON.stringify({type:'service_account', project_id:'demo', client_email:'test@example.com', private_key:privateKey.export({type:'pkcs8',format:'pem'})}));
 assert.deepEqual(configureFirebase(dir), {FIREBASE_SERVICE_ACCOUNT_FILE:file});
 assert.equal(logs.length, 4);
 assert.ok(!logs.join('').includes('SECRET'));
});
test('APK opt-in, idempotence and persistence after image directory replacement', t => {
 const dir = fixture(t), config = path.join(dir,'config'), data = path.join(dir,'image/data');
 fs.mkdirSync(path.join(config,'apk'), {recursive:true});
 configureApk(config,data);
 assert.ok(!fs.existsSync(data));
 fs.writeFileSync(path.join(config,'apk/latest.apk'),'user-apk');
 fs.writeFileSync(path.join(config,'apk/version.json'),'{"versionCode":1}');
 configureApk(config,data); configureApk(config,data);
 assert.equal(fs.readFileSync(path.join(data,'apk/latest.apk'),'utf8'),'user-apk');
 fs.rmSync(path.dirname(data), {recursive:true});
 configureApk(config,data);
 assert.equal(fs.readFileSync(path.join(data,'apk/latest.apk'),'utf8'),'user-apk');
 assert.ok(fs.existsSync(path.join(data,'apk/version.json')));
});
test('APK never replaces existing data or foreign links', t => {
 const dir = fixture(t), config = path.join(dir,'config'), data = path.join(dir,'data');
 fs.mkdirSync(path.join(config,'apk'),{recursive:true});
 fs.writeFileSync(path.join(config,'apk/latest.apk'),'custom');
 fs.mkdirSync(path.join(data,'apk'),{recursive:true});
 fs.writeFileSync(path.join(data,'apk/keep'),'original');
 configureApk(config,data,()=>{});
 assert.equal(fs.readFileSync(path.join(data,'apk/keep'),'utf8'),'original');
 fs.rmSync(path.join(data,'apk'),{recursive:true});
 fs.symlinkSync('/missing/foreign',path.join(data,'apk'));
 configureApk(config,data,()=>{});
 assert.equal(fs.readlinkSync(path.join(data,'apk')),'/missing/foreign');
});
function updateFixture(t) {
 const dir = fixture(t);
 for (const file of ['update.sh','scripts/upstream-version.sh','lx-family/build.yaml','lx-family/config.yaml','lx-family/run.sh','lx-family/addon-support.cjs']) {
  fs.mkdirSync(path.dirname(path.join(dir,file)),{recursive:true});
  fs.copyFileSync(path.join(root,file),path.join(dir,file));
 }
 fs.writeFileSync(path.join(dir,'lx-family/CHANGELOG.md'),'# Changelog\n');
 fs.mkdirSync(path.join(dir,'bin'));
 fs.writeFileSync(path.join(dir,'bin/curl'),'#!/bin/sh\nprintf \'{"tag_name":"%s","body":""}\\n\' "$TEST_RELEASE"\n',{mode:0o755});
 return dir;
}
function update(dir, release) { return execFileSync('bash',['update.sh'],{cwd:dir,env:{...process.env,PATH:path.join(dir,'bin')+':'+process.env.PATH,TEST_RELEASE:release},stdio:'pipe'}); }
test('same upstream release preserves add-on revision; new release preserves integration', t => {
 const dir=updateFixture(t);
 const current=execFileSync('bash',['scripts/upstream-version.sh'],{cwd:dir,encoding:'utf8'}).trim();
 const config=path.join(dir,'lx-family/config.yaml');
 fs.writeFileSync(config,fs.readFileSync(config,'utf8').replace(/^version:.*$/m,`version: "${current}-99"`));
 const before=fs.readFileSync(config,'utf8');
 update(dir,'v'+current); assert.equal(fs.readFileSync(config,'utf8'),before);
 const run=fs.readFileSync(path.join(dir,'lx-family/run.sh'),'utf8');
 update(dir,'v99.0.0');
 assert.match(fs.readFileSync(config,'utf8'),/version: "99.0.0"/);
 assert.match(fs.readFileSync(config,'utf8'),/addon_config:rw/);
 assert.equal(fs.readFileSync(path.join(dir,'lx-family/run.sh'),'utf8'),run);
 assert.equal(execFileSync('bash',['scripts/upstream-version.sh'],{cwd:dir,encoding:'utf8'}).trim(),'99.0.0');
});
test('invalid release and mismatched image versions fail without updating config', t => {
 const dir=updateFixture(t), config=path.join(dir,'lx-family/config.yaml'), before=fs.readFileSync(config,'utf8');
 assert.throws(()=>update(dir,'vbad;value'));
 assert.equal(fs.readFileSync(config,'utf8'),before);
 const build=path.join(dir,'lx-family/build.yaml');
 fs.writeFileSync(build,fs.readFileSync(build,'utf8').replace(/planner:[0-9.]+/,'planner:98.0.0'));
 assert.throws(()=>update(dir,'v99.0.0'));
 assert.equal(fs.readFileSync(config,'utf8'),before);
});
