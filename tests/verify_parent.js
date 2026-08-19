#!/usr/bin/env node
'use strict';

// Optional local lineage gate. CI cannot verify an uncommitted parent ZIP, but
// ChatGPT/local release work can run:
//   node tests/verify_parent.js /path/to/Nuzlocke_<parent>.zip

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { execFileSync } = require('child_process');

const zip = process.argv[2];
if (!zip) {
  console.error('usage: node tests/verify_parent.js /path/to/parent.zip');
  process.exit(2);
}
const root = path.resolve(__dirname, '..');
const main = fs.readFileSync(path.join(root, 'main.lua'), 'utf8');
const parentVersion = (main.match(/parentVersion\s*=\s*"([^"]+)"/) || [])[1];
const parentSha = (main.match(/parentSha256\s*=\s*"([0-9a-fA-F]{64})"/) || [])[1];
if (!parentVersion || !parentSha) throw new Error('current main.lua has incomplete parent provenance');

const bytes = fs.readFileSync(zip);
const actualSha = crypto.createHash('sha256').update(bytes).digest('hex');
if (actualSha !== parentSha.toLowerCase()) {
  throw new Error(`parent SHA mismatch: expected ${parentSha}, got ${actualSha}`);
}
const manifestText = execFileSync('unzip', ['-p', zip, 'manifest.json'], { encoding: 'utf8' });
const manifest = JSON.parse(manifestText);
if (String(manifest.version) !== parentVersion) {
  throw new Error(`parent manifest version mismatch: expected ${parentVersion}, got ${manifest.version}`);
}
console.log(`PASS: parent version=${parentVersion}`);
console.log(`PASS: parent sha256=${actualSha}`);
