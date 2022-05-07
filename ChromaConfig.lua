local ALLIANCE_COLORS = {
  [ALLIANCE_ALDMERI_DOMINION] = ZO_ColorDef:New(1, 1, 0, 1),
  [ALLIANCE_EBONHEART_PACT] = ZO_ColorDef:New(1, 0, 0, 1),
  [ALLIANCE_DAGGERFALL_COVENANT] = ZO_ColorDef:New(0, 0, 1, 1),
}

local alliance = ZO_RZCHROMA_EFFECTS.activeAlliance
local inBattleground = ZO_RZCHROMA_EFFECTS.inBattleground
ZO_RZCHROMA_EFFECTS:SetAlliance(ALLIANCE_NONE)
ZO_RZCHROMA_EFFECTS.allianceEffects = ZO_RZCHROMA_EFFECTS:CreateAllianceEffects(function (a)
  return ALLIANCE_COLORS[a]
end)
ZO_RZCHROMA_EFFECTS:SetAlliance(alliance, inBattleground)
