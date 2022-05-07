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
  local accountVars = ChromaConfig.accountVars
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
    table.insert(optionsData, {
      type = "checkbox",
      name = zo_strformat(str.USE_CUSTOM_X_COLOR, str.ALLIANCES[alliance].NAME),
      getFunc = function()
        return accountVars.Alliances[alliance].UseCustomColor
      end,
      setFunc = function(v)
        accountVars.Alliances[alliance].UseCustomColor = v
        ChromaConfig:ResetAllianceEffects(alliance, false)
      end,
    })

    table.insert(optionsData, {
      type = "colorpicker",
      name = zo_strformat(str.CUSTOM_X_COLOR, str.ALLIANCES[alliance].NAME),
      tooltip = str.ALLIANCES[alliance].TOOLTIP,
      getFunc = function()
        return ZO_ColorDef:New(accountVars.Alliances[alliance].Color):UnpackRGB()
      end,
      setFunc = function(r, g, b)
        local color = ZO_ColorDef:New(r, g, b, 1)
        accountVars.Alliances[alliance].Color = color:ToHex()
        ChromaConfig:ResetAllianceEffects(alliance, false)
      end,
      disabled = function()
        return not accountVars.Alliances[alliance].UseCustomColor
      end,
    })
  end
  
  table.insert(optionsData, {
    type = "header",
    name = str.BATTLEGROUNDS_HEADER,
  })

  for alliance = BATTLEGROUND_ALLIANCE_ITERATION_BEGIN, BATTLEGROUND_ALLIANCE_ITERATION_END do
    table.insert(optionsData, {
      type = "checkbox",
      name = zo_strformat(str.USE_CUSTOM_X_COLOR, str.BATTLEGROUND_ALLIANCES[alliance].NAME),
      getFunc = function()
        return accountVars.Teams[alliance].UseCustomColor
      end,
      setFunc = function(v)
        accountVars.Teams[alliance].UseCustomColor = v
        ChromaConfig:ResetAllianceEffects(alliance, true)
      end,
    })

    table.insert(optionsData, {
      type = "colorpicker",
      name = zo_strformat(str.CUSTOM_X_COLOR, str.BATTLEGROUND_ALLIANCES[alliance].NAME),
      tooltip = str.BATTLEGROUND_ALLIANCES[alliance].TOOLTIP,
      getFunc = function()
        return ZO_ColorDef:New(accountVars.Teams[alliance].Color):UnpackRGB()
      end,
      setFunc = function(r, g, b)
        local color = ZO_ColorDef:New(r, g, b, 1)
        accountVars.Teams[alliance].Color = color:ToHex()
        ChromaConfig:ResetAllianceEffects(alliance, true)
      end,
      disabled = function()
        return not accountVars.Teams[alliance].UseCustomColor
      end,
    })
  end

  self.settingsMenuPanel = LibAddonMenu2:RegisterAddonPanel(ChromaConfig.ADDON_NAME.."SettingsMenuPanel", panel)
  LibAddonMenu2:RegisterOptionControls(ChromaConfig.ADDON_NAME.."SettingsMenuPanel", optionsData)
end
