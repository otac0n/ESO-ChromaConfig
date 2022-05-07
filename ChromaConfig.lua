local ALLIANCE_COLORS = {
  [ALLIANCE_ALDMERI_DOMINION] = ZO_ColorDef:New(1, 1, 0, 1),
  [ALLIANCE_EBONHEART_PACT] = ZO_ColorDef:New(1, 0, 0, 1),
  [ALLIANCE_DAGGERFALL_COVENANT] = ZO_ColorDef:New(0, 0, 1, 1),
}

local function OnLoad(eventCode, name)
  if name ~= ChromaConfig.ADDON_NAME then return end

  local alliance = ZO_RZCHROMA_EFFECTS.activeAlliance
  local inBattleground = ZO_RZCHROMA_EFFECTS.inBattleground
  ZO_RZCHROMA_EFFECTS:SetAlliance(ALLIANCE_NONE)
  ZO_RZCHROMA_EFFECTS.allianceEffects = ZO_RZCHROMA_EFFECTS:CreateAllianceEffects(function (a)
    return ALLIANCE_COLORS[a]
  end)
  ZO_RZCHROMA_EFFECTS:SetAlliance(alliance, inBattleground)

  EVENT_MANAGER:UnregisterForEvent(ChromaConfig.ADDON_NAME, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ChromaConfig.ADDON_NAME, EVENT_ADD_ON_LOADED, OnLoad)
