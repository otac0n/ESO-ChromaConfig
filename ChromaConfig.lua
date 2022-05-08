﻿EVENT_MANAGER:RegisterForEvent(ChromaConfig.ADDON_NAME, EVENT_ADD_ON_LOADED, function (eventCode, name)
  if name ~= ChromaConfig.ADDON_NAME then return end
  ChromaConfig:Initialize()
  EVENT_MANAGER:UnregisterForEvent(ChromaConfig.ADDON_NAME, EVENT_ADD_ON_LOADED)
end)

function ChromaConfig:Initialize()
  ChromaConfig:InitializeSettings()
  ChromaConfig:ResetAllianceEffects(nil, nil)
  ChromaConfig.settingsMenu = ChromaConfigSettingsMenu:New()
end

function ChromaConfig:GetAllainceColor(alliance, inBattleground)
  local hex = ChromaConfig.backgroundVars.BackgroundColor
  if hex and (not inBattleground or ChromaConfig.backgroundVars.UseCustomColorDuringBattlegrounds) then
    return ZO_ColorDef:New(hex)
  end

  local allianceSettings, getColorFallback
  if inBattleground then
    allianceSettings = ChromaConfig.allianceVars.Teams[alliance]
    getColorFallback = GetBattlegroundAllianceColor
  else
    allianceSettings = ChromaConfig.allianceVars.Alliances[alliance]
    getColorFallback = GetAllianceColor
  end

  if allianceSettings.UseCustomColor then
    return ZO_ColorDef:New(allianceSettings.Color)
  else
    return getColorFallback(alliance)
  end
end

function ChromaConfig:ResetAllianceEffects(alliance, inBattleground)
  if inBattleground == nil then
    self:ResetAllianceEffects(alliance, false)
    self:ResetAllianceEffects(alliance, true)
    return
  end
  if alliance == nil then
    if inBattleground then
      for alliance = BATTLEGROUND_ALLIANCE_ITERATION_BEGIN, BATTLEGROUND_ALLIANCE_ITERATION_END do
        self:ResetAllianceEffects(alliance, inBattleground)
      end
    else
      for alliance = ALLIANCE_ITERATION_BEGIN, ALLIANCE_ITERATION_END do
        self:ResetAllianceEffects(alliance, inBattleground)
      end
    end
    return
  end

  local recreate = ZO_RZCHROMA_EFFECTS.activeAlliance == alliance and ZO_RZCHROMA_EFFECTS.inBattleground == inBattleground

  local oldEffects = ZO_RZCHROMA_EFFECTS:GetAllianceEffects(alliance, inBattleground)
  local newEffects = self:CreateAllianceEffects(alliance, inBattleground)

  for deviceType, newEffect in pairs(newEffects) do
    local oldEffect = oldEffects[deviceType]
    oldEffects[deviceType] = newEffect
    if recreate then
      ZO_RZCHROMA_MANAGER:RemoveEffect(oldEffect)
      ZO_RZCHROMA_MANAGER:AddEffect(newEffect)
    end
  end
end

function ChromaConfig:CreateAllianceEffects(alliance, inBattleground)
  local allianceColor = self:GetAllainceColor(alliance, inBattleground)
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
