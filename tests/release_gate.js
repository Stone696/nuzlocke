#!/usr/bin/env node
'use strict';

// Compatibility entry point for the historical release-gate command.
// The old gate was tied to one beta version. The authoritative static gate is
// now tests/invariants.js and derives the current build/API/schema from source.

const path = require('path');
const { spawnSync } = require('child_process');

const mainArg = process.argv[2] || 'main.lua';
const root = path.dirname(path.resolve(mainArg));
const gate = path.join(__dirname, 'invariants.js');
const result = spawnSync(process.execPath, [gate, root], { stdio: 'inherit' });
process.exit(result.status == null ? 1 : result.status);
