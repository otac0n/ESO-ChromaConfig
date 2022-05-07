ChromaConfig.LocalizedStrings = {
  ["en"] = {
    ALLIANCE_HEADER = "Alliance",
    ALLIANCES = {
      [ALLIANCE_ALDMERI_DOMINION] = {
        NAME = "Aldmeri Dominion",
        TOOLTIP = "Typically a shade of yellow.",
      },
      [ALLIANCE_EBONHEART_PACT] = {
        NAME = "Ebonheart Pact",
        TOOLTIP = "Typically a shade of red.",
      },
      [ALLIANCE_DAGGERFALL_COVENANT] = {
        NAME = "Daggerfall Covenant",
        TOOLTIP = "Typically a shade of blue.",
      },
    },
  },
}

function ChromaConfig:GetStrings()
  local lang = GetCVar("language.2")
  local strings = self.LocalizedStrings[lang]
  if not strings then strings = self.LocalizedStrings["en"] end
  return strings
end
