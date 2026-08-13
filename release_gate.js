#!/usr/bin/env node
// Static release gate for Nuzlocke Rules beta.27.16.
// Usage: node release_gate.js ../main.lua [/path/to/Gen1Recomp]

const fs = require("fs");
const path = require("path");

const mainPath = path.resolve(process.argv[2] || "main.lua");
const enginePath = process.argv[3] ? path.resolve(process.argv[3]) : null;
const source = fs.readFileSync(mainPath, "utf8");
let passed = 0;

function check(condition, message) {
  if (!condition) throw new Error(`FAIL: ${message}`);
  passed += 1;
  console.log(`PASS: ${message}`);
}
function strings(block) {
  return [...block.matchAll(/"([^"]+)"/g)].map((match) => match[1]);
}
function unique(values) {
  return new Set(values).size === values.length;
}

check(source.includes('build = "beta.27.16"'), "build id is beta.27.16");
check(source.includes("version = 22,"), "compatibility API is v22");
check(source.includes("api = 22,"), "compatibility report matches v22");
check(!/[ \t]+$/m.test(source), "no trailing whitespace");

const ruleBlock = source.slice(source.indexOf("local ruleCategories ="),
  source.indexOf("-- AREA GUIDE STATE"));
const ruleKeys = [...ruleBlock.matchAll(/\{\s*key\s*=\s*"([^"]+)"/g)]
  .map((match) => match[1]);
check(ruleKeys.length === 42, "42 active rule rows are registered");
check(unique(ruleKeys), "rule keys are unique");
check(source.includes("for _, rule in ipairs(cat.rules) do\n              values[rule.key] = defaultRuleValue(rule.key)"),
  "every active rule receives a new-game default");

const capabilityBlock = source.match(
  /local COMPAT_CAPABILITIES = \{([\s\S]*?)\n  \}/)[1];
const capabilities = strings(capabilityBlock);
const defaultsBlock = source.match(
  /defaults = \{([\s\S]*?)\n          \},\n          relationships/)[1];
const relationshipDefaults = [...defaultsBlock.matchAll(/([a-z_]+)\s*=/g)]
  .map((match) => match[1]);
check(capabilities.length === 24 && unique(capabilities),
  "24 compatibility capabilities are unique");
check(capabilities.every((capability) => relationshipDefaults.includes(capability)),
  "every advertised capability declares a default relationship");

const axesBlock = source.match(
  /routeCardinalAxes = \{([\s\S]*?)\n  \}/)[1];
const routeNumbers = [...axesBlock.matchAll(/ROUTE_(\d+)\s*=\s*"(NS|EW)"/g)]
  .map((match) => Number(match[1]));
check(routeNumbers.length === 25 && unique(routeNumbers)
    && routeNumbers.sort((a, b) => a - b).every((value, index) => value === index + 1),
  "Route 1-25 each declare one cardinal axis");
check(source.includes('parent = "MT_MOON"')
    && source.includes('parent = "SAFARI_ZONE"'),
  "Mt. Moon and Safari split families are registered");
check(source.includes("ensureEncounterProjection")
    && source.includes("reprojectEncounterAreas"),
  "encounter projections have live refresh and reversible rebuild paths");

const worldKeys = [...source.matchAll(
  /world(?:Mechanic|Once)\([^,]+,\s*"([^"]+)"/g)]
  .map((match) => match[1]);
check(unique(worldKeys), "literal World Building event keys are not duplicated");
check(source.includes("cleanWorldText")
    && source.includes("state.activeText == text"),
  "World Building text is normalized and presentation-deduplicated");

check(source.includes("item.value == \"continue\"")
    && source.includes("not hasContinue and not hasSetup"),
  "Setup is hidden when a final title menu exposes a save");
check(source.includes("battle.trainer ~= nil")
    && source.includes("recordLeagueProgression(battle, finalResult)"),
  "generation-neutral trainer detection feeds boss progression");
check(source.includes("math.max(floor, ace)"),
  "boss cap calculation includes a monotonic floor");
check(source.includes("levelCapBosses.observed = {}"),
  "dynamic trainer observations invalidate when the mod set changes");
check(source.includes("get_next_cap") && source.includes("getNextCap")
    && source.includes("levelCap"),
  "external cap providers accept common function and result aliases");
check(source.includes('rbyPrizeRoom = "GAME_CORNER_PRIZE_ROOM"')
    && source.includes('gscCeladonPrizeRoom = "CELADON_GAME_CORNER_PRIZE_ROOM"'),
  "Game Corner map IDs are centralized and generation-specific");
check(source.includes("previousHandlers = previousHandlers")
    && source.includes("previousAll = previousAll")
    && source.includes("wrapperHandlers = wrapperHandlers")
    && source.includes("wrapperAll = wrapperAll"),
  "Gold special wrappers preserve HANDLERS and ALL independently");
check(source.includes("pcall(G2.installNicknameGate)")
    && source.includes("nickname_rule = true,")
    && source.includes("__nuzlockeNicknameAnswerSession")
    && source.includes("__nuzlockeNicknameAcceptSession"),
  "Gold Nickname Rule is exposed, installed, and session-owned");
check(source.includes("G2.requireGiftNickname(game, mon, ctx and ctx.vm)")
    && source.includes("Specials.block(vm, function(done)"),
  "Gold scripted gifts use the VM's blocking nickname seam");
check(source.includes("local catchableBattle = self and self.battle")
    && source.includes("or mod.exports.__beta26.isStaticEncounter("),
  "Gold Ball gate admits native wild and explicit fixed encounters");
check(source.includes('[4] = "STANDARD", [5] = "ALL"')
    && source.includes("return rank ~= nil and rank <= tier")
    && !source.includes("Try a stronger allowed Ball"),
  "Ball tier 4 is accurately presented as the all-standard ban");
check(source.includes("Standard Balls are banned. Specialty/custom Balls remain eligible.")
    && source.includes("Every recognized Ball is banned by this rule."),
  "STANDARD and ALL Ball denials provide distinct actionable scope");

const expectedOrder = [
  "glitch.isGlitch and not mod.exports.__beta26.glitchCatchesAllowed()",
  'return "static"',
  'return "legendary"',
  'return "mythical"',
  'return "area"',
  'return "dupes"',
  'return "bst"',
];
const catchPolicyStart = source.indexOf("catchDeniedReason = function");
const catchPolicy = source.slice(catchPolicyStart,
  source.indexOf("-- ENCOUNTER TYPE", catchPolicyStart));
let cursor = -1;
for (const marker of expectedOrder) {
  const next = catchPolicy.indexOf(marker, cursor + 1);
  check(next > cursor, `capture precedence contains ${marker}`);
  cursor = next;
}

if (enginePath) {
  function walk(directory) {
    const out = [];
    for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
      const full = path.join(directory, entry.name);
      if (entry.isDirectory()) out.push(...walk(full));
      else if (entry.name.endsWith(".lua")) out.push(full);
    }
    return out;
  }
  const engineLua = walk(path.join(enginePath, "src"))
    .map((file) => fs.readFileSync(file, "utf8")).join("\n");
  const registeredHooks = [...source.matchAll(
    /mod\.hooks:(?:wrap|subscribe)\("([^"]+)"/g)].map((match) => match[1]);
  const fallbackOnlyHooks = new Set(["battle.nickname", "battle.use_item"]);
  for (const hook of registeredHooks) {
    check(fallbackOnlyHooks.has(hook)
        || engineLua.includes(`Runtime.call("${hook}"`),
      `engine exposes hook ${hook}${fallbackOnlyHooks.has(hook) ? " (fallback-only allowed)" : ""}`);
  }
  const registeredEvents = [...source.matchAll(
    /mod\.events:on\("([^"]+)"/g)].map((match) => match[1]);
  for (const event of new Set(registeredEvents)) {
    check(engineLua.includes(`emit("${event}"`)
        || engineLua.includes(`emit('${event}'`),
      `engine emits event ${event}`);
  }
  const goldBattle = fs.readFileSync(path.join(enginePath,
    "src/battle/gen2/Battle.lua"), "utf8");
  const goldVm = fs.readFileSync(path.join(enginePath,
    "src/script/gen2/Vm.lua"), "utf8");
  const goldWorld = fs.readFileSync(path.join(enginePath,
    "src/world/gen2/World.lua"), "utf8");
  const goldMenu = fs.readFileSync(path.join(enginePath,
    "src/ui/gen2/MainMenu.lua"), "utf8");
  check(goldBattle.includes('kind = self.wild and "wild" or "trainer"')
      && goldBattle.includes('Runtime.emit("battle.ended"'),
    "Gold exposes generation-neutral battle lifecycle payloads");
  check(goldMenu.includes('{ label = "CONTINUE", value = "continue" }')
      && goldMenu.includes('{ label = "NEW GAME", value = "new" }'),
    "Gold title menu save detection contract matches adapter");
  check(goldVm.includes("self.wildMon = { species = cmd.species")
      && goldWorld.includes("opts.wild = id and Mon.new")
      && goldBattle.includes("if opts.wild then\n    self.wild = true"),
    "Gold loadwildmon static battles use the native wild battle shape");
}

console.log(`RELEASE GATE PASS (${passed} checks)`);
