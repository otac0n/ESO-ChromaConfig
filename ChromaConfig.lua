EVENT_MANAGER:RegisterForEvent(ChromaConfig.ADDON_NAME, EVENT_ADD_ON_LOADED, function (eventCode, name)
  if name ~= ChromaConfig.ADDON_NAME then return end
  ChromaConfig:Init()
  EVENT_MANAGER:UnregisterForEvent(ChromaConfig.ADDON_NAME, EVENT_ADD_ON_LOADED)
end)

function ChromaConfig:Init()
  ChromaConfig:InitializeSettings()

  for alliance = ALLIANCE_ITERATION_BEGIN, ALLIANCE_ITERATION_END do
    ChromaConfig:ResetAllianceEffects(alliance, false)
  end
  for alliance = BATTLEGROUND_ALLIANCE_ITERATION_BEGIN, BATTLEGROUND_ALLIANCE_ITERATION_END do
    ChromaConfig:ResetAllianceEffects(alliance, true)
  end

  ChromaConfig.settingsMenu = ChromaConfigSettingsMenu:New()
end

function ChromaConfig:ResetAllianceEffects(alliance, inBattleground)
  local newColor
  if ChromaConfig.accountVars.Alliances[alliance].UseCustomColor then
    newColor = ZO_ColorDef:New(ChromaConfig.accountVars.Alliances[alliance].Color)
  else
    local getColorFallback = inBattleground and GetBattlegroundAllianceColor or GetAllianceColor
    newColor = getColorFallback(alliance)
  end

  local recreate = ZO_RZCHROMA_EFFECTS.activeAlliance == alliance and ZO_RZCHROMA_EFFECTS.inBattleground == inBattleground

  local oldEffects = ZO_RZCHROMA_EFFECTS:GetAllianceEffects(alliance, inBattleground)
  local newEffects = self:CreateAllianceEffects(newColor)

  for deviceType, newEffect in pairs(newEffects) do
    local oldEffect = oldEffects[deviceType]
    oldEffects[deviceType] = newEffect
    if recreate then
      ZO_RZCHROMA_MANAGER:RemoveEffect(oldEffect)
      ZO_RZCHROMA_MANAGER:AddEffect(newEffect)
    end
  end
end

function ChromaConfig:CreateAllianceEffects(allianceColor)
  allianceColor = allianceColor:Clone()
  allianceColor:SetAlpha(ZO_CHROMA_UNDERLAY_ALPHA)
  local r, g, b = allianceColor:UnpackRGB()
  local NO_ANIMATION_TIMER = nil
  return {
    [CHROMA_DEVICE_TYPE_KEYBOARD] = ZO_ChromaCStyleCustomSingleColorEffect:New(CHROMA_DEVICE_TYPE_KEYBOARD, ZO_CHROMA_EFFECT_DRAW_LEVEL.FALLBACK, CHROMA_CUSTOM_EFFECT_GRID_STYLE_FULL, NO_ANIMATION_TIMER, allianceColor, CHROMA_BLEND_MODE_NORMAL),
    [CHROMA_DEVICE_TYPE_KEYPAD] = ZO_ChromaCStyleCustomSingleColorEffect:New(CHROMA_DEVICE_TYPE_KEYPAD, ZO_CHROMA_EFFECT_DRAW_LEVEL.FALLBACK, CHROMA_CUSTOM_EFFECT_GRID_STYLE_FULL, NO_ANIMATION_TIMER, allianceColor, CHROMA_BLEND_MODE_NORMAL),
    [CHROMA_DEVICE_TYPE_MOUSE] = ZO_ChromaCStyleCustomSingleColorEffect:New(CHROMA_DEVICE_TYPE_MOUSE, ZO_CHROMA_EFFECT_DRAW_LEVEL.FALLBACK, CHROMA_CUSTOM_EFFECT_GRID_STYLE_FULL, NO_ANIMATION_TIMER, allianceColor, CHROMA_BLEND_MODE_NORMAL),
    [CHROMA_DEVICE_TYPE_MOUSEPAD] = ZO_ChromaCStyleCustomSingleColorEffect:New(CHROMA_DEVICE_TYPE_MOUSEPAD, ZO_CHROMA_EFFECT_DRAW_LEVEL.FALLBACK, CHROMA_CUSTOM_EFFECT_GRID_STYLE_FULL, NO_ANIMATION_TIMER, allianceColor, CHROMA_BLEND_MODE_NORMAL),
    [CHROMA_DEVICE_TYPE_HEADSET] = ZO_ChromaPredefinedEffect:New(CHROMA_DEVICE_TYPE_HEADSET, ZO_CHROMA_EFFECT_DRAW_LEVEL.FALLBACK, ChromaCreateHeadsetStaticEffect, r, g, b),
  }
end
