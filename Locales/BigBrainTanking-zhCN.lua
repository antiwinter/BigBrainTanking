local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("BigBrainTanking", "zhCN")
if not L then return end

-- Addon information
L["BigBrainTanking"] = "BigBrainTanking"
L["Version"] = "Version"
L["BBTEnabled"] = "|cff9933ffBigBrainTanking 已启用"
L["BBTDisabled"] = "|cff9933ffBigBrainTanking 已禁用"

-- Configuration frame name
L["BBT Option"] = "BigBrainTanking"

-- Configuration strings
L["Profiles"] = "配置文件"

L["GeneralSettings"] = "一般设置"
L["BBTDescription"] = [[
BigBrainTanking 是一个坦克助手插件,能帮助你警报各种坦克技能/物品,和其他一些便捷功能
]]

L["BBTDescriptionFooter"] = [[

|cffffd000自动拯救移除|cffffffff
插件可以自动从你身上移除拯救祝福（-30%仇恨）. 你可以使用“/bbt salv on”和“/bbt salv off”快速切换是否要删除它

|cffffd000自动技能警报|cffffffff
你可以设置警告,每当你的关键技能被抵制或miss时,或者当你使用打断技能或激活一个技能/物品时
]]

L["INSPIRED_BY"] = "Inspired by"

L["On"] = "On"
L["Off"] = "Off"

L["SlashCommand"] = "Slash Command"

-- General
L["EnableBBT"] = "启用 BigBrainTanking"
L["EnableBBTDescription"] = "启用/禁用 BigBrainTanking"
L["OnDescription"] = "启用插件"
L["OffDescription"] = "禁用插件"
L["ABOUT_VERSION"] = "Version"
L["ABOUT_AUTHOR"] = "Author"

-- Salvation 
L["EnableBBTSalvRemoval"] = "启用 拯救移除"
L["EnableBBTSalvRemovalDescription"] = "启用或禁用自动拯救移除功能"
L["SalvRemoved"] = "[BBT] 拯救已移除!"
L["SalvRemovalOnDescription"] = "启用 拯救移除"
L["SalvRemovalOffDescription"] = "禁用 拯救移除"
L["SalvationCommand"] = "启用/禁用 自动拯救移除"
L["SalvRemovalEnabled"] = "[BBT] 自动拯救移除已启用!"
L["SalvRemovalDisabled"] = "[BBT] 自动拯救移除已禁用!"
L["SalvBuffName"] = "拯救祝福"

-- Warnings
L["AnnouncementSetup"] = "通告设置"
L["WarningSettings"] = "警报设置"
L["WarningSettingsDescription"] = [[
控制是否以及如何显示警告
]]
L["EnableBBTWarnings"] = "启用 警报"
L["EnableBBTWarningsDescription"] = "启用或禁用关于嘲讽抵抗、惩戒痛击未命中等的警告"

L["EnableBBTWarningsExpiration"] = "启用 过期警告"
L["EnableBBTWarningsExpirationDescription"] = "启用或禁用有关盾墙墙和破釜沉舟的过期警告通知"


L["ABILITY_LASTSTAND"] = "破釜沉舟"
L["ABILITY_SHIELDWALL"] = "盾墙"
L["ABILITY_CHALLENGINGSHOUT"] = "挑战怒吼"
L["ABILITY_TAUNT"] = "嘲讽"
L["ABILITY_MOCKINGBLOW"] = "惩戒痛击"
L["ABILITY_CHALLENGINGROAR"] = "挑战咆哮"
L["ABILITY_GROWL"] = "低吼"

--- Interrupts
L["ABILITY_SHIELDBASH"] = "盾击"
L["ABILITY_PUMMEL"] = "拳击"

--- Items
L["ITEM_LIFEGIVINGGEM"] = "生命宝石"

--- Statuses
L["ABILITY_ACTIVATED"] = "%s 已激活! 加好我!"
L["ABILITY_RESISTED"] = "%s 被抵抗!"
L["ABILITY_EXPIRATION"] = "%s 将在 %s 秒后过期!"
L["ABILITY_INTERRUPT"] = "%s 的 -%s- 被 %s 打断了!"

-- Announcments
L["ANNOUNCEMENT_TAUNT_RESIST"] = "- 我的嘲讽被 $tn! 抵抗了! -";
L["ANNOUNCEMENT_MB_FAIL"] = "- 我的惩戒痛击未击中 $tn! -";
L["ANNOUNCEMENT_PM_HIT"] = "使用拳击打断了 $tn!";
L["ANNOUNCEMENT_PM_MISS"] = "拳击未命中!";
L["ANNOUNCEMENT_SB_HIT"] = "使用盾击打断了 $tn!";
L["ANNOUNCEMENT_SB_MISS"] = "盾击未命中!";
L["ANNOUNCEMENT_LS_ACTIVATION"] = "- 我激活了破釜沉舟! $sec 秒内我将损失 $hpHP! 加好我! -";
L["ANNOUNCEMENT_SW_ACTIVATION"] = "- 我激活了盾墙! $sec 秒内我将降低75%的伤害! -";
L["ANNOUNCEMENT_LG_ACTIVATION"] = "- 我激活了生命宝石! $sec 秒内我将损失 $hpHP! 加好我! -";
L["ANNOUNCEMENT_CS_ACTIVATION"] = "- 我使用了挑战怒吼! $sec 秒内我将大出血! 加好我! -";
L["ANNOUNCEMENT_GROWL_RESIST"] = "- 我的低吼被 $tn 抵抗了! -";
L["ANNOUNCEMENT_CR_ACTIVATION"] = "- 我使用了挑战咆哮! $sec 秒内我将大出血! 加好我! -";

