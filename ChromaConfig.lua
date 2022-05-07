ChromaConfig.ALLIANCE_COLORS = {
  [ALLIANCE_ALDMERI_DOMINION] = ZO_ColorDef:New(1, 0.75, 0, 1),
  [ALLIANCE_EBONHEART_PACT] = ZO_ColorDef:New(1, 0, 0, 1),
  [ALLIANCE_DAGGERFALL_COVENANT] = ZO_ColorDef:New(0, 0, 1, 1),
}

EVENT_MANAGER:RegisterForEvent(ChromaConfig.ADDON_NAME, EVENT_ADD_ON_LOADED, function (eventCode, name)
  if name ~= ChromaConfig.ADDON_NAME then return end
  ChromaConfig:Init()
  EVENT_MANAGER:UnregisterForEvent(ChromaConfig.ADDON_NAME, EVENT_ADD_ON_LOADED)
end)

function ChromaConfig:Init()
  ChromaConfig.settingsPanel = ChromaConfigSettings:New()
  ChromaConfig:ResetAllianceEffects()
end

function ChromaConfig:ResetAllianceEffects()
  local alliance = ZO_RZCHROMA_EFFECTS.activeAlliance
  local inBattleground = ZO_RZCHROMA_EFFECTS.inBattleground
  ZO_RZCHROMA_EFFECTS:SetAlliance(ALLIANCE_NONE)
  ZO_RZCHROMA_EFFECTS.allianceEffects = ZO_RZCHROMA_EFFECTS:CreateAllianceEffects(function (a)
    return ChromaConfig.ALLIANCE_COLORS[a]
  end)
  ZO_RZCHROMA_EFFECTS:SetAlliance(alliance, inBattleground)
end
