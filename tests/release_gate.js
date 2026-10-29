#!/usr/bin/env node
'use strict';

// Compatibility entry point for existing local build commands. The historical
// invariant script hardcoded Gen 1-only edition/schema/package expectations;
// use the maintained v3 release/documentation gate instead.
const path=require('path');
const {spawnSync}=require('child_process');
const root=path.resolve(path.dirname(process.argv[2]||'main.lua'));
const result=spawnSync(process.execPath,[path.join(root,'tests/gen3_docs_gate.js')],
  {stdio:'inherit',cwd:root});
process.exit(result.status==null?1:result.status);
