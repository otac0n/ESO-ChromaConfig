ChromaConfigSettingsMenu = ZO_Object:Subclass()

function ChromaConfigSettingsMenu:New()
  local obj = ZO_Object.New(self)
  obj:Initialize()
  return obj
end

function ChromaConfigSettingsMenu:Initialize()
  self:CreateOptionsMenu()
end

function ChromaConfigSettingsMenu:CreateOptionsMenu()
  local allianceVars = ChromaConfig.allianceVars
  local backgroundVars = ChromaConfig.backgroundVars
  local str = ChromaConfig:GetStrings()

  local panel = {
    type            = "panel",
    name            = ChromaConfig.ADDON_TITLE,
    author          = ChromaConfig.AUTHOR,
    version         = ChromaConfig.VERSION,
    website         = ChromaConfig.WEBSITE,
    donation        = ChromaConfig.DONATION,
    feedback        = ChromaConfig.FEEDBACK,
    slashCommand    = "/chroma",
    registerForRefresh = true
  }

  local optionsData = {}
  local accountControls = {}

  table.insert(optionsData, {
    type = "submenu",
    name = str.ALLIANCE_SETTINGS,
    controls = accountControls,
  })

  table.insert(accountControls, {
    type = "header",
    name = str.ALLIANCE_HEADER,
  })

  for alliance = ALLIANCE_ITERATION_BEGIN, ALLIANCE_ITERATION_END do
    table.insert(accountControls, {
      type = "checkbox",
      name = zo_strformat(str.USE_CUSTOM_X_COLOR, str.ALLIANCES[alliance].NAME),
      getFunc = function()
        return allianceVars.Alliances[alliance].UseCustomColor
      end,
      setFunc = function(v)
        allianceVars.Alliances[alliance].UseCustomColor = v
        ChromaConfig:ResetAllianceEffects(alliance, false)
      end,
    })

    table.insert(accountControls, {
      type = "colorpicker",
      name = zo_strformat(str.CUSTOM_X_COLOR, str.ALLIANCES[alliance].NAME),
      tooltip = str.ALLIANCES[alliance].TOOLTIP,
      getFunc = function()
        return ZO_ColorDef:New(allianceVars.Alliances[alliance].Color):UnpackRGB()
      end,
      setFunc = function(r, g, b)
        local color = ZO_ColorDef:New(r, g, b, 1)
        allianceVars.Alliances[alliance].Color = color:ToHex()
        ChromaConfig:ResetAllianceEffects(alliance, false)
      end,
      disabled = function()
        return not allianceVars.Alliances[alliance].UseCustomColor
      end,
    })
  end
  
  table.insert(accountControls, {
    type = "header",
    name = str.BATTLEGROUNDS_HEADER,
  })

  for alliance = BATTLEGROUND_ALLIANCE_ITERATION_BEGIN, BATTLEGROUND_ALLIANCE_ITERATION_END do
    table.insert(accountControls, {
      type = "checkbox",
      name = zo_strformat(str.USE_CUSTOM_X_COLOR, str.BATTLEGROUND_ALLIANCES[alliance].NAME),
      getFunc = function()
        return allianceVars.Teams[alliance].UseCustomColor
      end,
      setFunc = function(v)
        allianceVars.Teams[alliance].UseCustomColor = v
        ChromaConfig:ResetAllianceEffects(alliance, true)
      end,
    })

    table.insert(accountControls, {
      type = "colorpicker",
      name = zo_strformat(str.CUSTOM_X_COLOR, str.BATTLEGROUND_ALLIANCES[alliance].NAME),
      tooltip = str.BATTLEGROUND_ALLIANCES[alliance].TOOLTIP,
      getFunc = function()
        return ZO_ColorDef:New(allianceVars.Teams[alliance].Color):UnpackRGB()
      end,
      setFunc = function(r, g, b)
        local color = ZO_ColorDef:New(r, g, b, 1)
        allianceVars.Teams[alliance].Color = color:ToHex()
        ChromaConfig:ResetAllianceEffects(alliance, true)
      end,
      disabled = function()
        return not allianceVars.Teams[alliance].UseCustomColor
      end,
    })
  end

  table.insert(optionsData, {
    type = "header",
    name = str.BACKGROUND_COLOR,
  })

  table.insert(optionsData, backgroundVars:GetLibAddonMenuAccountCheckbox())

  local backgroundColor = backgroundVars.BackgroundColor or GetAllianceColor(GetUnitAlliance("player")):ToHex()
  table.insert(optionsData, {
    type = "checkbox",
    name = str.USE_CUSTOM_BACKGROUND_COLOR,
    getFunc = function()
      return backgroundVars.BackgroundColor ~= nil
    end,
    setFunc = function(v)
      backgroundVars.BackgroundColor = (v and backgroundColor or nil)
      for alliance = ALLIANCE_ITERATION_BEGIN, ALLIANCE_ITERATION_END do
        ChromaConfig:ResetAllianceEffects(alliance, false)
      end
      if backgroundVars.UseCustomColorDuringBattlegrounds then
        for alliance = BATTLEGROUND_ALLIANCE_ITERATION_BEGIN, BATTLEGROUND_ALLIANCE_ITERATION_END do
          ChromaConfig:ResetAllianceEffects(alliance, true)
        end
      end
    end,
  })

  table.insert(optionsData, {
    type = "colorpicker",
    name = str.CUSTOM_BACKGROUND_COLOR,
    getFunc = function()
      return ZO_ColorDef:New(backgroundColor):UnpackRGB()
    end,
    setFunc = function(r, g, b)
      local color = ZO_ColorDef:New(r, g, b, 1)
      backgroundColor = color:ToHex()
      backgroundVars.BackgroundColor = backgroundColor
      for alliance = ALLIANCE_ITERATION_BEGIN, ALLIANCE_ITERATION_END do
        ChromaConfig:ResetAllianceEffects(alliance, false)
      end
      if backgroundVars.UseCustomColorDuringBattlegrounds then
        for alliance = BATTLEGROUND_ALLIANCE_ITERATION_BEGIN, BATTLEGROUND_ALLIANCE_ITERATION_END do
          ChromaConfig:ResetAllianceEffects(alliance, true)
        end
      end
    end,
    disabled = function()
      return not backgroundVars.BackgroundColor
    end,
  })

  table.insert(optionsData, {
    type = "checkbox",
    name = str.USE_DURING_BATTLEGROUND,
    getFunc = function()
      return backgroundVars.UseCustomColorDuringBattlegrounds
    end,
    setFunc = function(v)
      backgroundVars.UseCustomColorDuringBattlegrounds = v
      for alliance = BATTLEGROUND_ALLIANCE_ITERATION_BEGIN, BATTLEGROUND_ALLIANCE_ITERATION_END do
        ChromaConfig:ResetAllianceEffects(alliance, true)
      end
    end,
    disabled = function()
      return not backgroundVars.BackgroundColor
    end,
  })

  self.settingsMenuPanel = LibAddonMenu2:RegisterAddonPanel(ChromaConfig.ADDON_NAME.."SettingsMenuPanel", panel)
  LibAddonMenu2:RegisterOptionControls(ChromaConfig.ADDON_NAME.."SettingsMenuPanel", optionsData)
end
