ChromaConfigSettingsMenu = ZO_Object:Subclass()

function ChromaConfigSettingsMenu:New()
  local obj = ZO_Object.New(self)
  obj:Initialize()
  return obj
end

function ChromaConfigSettingsMenu:Initialize()
  self:LoadSettings()
  self:CreateOptionsMenu()
end

function ChromaConfigSettingsMenu:LoadSettings()
end

function ChromaConfigSettingsMenu:CreateOptionsMenu()
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

  local optionsData = { }

  table.insert(optionsData, {
    type = "header",
    name = str.ALLIANCE_HEADER,
  })

  for alliance = ALLIANCE_ITERATION_BEGIN, ALLIANCE_ITERATION_END do
    local intendedValue
    table.insert(optionsData, {
      type = "checkbox",
      name = zo_strformat(str.USE_CUSTOM_X_COLOR, str.ALLIANCES[alliance].NAME),
      getFunc = function()
        return ChromaConfig.ALLIANCE_COLORS[alliance] ~= nil
      end,
      setFunc = function(v)
        ChromaConfig.ALLIANCE_COLORS[alliance] = (v and intendedValue or nil)
        ChromaConfig:ResetAllianceEffects(alliance, false)
      end,
    })
    table.insert(optionsData, {
      type = "colorpicker",
      name = zo_strformat(str.CUSTOM_X_COLOR, str.ALLIANCES[alliance].NAME),
      tooltip = str.ALLIANCES[alliance].TOOLTIP,
      getFunc = function()
        if not intendedValue then
          intendedValue = ChromaConfig.ALLIANCE_COLORS[alliance] or GetAllianceColor(alliance)
        end
        local color = intendedValue
        return color:UnpackRGB()
      end,
      setFunc = function(r, g, b)
        intendedValue = ZO_ColorDef:New(r, g, b, 1)
        ChromaConfig.ALLIANCE_COLORS[alliance] = intendedValue
        ChromaConfig:ResetAllianceEffects(alliance, false)
      end,
      disabled = function()
        return not ChromaConfig.ALLIANCE_COLORS[alliance]
      end
    })
  end
  
  table.insert(optionsData, {
    type = "header",
    name = str.BATTLEGROUNDS_HEADER,
  })

  for alliance = ALLIANCE_ITERATION_BEGIN, ALLIANCE_ITERATION_END do
    local intendedValue
    table.insert(optionsData, {
      type = "checkbox",
      name = zo_strformat(str.USE_CUSTOM_X_COLOR, str.BATTLEGROUND_ALLIANCES[alliance].NAME),
      getFunc = function()
        return ChromaConfig.TEAM_COLORS[alliance] ~= nil
      end,
      setFunc = function(v)
        ChromaConfig.TEAM_COLORS[alliance] = (v and intendedValue or nil)
        ChromaConfig:ResetAllianceEffects(alliance, true)
      end,
    })
    table.insert(optionsData, {
      type = "colorpicker",
      name = zo_strformat(str.CUSTOM_X_COLOR, str.BATTLEGROUND_ALLIANCES[alliance].NAME),
      tooltip = str.BATTLEGROUND_ALLIANCES[alliance].TOOLTIP,
      getFunc = function()
        if not intendedValue then
          intendedValue = ChromaConfig.TEAM_COLORS[alliance] or GetBattlegroundAllianceColor(alliance)
        end
        local color = intendedValue
        return color:UnpackRGB()
      end,
      setFunc = function(r, g, b)
        intendedValue = ZO_ColorDef:New(r, g, b, 1)
        ChromaConfig.TEAM_COLORS[alliance] = intendedValue
        ChromaConfig:ResetAllianceEffects(alliance, true)
      end,
      disabled = function()
        return not ChromaConfig.TEAM_COLORS[alliance]
      end
    })
  end

  self.settingsMenuPanel = LibAddonMenu2:RegisterAddonPanel(ChromaConfig.ADDON_NAME.."SettingsMenuPanel", panel)
  LibAddonMenu2:RegisterOptionControls(ChromaConfig.ADDON_NAME.."SettingsMenuPanel", optionsData)
end
