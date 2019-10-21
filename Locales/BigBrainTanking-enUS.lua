local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("BigBrainTanking", "enUS", true)
if not L then return end

-- Addon information
L["BigBrainTanking"] = "BigBrainTanking"
L["Version"] = "Version"
L["BBTEnabled"] = "|cff9933ffBigBrainTanking addon enabled."
L["BBTDisabled"] = "|cff9933ffBigBrainTanking addon disabled."

-- Configuration frame name
L["BBT Option"] = "BigBrainTanking"

-- Configuration strings
L["Profiles"] = "Profiles"

L["GeneralSettings"] = "General Settings"
L["BBTDescription"] = [[
BigBrainTanking is an addon that is aimed to assist you with tanking chores.
]]

L["BBTDescriptionFooter"] = [[

|cffffd000Salvation|cffffffff
Addon is able to automatically remove Blessing of Salvation (-30% threat buff) from you. You can fast-toggle whether you want it removed or not with "/bbt salv on" and "/bbt salv off".

|cffffd000Warnings|cffffffff
You can setup warnings whenever your key abilities get resisted or missed, when you interrupt spell cast or activate an ability/item. Check out warning settings subcategory in addon's options. 
]]

L["INSPIRED_BY"] = "Inspired by"

L["On"] = "On"
L["Off"] = "Off"

L["SlashCommand"] = "Slash Command"

-- General
L["EnableBBT"] = "Enable BigBrainTanking"
L["EnableBBTDescription"] = "Enables or disables BigBrainTanking both now and also on login."
L["OnDescription"] = "Enables addon."
L["OffDescription"] = "Disables addon."
L["ABOUT_VERSION"] = "Version"
L["ABOUT_AUTHOR"] = "Author"

-- Salvation 
L["EnableBBTSalvRemoval"] = "Enable Salvation removal"
L["EnableBBTSalvRemovalDescription"] = "Enables or disables automatic salvation removal."
L["SalvRemoved"] = "[BBT] Salvation removed!"
L["SalvRemovalOnDescription"] = "Enables salvation removal."
L["SalvRemovalOffDescription"] = "Disables salvation removal."
L["SalvationCommand"] = "Enable/Disable salvation removal"
L["SalvRemovalEnabled"] = "[BBT] Salvation removal enabled!"
L["SalvRemovalDisabled"] = "[BBT] Salvation removal disabled!"
L["SalvBuffName"] = "Blessing of Salvation"

-- Warnings
L["WarningSettings"] = "Warning Settings"
L["WarningSettingsDescription"] = [[
Control whether and how warnings should be shown.
]]
L["EnableBBTWarnings"] = "Enable warnings"
L["EnableBBTWarningsDescription"] = "Enables or disables warnings about taunt resists, mocking blow misses, etc."

L["EnableBBTWarningsExpiration"] = "Enable expiration warnings"
L["EnableBBTWarningsExpirationDescription"] = "Enables or disables expiration warning announcements about shield wall and last stand."


L["Last Stand"] = "Last Stand"
L["Shield Wall"] = "Shield Wall"
L["Challenging Shout"] = "Challenging Shout"
L["Taunt"] = "Taunt"
L["Mocking Blow"] = "Mocking Blow"
L["Challenging Roar"] = "Challenging Roar"
L["Growl"] = "Growl"

L["%s activated!"] = "%s activated!"
L["%s will expire in 3 seconds!"] = "%s will expire in 3 seconds!"

L["Lifegiving Gem"] = "Lifegiving Gem"
L["Shield Bash"] = "Shield Bash"
L["Pummel"] = "Pummel"
L["AnnouncementSetup"] = "Announcement Setup"