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
    local intendedValue
    table.insert(optionsData, {
      type = "checkbox",
      name = zo_strformat(str.ALLIANCE_USE_CUSTOM_COLOR, str.ALLIANCES[alliance].NAME),
      getFunc = function()
        return ChromaConfig.ALLIANCE_COLORS[alliance] ~= nil
      end,
      setFunc = function(v)
        ChromaConfig.ALLIANCE_COLORS[alliance] = (v and intendedValue or nil)
        ChromaConfig:ResetAllianceEffects()
      end,
    })
    table.insert(optionsData, {
      type = "colorpicker",
      name = zo_strformat(str.ALLIANCE_CUSTOM_COLOR, str.ALLIANCES[alliance].NAME),
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
        ChromaConfig:ResetAllianceEffects()
      end,
      disabled = function()
        return not ChromaConfig.ALLIANCE_COLORS[alliance]
      end
    })
  end

  self.settingsPanel = LibAddonMenu2:RegisterAddonPanel(ChromaConfig.ADDON_NAME.."SettingsPanel", panel)
  LibAddonMenu2:RegisterOptionControls(ChromaConfig.ADDON_NAME.."SettingsPanel", optionsData)
end
