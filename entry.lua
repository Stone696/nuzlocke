-- Isolate the new Gen 3 implementation from the established Gen 1/2 runtime.
-- This is intentionally an entry-point dispatcher, not an engine monkey-patch.
return function(mod)
    local Version = require("src.core.GameVersion")
    local version = Version.get()
    local generation = Version.generation(version)
    local path = generation == 3 and "gen3_runtime.lua" or "main.lua"
    local source, readError = mod:read(path)
    assert(type(source) == "string", "Nuzlocke could not read " .. path .. ": " .. tostring(readError))
    local chunk, errorMessage = load(source, "@mods/nuzlocke/" .. path)
    assert(type(chunk) == "function", "Nuzlocke could not compile " .. path .. ": " .. tostring(errorMessage))
    return chunk()(mod)
end
