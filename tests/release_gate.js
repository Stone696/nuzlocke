#!/usr/bin/env node
// Static release gate for Nuzlocke Rules beta.29.1.0.
// Usage: node release_gate.js ../main.lua [/path/to/Gen1Recomp]

const fs = require("fs");
const path = require("path");

const mainPath = path.resolve(process.argv[2] || "main.lua");
const enginePath = process.argv[3] ? path.resolve(process.argv[3]) : null;
const source = fs.readFileSync(mainPath, "utf8");
const repoRoot = path.dirname(mainPath);
const readRepo = (rel) => fs.readFileSync(path.join(repoRoot, rel), "utf8");
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

check(source.includes('build = "beta.29.1.0"'), "build id is beta.29.1.0");
check(source.includes('recompCompatAudited = "0.1.83"'), "audited Gen1Recomp profile is 0.1.83");
check(source.includes('["0.1.82"]') && source.includes('["0.1.83"]'),
  "engine compatibility profiles include 0.1.82 and 0.1.83");
check(!source.includes('nuzlocke_first_rival_forgiveness_armed')
    && !source.includes('nuzlocke_first_rival_forgiveness_triggered'),
  "First Rival Mercy no longer writes unused persisted telemetry");
check(source.includes("syncHistoryNickname = function(mon)")
    && source.includes("mod.exports.__beta26.syncHistoryNickname(received)")
    && source.includes("mod.exports.__beta26.syncHistoryNickname(mon)"),
  "mandatory nickname completion synchronizes acquisition history in R/B/Y and Gold");
check(source.includes("function G2.snapshotOwnedPokemon(save)")
    && source.includes("function G2.findNewOwnedPokemon(before, save)")
    && source.includes("for _, box in ipairs(save and save.boxes or {}) do")
    && source.includes("local mon = G2.findNewOwnedPokemon(before, game and game.save)"),
  "Gold scripted gift detection covers party and PC boxes");
check(source.includes("if battle and type(pendingStatic) == \"table\" then")
    && source.includes("Any intervening battle, including a trainer")
    && source.indexOf("mod.exports.__beta26.pendingStaticEncounter = nil", source.indexOf("local pendingStatic"))
       < source.indexOf("if not isTrainerBattleForNuzlocke(battle)", source.indexOf("local pendingStatic")),
  "pending static provenance is consumed before trainer/wild classification");
check(source.includes("version = 25,"), "compatibility API is v25");
check(source.includes("api = 25,"), "compatibility report matches v25");
check(!/[ \t]+$/m.test(source), "no trailing whitespace");
check(fs.existsSync(path.join(repoRoot, "docs", "DOCUMENTATION_CHANGELOG.md")),
  "public documentation changelog is present");
const manifest = JSON.parse(readRepo("manifest.json"));
check(manifest.version === "2.0.0-beta.29.1.0", "manifest version matches beta.29.1.0");
check(manifest.api === 2, "manifest Gen1Recomp Mod API is 2");
check(manifest.game_version === ">=0.1.81 <0.1.84",
  "manifest engine range covers audited 0.1.81 through 0.1.83");
check(JSON.stringify(manifest.games) === JSON.stringify(["red", "blue", "yellow", "gold"]),
  "manifest game targets are exactly Red/Blue/Yellow/Gold");
const readme = readRepo("README.md");
check(readme.includes("Gen1Recomp Mod API:") && readme.includes("Nuzlocke Compatibility API:"),
  "README distinguishes engine and Nuzlocke API namespaces");
const userGuide = readRepo(path.join("docs", "USER_GUIDE.md"));
check(readme.includes("Stone696** — updater of bryanthaboi's original Nuzlocke mod")
    && userGuide.includes("Stone696** — updater of bryanthaboi's original Nuzlocke mod"),
  "public credits identify Stone696 only as updater");
const readmeCredits = readme.slice(readme.indexOf("## Credits"), readme.indexOf("Pokémon and related names"));
check((readmeCredits.match(/^\- /gm) || []).length === 3,
  "README credits remain limited to original author, updater, and platform note");
const modkitIgnore = readRepo(".modkitignore");
check(modkitIgnore.split(/\r?\n/).includes("docs/development/"),
  "internal development review history is excluded from player packaging");

const ruleBlock = source.slice(source.indexOf("local ruleCategories ="),
  source.indexOf("-- AREA GUIDE STATE"));
const ruleKeys = [...ruleBlock.matchAll(/\{\s*key\s*=\s*"([^"]+)"/g)]
  .map((match) => match[1]);
check(ruleKeys.length === 54, "54 active rule rows are registered");
check(unique(ruleKeys), "rule keys are unique");
check(source.includes("for _, rule in ipairs(cat.rules) do\n              values[rule.key] = defaultRuleValue(rule.key)"),
  "every active rule receives a new-game default");
check(source.includes("player_start_stat_exp") && source.includes("wild_start_stat_exp")
    && source.includes("trainer_start_stat_exp"),
  "Stat EXP creation presets are registered for player/wild/trainer");
check(source.includes("no_player_stat_exp_gain")
    && source.includes("blockedDef.baseStats = { hp = 0, attack = 0, defense = 0, speed = 0, special = 0 }"),
  "player Stat EXP accumulation veto is pre-mutation");
check(source.includes("perfect_player_ivs") && source.includes("perfect_wild_ivs")
    && source.includes("perfect_trainer_ivs"),
  "independent perfect DV controls are registered");
check(source.includes("PSEUDOS = {") && source.includes("DRAGONITE = true")
    && source.includes("TYRANITAR = true") && source.includes('return "pseudo"'),
  "No Pseudos has built-in Dragonite/Tyranitar classification and live denial paths");
check(source.includes("beta.28.11 crossed Lua's 200-active-local")
    && source.includes("local StatRules = {}") && source.includes("do\n      local StatRules"),
  "Stat EXP/DV implementation remains lexically scoped below the Lua local-variable ceiling");
check(!source.includes("__nuzlockeOptionsGuardOwner")
    && !source.includes("MOD MANAGER COMPATIBILITY (beta.28.13)"),
  "speculative Gold Mod Manager save-options mutation has been removed");
check(source.includes("local function titleLabel(item)")
    && source.includes('if item.value == "new" then return true end')
    && source.includes('if item.value == "continue" then return true end'),
  "Setup title detection accepts both stock callbacks and value-dispatch rows");

const capabilityBlock = source.match(
  /local COMPAT_CAPABILITIES = \{([\s\S]*?)\n  \}/)[1];
const capabilities = strings(capabilityBlock);
const defaultsBlock = source.match(
  /defaults = \{([\s\S]*?)\n          \},\n          relationships/)[1];
const relationshipDefaults = [...defaultsBlock.matchAll(/([a-z_]+)\s*=/g)]
  .map((match) => match[1]);
check(capabilities.length === 27 && unique(capabilities),
  "27 compatibility capabilities are unique");
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
check(source.includes('[4] = Strings.source("STANDARD"), [5] = Strings.source("ALL")')
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
  const optionalCompatibilityEvents = new Set([
    "breeding.egg_created", "egg.hatched", "roamer.moved", "roamer.encountered",
  ]);
  for (const event of new Set(registeredEvents)) {
    const optional = optionalCompatibilityEvents.has(event);
    check(optional || engineLua.includes(`emit("${event}"`)
        || engineLua.includes(`emit('${event}'`),
      `engine emits event ${event}${optional ? " (optional compatibility subscription)" : ""}`);
  }
  const goldBattlePath = path.join(enginePath, "src/battle/gen2/Battle.lua");
  const goldVmPath = path.join(enginePath, "src/script/gen2/Vm.lua");
  const goldWorldPath = path.join(enginePath, "src/world/gen2/World.lua");
  const goldMenuPath = path.join(enginePath, "src/ui/gen2/MainMenu.lua");
  if ([goldBattlePath, goldVmPath, goldWorldPath, goldMenuPath].every(fs.existsSync)) {
    const goldBattle = fs.readFileSync(goldBattlePath, "utf8");
    const goldVm = fs.readFileSync(goldVmPath, "utf8");
    const goldWorld = fs.readFileSync(goldWorldPath, "utf8");
    const goldMenu = fs.readFileSync(goldMenuPath, "utf8");
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
  } else {
    console.log("SKIP: audited source bundle does not contain Gen 2 engine files; Gold remains manual TEST REQUIRED");
  }
}

console.log(`RELEASE GATE PASS (${passed} checks)`);
