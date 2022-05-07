ChromaConfigSettings = ZO_Object:Subclass()

function ChromaConfigSettings:New()
  local obj = ZO_Object.New(self)
  obj:Initialize()
  return obj
end

function ChromaConfigSettings:Initialize()
  self:LoadSettings()
  self:CreateOptionsMenu()
end

function ChromaConfigSettings:LoadSettings()
end

function ChromaConfigSettings:CreateOptionsMenu()
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
      type = "colorpicker",
      name = str.ALLIANCES[alliance].NAME,
      tooltip = str.ALLIANCES[alliance].TOOLTIP,
      getFunc = function()
        return ChromaConfig.ALLIANCE_COLORS[alliance]:UnpackRGB()
      end,
      setFunc = function(r, g, b)
        ChromaConfig.ALLIANCE_COLORS[alliance] = ZO_ColorDef:New(r, g, b, 1)
        ChromaConfig:ResetAllianceEffects()
      end,
    })
  end

  self.settingsPanel = LibAddonMenu2:RegisterAddonPanel(ChromaConfig.ADDON_NAME.."SettingsPanel", panel)
  LibAddonMenu2:RegisterOptionControls(ChromaConfig.ADDON_NAME.."SettingsPanel", optionsData)
end
