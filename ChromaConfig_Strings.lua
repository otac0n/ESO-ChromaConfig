local localizedStrings = {
  ["en"] = {
    ALLIANCE_HEADER = "Alliance",
    ALLIANCE_USE_CUSTOM_COLOR = "Use custom <<1>> color",
    ALLIANCE_CUSTOM_COLOR = "Custom <<1>> color",
    ALLIANCES = {
      [ALLIANCE_ALDMERI_DOMINION] = {
        TOOLTIP = "Typically a shade of yellow.",
      },
      [ALLIANCE_EBONHEART_PACT] = {
        TOOLTIP = "Typically a shade of red.",
      },
      [ALLIANCE_DAGGERFALL_COVENANT] = {
        TOOLTIP = "Typically a shade of blue.",
      },
    },
  },
}

local function mergeTables(base, special)
  local merged = {}
  for k,b in pairs(base) do
    merged[k] = b
  end
  for k,s in pairs(special) do
    if s then
      local o = merged[k]
      if type(s) == "table" and type(o) == "table" then
        s = mergeTables(o, s)
      end
      merged[k] = s
    end
  end
  return merged
end

ChromaConfig.stringCache = {}
function ChromaConfig:GetStrings()
  local lang = GetCVar("language.2")
  local cached = ChromaConfig.stringCache[lang]
  if cached then return cached end

  local sharedStrings = {
    ALLIANCES = {
      [ALLIANCE_ALDMERI_DOMINION] = {
        NAME = GetString(SI_ALLIANCE1),
      },
      [ALLIANCE_EBONHEART_PACT] = {
        NAME = GetString(SI_ALLIANCE2),
      },
      [ALLIANCE_DAGGERFALL_COVENANT] = {
        NAME = GetString(SI_ALLIANCE3),
      },
    },
  }
  
  local strings = localizedStrings[lang]
  if not strings then strings = localizedStrings["en"] end
  cached = mergeTables(sharedStrings, strings)
  ChromaConfig.stringCache[lang] = cached
  return cached
end
