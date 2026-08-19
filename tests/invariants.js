#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');

const root = path.resolve(process.argv[2] || '.');
let passed = 0;
let warned = 0;
const strict = process.env.NUZLOCKE_STRICT === '1';

function read(rel) {
  return fs.readFileSync(path.join(root, rel), 'utf8');
}
function exists(rel) {
  return fs.existsSync(path.join(root, rel));
}
function pass(message) {
  passed += 1;
  console.log(`PASS: ${message}`);
}
function check(condition, message) {
  if (!condition) throw new Error(`FAIL: ${message}`);
  pass(message);
}
function warn(condition, message) {
  if (condition) return pass(message);
  warned += 1;
  const prefix = strict ? 'FAIL' : 'WARN';
  console.log(`${prefix}: ${message}`);
  if (strict) throw new Error(`FAIL: ${message}`);
}
function matchOne(text, re) {
  const m = text.match(re);
  return m && m[1];
}
function semverDev(version) {
  const m = String(version || '').match(/^(\d+)\.(\d+)\.(\d+)-DEV$/);
  return m && { major: +m[1], minor: +m[2], patch: +m[3] };
}

const releaseFiles = [
  'CHANGELOG.md',
  'README.md',
  'RELEASE_NOTES.md',
  'docs/API.md',
  'docs/COMPATIBILITY.md',
  'docs/DOCUMENTATION_CHANGELOG.md',
  'docs/FEATURE_CONFIDENCE.md',
  'docs/USER_GUIDE.md',
  'main.lua',
  'manifest.json',
  'mod.card',
  'modern_ui_integration.lua',
  'pokegear_integration.lua',
  'title_setup_compat.lua',
  'trainer_rewards.lua',
];

for (const rel of releaseFiles) check(exists(rel), `release file exists: ${rel}`);
check(releaseFiles.length === 15, 'canonical player package contains exactly 15 approved paths');

const main = read('main.lua');
const manifest = JSON.parse(read('manifest.json'));
const readme = read('README.md');
const changelog = read('CHANGELOG.md');
const notes = read('RELEASE_NOTES.md');
const apiDoc = read('docs/API.md');
const compatDoc = read('docs/COMPATIBILITY.md');
const docChange = read('docs/DOCUMENTATION_CHANGELOG.md');
const featureConfidence = read('docs/FEATURE_CONFIDENCE.md');
const userGuide = read('docs/USER_GUIDE.md');
const trainerRewards = read('trainer_rewards.lua');
const modernUi = read('modern_ui_integration.lua');

check(manifest.api === 2, 'Gen1Recomp Mod API remains 2');
check(JSON.stringify(manifest.games) === JSON.stringify(['red', 'blue', 'yellow', 'gold']),
  'game targets are exactly Red/Blue/Yellow/Gold');
check(manifest.game_version === '>=0.1.86 <2.0.0',
  'manifest engine range matches the project contract');

const build = matchOne(main, /mod\.exports\.__beta26\s*=\s*\{[\s\S]*?build\s*=\s*"([^"]+)"/);
check(Boolean(build), 'main.lua exports a build identifier');
const manifestVersion = String(manifest.version || '');
check(build === manifestVersion, `main build (${build}) matches manifest version (${manifestVersion})`);
check(main.startsWith(`-- Nuzlocke ${manifestVersion}\n`), 'main.lua header matches manifest version');

for (const [name, text] of [
  ['README', readme], ['CHANGELOG', changelog], ['RELEASE_NOTES', notes],
  ['API', apiDoc], ['COMPATIBILITY', compatDoc],
  ['DOCUMENTATION_CHANGELOG', docChange], ['FEATURE_CONFIDENCE', featureConfidence],
  ['USER_GUIDE', userGuide],
]) {
  check(text.includes(manifestVersion), `${name} mentions the current build/version`);
}

const schema = Number(matchOne(main, /local\s+CURRENT_SAVE_SCHEMA\s*=\s*(\d+)/));
check(schema === 4, 'Save Schema remains 4');
check(main.includes('__nuzlocke_save_schema'), 'save schema key is explicit');
check(main.includes('saveSchemaTooNew'), 'newer-schema safe-stop state exists');
check(main.includes('SaveSchemaDescriptor'), 'Save Schema descriptor exists');
check(main.includes('complete_gameplay_state = false'),
  'Save Schema descriptor does not overclaim complete gameplay-state coverage');
for (const key of ['nuzlocke_rule_revision', 'no_catching_migrated_2934',
  'no_catching_migration_reviewed_29313', 'route_split_rules_migrated',
  'route_forgiveness_initialized', 'nuzlocke_provenance_initialized']) {
  check(main.includes(`${key} = { value_type =`),
    `Save Schema descriptor covers migration bookkeeping ${key}`);
}
check(main.includes('role = "migration_bookkeeping"'),
  'Save Schema descriptor assigns the migration_bookkeeping role');
check(main.includes('total_field_count =')
    && main.includes('configuration_count =')
    && main.includes('migration_bookkeeping_count ='),
  'Save Schema audit reports explicit per-role and total field counts');

const compatVersion = Number(matchOne(main, /compatibilityApi\s*=\s*(\d+)/));
check(Number.isInteger(compatVersion) && compatVersion >= 1,
  'Nuzlocke Compatibility API version is explicit');
check(/mod\.exports\.nuzlocke_compat\s*=\s*\{[\s\S]*?version\s*=\s*mod\.exports\.__beta26\.compatibilityApi/.test(main),
  'public compatibility export uses the canonical Compatibility API constant');
if (main.includes('capability_versions') || main.includes('getCapabilityVersion')) {
  check(compatVersion >= 28,
    'public per-capability contract negotiation is versioned as Compatibility API 28+');
}
check(apiDoc.includes(`Compatibility API is **${compatVersion}**`),
  'API.md current contract matches Compatibility API version');
check(apiDoc.includes(`- ` + '`version = ' + compatVersion + '`'),
  'API.md Core exports version matches the current Compatibility API');
check(apiDoc.includes('- `audited_recomp = "0.2.7"`'),
  'API.md Core exports audited Gen1Recomp marker is current');
check(compatDoc.includes(`Compatibility API is **${compatVersion}**`),
  'COMPATIBILITY.md current contract matches Compatibility API version');

const diagnosticsVersion = Number(matchOne(main, /diagnosticsApi\s*=\s*(\d+)/));
check(diagnosticsVersion === 1, 'Diagnostics API remains 1');
check(main.includes('mod.exports.__beta26.Dev.selfTest'), 'Dev SELF TEST exists');

const parentVersion = matchOne(main, /parentVersion\s*=\s*"([^"]+)"/);
const parentSha = matchOne(main, /parentSha256\s*=\s*"([0-9a-fA-F]{64})"/);
check(Boolean(parentVersion), 'build provenance includes parent version');
check(Boolean(parentSha), 'build provenance includes a 64-hex parent SHA-256');
check(main.includes('buildProvenance'), 'machine-readable build provenance exists');
const currentSemver = semverDev(manifestVersion);
const parentSemver = semverDev(parentVersion);
if (currentSemver && parentSemver
    && currentSemver.major === parentSemver.major
    && currentSemver.minor === parentSemver.minor) {
  check(parentSemver.patch + 1 === currentSemver.patch,
    'DEV build provenance names the immediately previous patch child');
} else {
  warn(false, 'DEV parent-version sequence could not be mechanically verified');
}

const ruleStart = main.indexOf('local ruleCategories =');
const ruleEnd = main.indexOf('local function ruleDescriptionForDisplay', ruleStart);
check(ruleStart >= 0 && ruleEnd > ruleStart, 'rule registry/menu source block is discoverable');
const ruleBlock = main.slice(ruleStart, ruleEnd);
const ruleKeys = [...ruleBlock.matchAll(/\{\s*key\s*=\s*"([^"]+)"/g)].map(m => m[1]);
check(ruleKeys.length > 0, 'registered rule rows are discoverable');
check(new Set(ruleKeys).size === ruleKeys.length, 'registered rule keys are unique');
check(main.includes('local function defaultRuleValue(key)'), 'one canonical default resolver exists');
check(main.includes('local RuleRegistry = {}') && main.includes('RuleRegistry.audit'),
  'machine-readable Rule Registry exists and has an audit');
check(main.includes('collisions[#collisions + 1]')
    && main.includes('collision_count = #collisions'),
  'Rule Registry records construction collisions before audit');
check(main.includes('local SaveSchemaDescriptor = {}') && main.includes('SaveSchemaDescriptor.audit'),
  'machine-readable Save Schema descriptor exists and has an audit');
for (const key of ['hardcore_mode', 'elite_four_caps']) {
  const marker = `fields.${key} = {`;
  const at = main.indexOf(marker);
  const block = at >= 0 ? main.slice(at, at + 420) : '';
  check(at >= 0 && block.includes('role = "compatibility_mirror"'),
    `Save Schema descriptor declares ${key} as a compatibility mirror`);
}
for (const key of ['solo_active', 'no_shopping', 'ball_use_ban_tier', 'route_splits']) {
  check(main.includes(`${key} = {`) && main.includes('role = "legacy_migration_input"'),
    `Save Schema descriptor covers legacy migration input ${key}`);
}

check(main.includes('local function compatPublicCopy(value, seen)'),
  'Compatibility API has a recursive defensive-copy helper');
check(main.includes('capabilities = compatPublicCopy(COMPAT_CAPABILITIES)')
    && main.includes('engine_compat = compatPublicCopy(mod.exports.__beta26.compat.Engine)')
    && main.includes('mod_compat = compatPublicCopy(mod.exports.__beta26.compat.Mods)'),
  'public compatibility metadata is detached from internal tables');
check(!main.includes('supported = mod.exports.__beta26.compat.Mods.supported_relationships')
    && !main.includes('defaults = mod.exports.__beta26.compat.Mods.defaults'),
  'public relationship metadata does not directly alias internal resolver tables');
check(main.includes('capability_versions = compatPublicCopy('),
  'DEV SELF TEST does not expose the live capability-version table');
check(main.includes('engine = compatPublicCopy(mod.exports.__beta26.compat.Engine)'),
  'Compatibility report returns a defensive engine snapshot');
check(main.includes('refreshPublicCompatSnapshots()')
    && /engineState\.item_use[\s\S]{0,260}refreshPublicCompatSnapshots\(\)/.test(main),
  'engine_compat refreshes after Item Policy engine-state updates');
check(main.includes('if fallback == nil and type(defaultRuleValue) == "function" then'),
  'getEffectiveRuleValue uses canonical defaults when no fallback is supplied');

// Battle/save writers use one of two explicit policies. PASSIVE_PROGRESS may
// synchronize supported-save game progress while the Nuzlocke master switch is
// OFF; RULE_ENFORCEMENT must stop when the challenge is OFF and whenever a
// newer unsupported schema makes Nuzlocke persistence read-only.
check(main.includes('mod.exports.__beta26.canWriteNuzlockeSave = function(game)')
    && main.includes('mod.exports.__beta26.isNuzlockeEnabled = function()')
    && main.includes('mod.exports.__beta26.shouldEnforceNuzlocke = function(game, battle)'),
  'write-safety, master-switch, and rule-enforcement policies are explicit');
check(/active = function\(game, battle\)[\s\S]{0,180}shouldEnforceNuzlocke\(game, battle\)/.test(main),
  'historical active() delegates to RULE_ENFORCEMENT policy');
check(main.includes('add("battle_write_policy"'),
  'DEV SELF TEST reports persistence/enforcement policy health');

// High-signal ratchet for the split trainer-reward module: any exported
// function that directly writes Nuzlocke persistence or rewrites the live
// wallet must visibly choose a persistence/enforcement policy. This is broader
// than the named regression checks below, so a new writer cannot silently join
// the module without a guard.
const trainerFunctionStarts = [...trainerRewards.matchAll(/^function M\.([A-Za-z0-9_]+)\([^\n]*\)/gm)]
  .map(m => ({ name: m[1], index: m.index }));
const unclassifiedTrainerWriters = [];
for (let i = 0; i < trainerFunctionStarts.length; i += 1) {
  const here = trainerFunctionStarts[i];
  const end = i + 1 < trainerFunctionStarts.length
    ? trainerFunctionStarts[i + 1].index : trainerRewards.length;
  const body = trainerRewards.slice(here.index, end);
  const writes = body.includes('mod.save:set(') || body.includes('setTrainerWalletValue(');
  if (!writes) continue;
  const classified = body.includes('d.canWriteNuzlockeSave(')
    || body.includes('d.shouldEnforceNuzlocke(')
    || body.includes('d.active(');
  if (!classified) unclassifiedTrainerWriters.push(here.name);
}
check(unclassifiedTrainerWriters.length === 0,
  `trainer reward persistent writers declare a safety/enforcement policy (${unclassifiedTrainerWriters.join(',') || 'all classified'})`);

const leagueStart = trainerRewards.indexOf('function M.recordLeagueProgression(battle, result)');
const leagueEnd = trainerRewards.indexOf('function M.install(ownerMod, supplied)', leagueStart);
const leagueBlock = trainerRewards.slice(leagueStart, leagueEnd);
check(leagueStart >= 0 && leagueEnd > leagueStart,
  'PASSIVE_PROGRESS writer recordLeagueProgression is discoverable');
check(leagueBlock.includes('d.canWriteNuzlockeSave(game)')
    && !leagueBlock.includes('d.active(game, battle)')
    && !leagueBlock.includes('d.shouldEnforceNuzlocke(game, battle)'),
  'recordLeagueProgression uses write safety without requiring Nuzlocke ON');
check(leagueBlock.indexOf('d.canWriteNuzlockeSave(game)')
    < leagueBlock.indexOf('d.gscProgress(save)'),
  'recordLeagueProgression write-safety guard precedes save-backed progression mutation');

// 2.5.21 trainer-identity normalization: reward recognition and passive league
// bookkeeping must consume the same id/class/name extractor. Gen 1 exposes
// oppClass directly; Gold's trainer record carries classId/class. A future
// provider may use the generic trainerClass/opponentClass aliases.
const identityStart = trainerRewards.indexOf('local function trainerIdentityKeys(battle)');
const identityEnd = trainerRewards.indexOf('local function trainerIdentityContains(identity, target)', identityStart);
const identityBlock = trainerRewards.slice(identityStart, identityEnd);
check(identityStart >= 0 && identityEnd > identityStart,
  'shared trainer identity extractor is discoverable');
check(identityBlock.includes('trainer and trainer.id')
    && identityBlock.includes('battle and battle.trainerId')
    && identityBlock.includes('battle and battle.opponentId'),
  'shared trainer identity extractor covers trainer id aliases');
check(identityBlock.includes('battle and battle.oppClass')
    && identityBlock.includes('battle and battle.trainerClass')
    && identityBlock.includes('battle and battle.opponentClass')
    && identityBlock.includes('trainer and trainer.classId')
    && identityBlock.includes('trainer and trainer.class'),
  'shared trainer identity extractor covers Gen1/Gold/provider class aliases');
check(identityBlock.includes('trainer and trainer.name')
    && identityBlock.includes('battle and battle.trainerName')
    && identityBlock.includes('battle and battle.opponentName'),
  'shared trainer identity extractor covers trainer name aliases');
check(/local function trainerMatchesLeader\(battle, leader\)[\s\S]{0,160}trainerIdentityContains\(trainerIdentityKeys\(battle\), leader\)/.test(trainerRewards),
  'Gym reward matching consumes the shared trainer identity extractor');
check(leagueBlock.includes('local identity = trainerIdentityKeys(battle)')
    && leagueBlock.includes('trainerIdentityContains(identity, stage.name)')
    && leagueBlock.includes('trainerIdentityContains(identity, gymLeader)')
    && leagueBlock.includes('trainerIdentityEquals(identity, entry.id)')
    && leagueBlock.includes('trainerIdentityEquals(identity, entry.name)'),
  'RBY/Gold league progression consumes shared id/class/name identity');
check(!leagueBlock.includes('local nameKey =') && !leagueBlock.includes('local idKey ='),
  'league progression no longer rebuilds a private id/name-only identity path');

const forgivenessStart = trainerRewards.indexOf('function M.forgivenessEnabled(game, battle)');
const forgivenessEnd = trainerRewards.indexOf('function M.forgivenessTokens()', forgivenessStart);
const forgivenessBlock = trainerRewards.slice(forgivenessStart, forgivenessEnd);
check(forgivenessBlock.includes('d.shouldEnforceNuzlocke(game, battle)'),
  'Forgiveness Token availability is RULE_ENFORCEMENT policy');
check(!/M\.forgivenessEnabled\(\)/.test(trainerRewards),
  'Forgiveness Token callers provide/resolve runtime policy context explicitly');
check(/function M\.setForgivenessTokens\(n\)[\s\S]{0,180}d\.canWriteNuzlockeSave\(game\)/.test(trainerRewards),
  'Forgiveness Token persistence has a direct write-safety guard');
check(/M\.setForgivenessTokens\(M\.forgivenessTokens\(\) \+ qty\) == false[\s\S]{0,100}return false/.test(trainerRewards),
  'Forgiveness Token Bag bridge cannot report purchase success after a refused token write');

const failedStart = main.indexOf('local function finalizeFailedEncounter(battle)');
const failedEnd = main.indexOf('finalizeNuzlockeBattle = function(battle, result)', failedStart);
const failedBlock = main.slice(failedStart, failedEnd);
check(failedStart >= 0 && failedEnd > failedStart,
  'RULE_ENFORCEMENT writer finalizeFailedEncounter is discoverable');
check(failedBlock.includes('shouldEnforceNuzlocke(game, battle)')
    && failedBlock.indexOf('shouldEnforceNuzlocke(game, battle)')
       < failedBlock.indexOf('encounterRulesArmed(game)'),
  'finalizeFailedEncounter enforces policy before encounter bookkeeping can write');

const markFailedStart = main.indexOf('mod.exports.__beta26.markEncounterFailed = function');
const markFailedEnd = main.indexOf('mod.exports.__beta26.markEncounterCaught = function', markFailedStart);
const markFailedBlock = main.slice(markFailedStart, markFailedEnd);
check(markFailedBlock.includes('shouldEnforceNuzlocke(policyGame, nil)'),
  'markEncounterFailed has defense-in-depth RULE_ENFORCEMENT gating');
const armedStart = main.indexOf('mod.exports.__beta26.encounterRulesArmed = function(game)');
const armedEnd = main.indexOf('mod.exports.__beta26.armEncounterRulesNow = function(game)', armedStart);
const armedBlock = main.slice(armedStart, armedEnd);
check(armedBlock.includes('canWriteNuzlockeSave(game)'),
  'encounter-rule discovery refuses unsupported-schema persistence writes');
const armNowStart = main.indexOf('mod.exports.__beta26.armEncounterRulesNow = function(game)');
const armNowEnd = main.indexOf('local activeWildEncounter = nil', armNowStart);
const armNowBlock = main.slice(armNowStart, armNowEnd);
check(armNowBlock.includes('canWriteNuzlockeSave(game)'),
  'explicit encounter-rule arming refuses unsupported-schema persistence writes');

const finalizerStart = main.indexOf('finalizeNuzlockeBattle = function(battle, result)');
const finalizerEnd = main.indexOf('mod.events:on("battle.ended"', finalizerStart);
const finalizerBlock = main.slice(finalizerStart, finalizerEnd);
const passiveCall = finalizerBlock.indexOf('recordLeagueProgression');
const enforcementGate = finalizerBlock.indexOf('shouldEnforceNuzlocke(game, battle)');
const rewardCall = finalizerBlock.indexOf('awardGymLeaderForgiveness');
const moneyCall = finalizerBlock.indexOf('scaleTrainerMoney');
const failedCall = finalizerBlock.indexOf('finalizeFailedEncounter(battle)');
check(passiveCall >= 0 && enforcementGate > passiveCall
    && rewardCall > enforcementGate && moneyCall > enforcementGate && failedCall > enforcementGate,
  'battle finalizer runs PASSIVE_PROGRESS before the RULE_ENFORCEMENT gate');

const pruneHandlerStart = main.indexOf('mod.events:on("battle.ended", function(payload)',
  main.indexOf('pruneRestoredDeadPokemon'));
const pruneHandlerEnd = main.indexOf('end, -1000)', pruneHandlerStart);
const pruneHandlerBlock = main.slice(pruneHandlerStart, pruneHandlerEnd);
check(pruneHandlerBlock.includes('shouldEnforceNuzlocke(game, battle)'),
  'post-battle Permadeath cleanup respects RULE_ENFORCEMENT/safe-stop policy');

// Boolean compatibility markers are harmless when session/function ownership is
// authoritative. Fail only on boolean-only early-return installation guards.
const authoritativeBooleanGuards = [...main.matchAll(
  /if[^\n]*(__nuzlocke[A-Za-z0-9_]*(?:Patched|Installed))[^\n]*then\s+return/g)]
  .map(m => m[1])
  .filter(name => name !== '__nuzlockeGoldStatusInstalled');
check(authoritativeBooleanGuards.length === 0,
  `no active direct wrapper trusts a boolean-only install guard (${authoritativeBooleanGuards.join(',') || 'none'})`);
check((main.match(/G2\.installTrainerCard/g) || []).length === 1,
  'historical Gold Trainer Card boolean guard remains dormant/uninstalled');
check(main.includes('installOwnedMethodWrapper'),
  'shared owner/previous/wrapper installer is available for direct method wrappers');

// 2.5.22 Gen 1 kerning lifecycle: src.render.Font is a require() singleton
// that can outlive the current Nuzlocke export/session table. The installer
// must therefore prove live wrapper identity rather than trust predecessor
// markers left by an earlier reload.
check(modernUi.includes('local session = Font._nuzlockeKerningSession')
    && modernUi.includes('Font._nuzlockeKerningSession = {')
    && modernUi.includes('session.token == kerning')
    && modernUi.includes('Font.advanceOf == row.advanceWrapper')
    && modernUi.includes('previousAdvance = baseAdvance')
    && modernUi.includes('advanceWrapper = advanceWrapper'),
  'Gen1 kerning records and validates session/previous/wrapper identity');
check(modernUi.includes('if sessionIsLive(session) then')
    && modernUi.includes('Font.advanceOf = session.previousAdvance')
    && modernUi.includes('clearSessionMarkers(session)'),
  'exact stale top-level Gen1 kerning session unwraps before rebinding');
check(modernUi.includes('legacy kerning wrapper detected; restart required')
    && modernUi.includes('stale kerning wrapper is not top-level; restart required')
    && modernUi.includes('kerning.reloadBlocked = true'),
  'ambiguous legacy/foreign kerning chains fail closed instead of guessing');
check(!/if Font\._nuzlockeAdvanceOf ~= nil then\s*kerning\.installed = true/.test(modernUi),
  'Gen1 kerning no longer treats a historical predecessor marker as live ownership');

// 2.5.22 randomizer versioning: starter selection must consume the same
// algorithm-version source/helper as encounters and learnsets. Algorithm v1
// intentionally keeps the exact historical hash input/results.
const starterRandomStart = main.indexOf('mod.exports.__beta26.selectRandomStarter = function(game, original)');
const starterRandomEnd = main.indexOf('mod.exports.__beta26.commitRandomStarter = function', starterRandomStart);
const starterRandomBlock = main.slice(starterRandomStart, starterRandomEnd);
check(starterRandomStart >= 0 && starterRandomEnd > starterRandomStart,
  'random starter selection block is discoverable');
check(main.includes('mod.exports.__beta26.randomizerSeededIndex = seededIndex'),
  'randomizer exports its deterministic seeded-index helper from the owning lexical scope');
check(starterRandomBlock.includes('mod.exports.__beta26.randomizerAlgorithmVersion()')
    && starterRandomBlock.includes('mod.exports.__beta26.randomizerSeededIndex('),
  'starter RNG reaches version/hash helpers only through exported cross-scope seams');
check(!starterRandomBlock.includes('Randomizer.algorithmVersion')
    && !/(^|[^.A-Za-z0-9_])seededIndex\s*\(/m.test(starterRandomBlock),
  'starter RNG has no out-of-scope Randomizer/seededIndex local references');
check(!starterRandomBlock.includes('{ "v1"')
    && !starterRandomBlock.includes('{ "1", tostring(seed), "STARTER"')
    && !starterRandomBlock.includes('local value = 5381'),
  'starter RNG has no duplicated hardcoded v1 hash implementation');
check(!main.includes('Strings("RNG %08d v1", seed)')
    && main.includes('Strings("RNG %08d v%d", seed, mod.exports.__beta26.randomizerAlgorithmVersion())'),
  'live RNG version labels derive from the shared algorithm-version source');
check(!main.includes('RNG algorithm v1 keeps the three systems on independent streams.'),
  'current randomizer help text does not bake in an algorithm-version literal');

// 2.5.23 fresh-New-Game regression ratchets. Lua permits an out-of-scope local
// name to compile as a global lookup, so compiler-only gates cannot catch a
// helper/tail accidentally stranded across one of main.lua's staged closures.
const fieldPatchStart = main.indexOf('local function installNuzlockeFieldCommandPatches()');
const fieldPatchEnd = main.indexOf('-- 2.3.11 / Gen1Recomp 0.1.98:', fieldPatchStart);
const fieldPatchBlock = main.slice(fieldPatchStart, fieldPatchEnd);
check(fieldPatchStart >= 0 && fieldPatchEnd > fieldPatchStart,
  'R/B/Y field-command installer block is discoverable');
for (const marker of [
  'Commands.heal_party = blockedHeal',
  'Commands.resolve = resolveWrapper',
  'name == "give_pokemon"',
  'Commands.__nuzlockeRulesSession = { owner = mod, methods = sessionMethods }',
  'return true',
]) {
  check(fieldPatchBlock.includes(marker),
    `R/B/Y field-command installer owns critical tail: ${marker}`);
}
const outsideFieldPatch = main.slice(0, fieldPatchStart) + main.slice(fieldPatchEnd);
check(!outsideFieldPatch.includes('Commands.heal_party = blockedHeal')
    && !outsideFieldPatch.includes('sessionMethods.resolve = { previous = originalResolve'),
  'R/B/Y command-wrapper tail is not stranded outside its owning installer scope');
check(main.includes('pcall(installNuzlockeFieldCommandPatches)')
    && /mod\.events:on\("save\.created", function\(\)[\s\S]{0,160}installNuzlockeFieldCommandPatches/.test(main),
  'R/B/Y command session installs immediately and retries on fresh save.created');
check(/installNuzlockeScriptHealGate\(\)[\s\S]{0,420}mod\.events:on\("save\.created"[\s\S]{0,160}installNuzlockeScriptHealGate/.test(main),
  'Oak tutorial/Mom script-command session retries on fresh save.created');

const phase1Call = main.indexOf('mod.exports.__beta26._lateRuntimeInit()');
const phase3Def = main.indexOf('mod.exports.__beta26._lateRuntimeInit = function()', phase1Call + 1);
const phaseBridge = main.slice(phase1Call, phase3Def);
check(phase1Call >= 0 && phase3Def > phase1Call
    && phaseBridge.includes('lateRuntimePhase2Ready')
    && phaseBridge.includes('pcall(mod.exports.__beta26._lateRuntimeInit)')
    && phaseBridge.indexOf('pcall(mod.exports.__beta26._lateRuntimeInit)')
       < phaseBridge.indexOf('mod.exports.__beta26._lateRuntimeInit = nil'),
  'staged late-runtime phase 2 executes before its staging slot is cleared');
check(main.includes('add("late_runtime_phase_2"')
    && main.includes('add("oak_catch_demo_gate"')
    && main.includes('add("rby_starter_transaction_gate"'),
  'DEV SELF TEST exposes phase-2, Oak-demo, and starter-transaction health');
check(main.includes('repairOpeningStarterTrackerLocation = function(game)')
    && main.includes('EVENT_CHOSE_PIKACHU')
    && main.includes('registerStarterCatch(accepted, mon)'),
  'conservative R/B/Y opening-starter provenance repair is installed');
check(main.includes('__nuzlockeSafeStopWriteSession')
    && main.includes('saveApi.set == session.wrapper')
    && main.includes('owner = mod, previous = previous, wrapper = wrapper'),
  'final safe-stop write barrier validates live owner/previous/wrapper identity');
check(main.includes('repairRandomStarterTrackerLocation = function(game)\n      if saveSchemaTooNew then return false end'),
  'R/B/Y randomized-starter repair hard-stops on newer schema');
check(main.includes('function G2.reconcileRandomStarterProvenance(game)\n            if saveSchemaTooNew then return false end'),
  'Gold randomized-starter repair hard-stops on newer schema');
check(/local function ensurePokemonIdentity\(mon, save, origin\)[\s\S]{0,260}if saveSchemaTooNew then return existingPokemonIdentity\(mon\) end/.test(main),
  'Pokemon identity allocation/hydration refuses newer-schema mutation');
const existingIdentityStart = main.indexOf('local function existingPokemonIdentity(mon)');
const existingIdentityEnd = main.indexOf('local function ensurePokemonIdentity', existingIdentityStart);
const existingIdentityBlock = main.slice(existingIdentityStart, existingIdentityEnd);
check(!existingIdentityBlock.includes('mon.nuzlockeId =')
    && !existingIdentityBlock.includes('mon.nuzlockeIdentityProvider =')
    && !existingIdentityBlock.includes('mon.nuzlockeExternalIdentity ='),
  'getPokemonId identity lookup path is read-only');
check(main.includes('local function enforcePermanentRuleLock(payload)\n        if saveSchemaTooNew then return end'),
  'Permanent Rule Seal reconciliation does not attempt writes while safe-stopped');

if (exists('.modkitignore')) {
  const ignored = new Set(read('.modkitignore').split(/\r?\n/).map(s => s.trim()).filter(Boolean));
  for (const rel of ['tests/', '.github/', 'docs/development/']) {
    check(ignored.has(rel), `.modkitignore excludes development-only ${rel}`);
  }
}

if (exists('.github/workflows/nuzlocke-ci.yml')) {
  const workflow = read('.github/workflows/nuzlocke-ci.yml');
  check(workflow.includes('runs-on: ubuntu-latest'),
    'CI uses the standard free ubuntu-latest runner');
  check(!workflow.match(/runs-on:\s*(?:macos|windows|.*-(?:4|8|16|32|64)-cores)/i),
    'CI does not request larger/special paid runners');
  check(!workflow.includes('actions/upload-artifact'),
    'CI does not upload build artifacts or consume Actions artifact storage');
}

console.log(`\nNuzlocke invariant gate: ${passed} PASS, ${warned} WARN, strict=${strict}`);
