ChromaConfig.variableVersion = 1
local defaultAccountVars = {
  Alliances = {
    [ALLIANCE_ALDMERI_DOMINION] = {
      UseCustomColor = true,
      Color = "ffd900",
    },
    [ALLIANCE_EBONHEART_PACT] = {
      UseCustomColor = true,
      Color = "ff0000",
    },
    [ALLIANCE_DAGGERFALL_COVENANT] = {
      UseCustomColor = true,
      Color = "0000ff",
    },
  },
  Teams = {
    [BATTLEGROUND_ALLIANCE_FIRE_DRAKES] = {
      UseCustomColor = true,
      Color = "ff6600",
    },
    [BATTLEGROUND_ALLIANCE_PIT_DAEMONS] = {
      UseCustomColor = true,
      Color = "70c733",
    },
    [BATTLEGROUND_ALLIANCE_STORM_LORDS] = {
      UseCustomColor = true,
      Color = "d90fff",
    },
  },
}

local defaultCharacterVars = {
  BackgroundColor = nil,
  UseCustomColorDuringBattlegrounds = false,
}

function ChromaConfig:InitializeSettings()
  ChromaConfig.accountVars = ZO_SavedVars:NewAccountWide(ChromaConfig.ADDON_NAME.."_AccountVars", ChromaConfig.variableVersion, nil, defaultAccountVars, GetWorldName())
  ChromaConfig.characterVars = ZO_SavedVars:NewCharacterIdSettings(ChromaConfig.ADDON_NAME.."_CharacterVars", ChromaConfig.variableVersion, nil, defaultCharacterVars, GetWorldName())
end
