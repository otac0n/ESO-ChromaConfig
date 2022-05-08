ChromaConfigSettingsMenu = ZO_Object:Subclass()

function ChromaConfigSettingsMenu:New()
  local obj = ZO_Object.New(self)
  obj:Initialize()
  return obj
end

function ChromaConfigSettingsMenu:Initialize()
  self:CreateOptionsMenu()
end

local str = ChromaConfig:GetStrings()
function ChromaConfigSettingsMenu:CreateOptionsMenu()
  local allianceVars = ChromaConfig.allianceVars
  local backgroundVars = ChromaConfig.backgroundVars
  local notificationVars = ChromaConfig.notificationVars

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

  local backgroundAccountCheckbox = backgroundVars:GetLibAddonMenuAccountCheckbox()
  local setFunc = backgroundAccountCheckbox.setFunc 
  local refresh
  backgroundAccountCheckbox.setFunc = function (...)
    setFunc(...)
    refresh()
    ChromaConfig:ResetAllianceEffects(nil, nil)
  end
  table.insert(optionsData, backgroundAccountCheckbox)

  refresh = self:AddToggleColorPicker(
    optionsData,
    str.BACKGROUND,
    function () return backgroundVars.BackgroundColor end,
    function (v)
      backgroundVars.BackgroundColor = v
      ChromaConfig:ResetAllianceEffects(nil, false)
      if backgroundVars.UseCustomColorDuringBattlegrounds then
        ChromaConfig:ResetAllianceEffects(nil, true)
      end
    end,
    GetAllianceColor(GetUnitAlliance("player")):ToHex()
  )

  table.insert(optionsData, {
    type = "checkbox",
    name = str.USE_DURING_BATTLEGROUND,
    getFunc = function()
      return backgroundVars.UseCustomColorDuringBattlegrounds
    end,
    setFunc = function(v)
      backgroundVars.UseCustomColorDuringBattlegrounds = v
      ChromaConfig:ResetAllianceEffects(nil, true)
    end,
    disabled = function()
      return not backgroundVars.BackgroundColor
    end,
  })

  table.insert(optionsData, {
    type = "header",
    name = str.NOTIFICATION_COLORS,
  })

  local notificationAccountCheckbox = notificationVars:GetLibAddonMenuAccountCheckbox()
  local setFunc = notificationAccountCheckbox.setFunc 
  local refresh
  notificationAccountCheckbox.setFunc = function (...)
    setFunc(...)
    refresh()
    ChromaConfig:ResetDeathEffects()
  end
  table.insert(optionsData, notificationAccountCheckbox)

  refresh = self:AddToggleColorPicker(
    optionsData,
    str.DEATH_EFFECT,
    function () return notificationVars.DeathEffectColor end,
    function (v)
      notificationVars.DeathEffectColor = v
      ChromaConfig:ResetDeathEffects()
    end,
    "ff0000"
  )

  self.settingsMenuPanel = LibAddonMenu2:RegisterAddonPanel(ChromaConfig.ADDON_NAME.."SettingsMenuPanel", panel)
  LibAddonMenu2:RegisterOptionControls(ChromaConfig.ADDON_NAME.."SettingsMenuPanel", optionsData)
end

function ChromaConfigSettingsMenu:AddToggleColorPicker(optionsData, name, getFunc, setFunc, default)
  local intendedColor
  local function refresh()
    intendedColor = getFunc() or default
    if type(intendedColor) ~= "string" then
      intendedColor = "000000"
    end
  end

  table.insert(optionsData, {
    type = "checkbox",
    name = zo_strformat(str.USE_CUSTOM_X_COLOR, name),
    getFunc = function()
      return getFunc() ~= nil
    end,
    setFunc = function(v)
      setFunc(v and intendedColor or nil)
    end,
  })

  table.insert(optionsData, {
    type = "colorpicker",
    name = zo_strformat(str.CUSTOM_X_COLOR, name),
    getFunc = function()
      return ZO_ColorDef:New(intendedColor):UnpackRGB()
    end,
    setFunc = function(r, g, b)
      local color = ZO_ColorDef:New(r, g, b, 1)
      intendedColor = color:ToHex()
      setFunc(intendedColor)
    end,
    disabled = function()
      return not getFunc()
    end,
  })

  refresh()
  return refresh
end
