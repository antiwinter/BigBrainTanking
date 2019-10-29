local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local HBD = LibStub("HereBeDragons-2.0")
local HBDP = LibStub("HereBeDragons-Pins-2.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("BigBrainTanking")
local AceGUI = LibStub("AceGUI-3.0")
local addonName = ...
local _

local playerGUID = UnitGUID("player")

BBT = LibStub("AceAddon-3.0"):NewAddon("BigBrainTanking", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0")
BBT.Version = GetAddOnMetadata(addonName, 'Version')
BBT.Author = GetAddOnMetadata(addonName, "Author") 
BBT.DebugPrintEnabled = true

BBT.AnnouncementChannels = {
	"say", "yell", "party", "raid", "raid_warning" 
}

BBT.Options = {
	name = L["BigBrainTanking"],
	type = "group",
	args = {
		General = {
			name = L["GeneralSettings"],
			desc = L["GeneralSettings"],
			type = "group",
			order = 1,
			args = {
				Description = {
					name = L["BBTDescription"],
					type = "description",
					order = 1,
				},
				Enabled = {
					name = L["EnableBBT"],
					desc = L["EnableBBTDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return BBT:IsEnabled()
					end,
					set = function(info, value)
						BBT:Enable(value)
					end,
				},
				SalvRemovalEnabled = {
					name = L["EnableBBTSalvRemoval"],
					desc = L["EnableBBTSalvRemovalDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return BBT:IsSalvRemovalEnabled()
					end,
					set = function(info, value)
						BBT:EnableSalvRemoval(value)
					end,
				},
				DescriptionFooter = {
					name = L["BBTDescriptionFooter"],
					type = "description",
					order = 4,
				},
				About = {
					name = "About",
					type = "group", inline = true,
					args = {
						VersionDesc = {
							order = 1,
							type = "description",
							name = "|cffffd700"..L["ABOUT_VERSION"]..": "
								.._G["GREEN_FONT_COLOR_CODE"]..BBT.Version,
							cmdHidden = true
						},
						AuthorDesc = {
							order = 2,
							type = "description",
							name = "|cffffd700"..L["ABOUT_AUTHOR"]..": "
								.."|cffff8c00"..BBT.Author,
							cmdHidden = true
						},
						InspireByDesc = {
							order = 3,
							type = "description",
							name = "|cffffd700"..L["INSPIRED_BY"]..": "
								.."|cffffffffTankWarningsClassic, NoSalv (benjen), TankBuddy, SimpleInterruptAnnounce",
							cmdHidden = true
						},
					}
				}
			},
		},
		WarningSettings = {
			name = L["WarningSettings"],
			desc = L["WarningSettings"],
			type = "group",
			order = 2,
			args = {
				Description = {
					name = L["WarningSettingsDescription"],
					type = "description",
					order = 1,
				},
				WarningsEnabled = {
					name = L["EnableBBTWarnings"],
					desc = L["EnableBBTWarningsDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return BBT:IsWarningsEnabled()
					end,
					set = function(info, value)
						BBT:EnableWarnings(value)
					end,
				},
				WarningsExpirationEnabled = {
					name = L["EnableBBTWarningsExpiration"],
					desc = L["EnableBBTWarningsExpirationDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return BBT:IsWarningExpirationsEnabled()
					end,
					set = function(info, value)
						BBT:EnableWarningExpirations(value)
					end,
				},
				WarriorSettingsHeader = {
					name = L["AnnouncementSetup"],
					type = "header",
					order = 4,
					width = "full"
				},
				-- order = 5 filled with Class speicifc settings (Warrior/Druid)
				-- order = 6 filled with Item specific settings (Lifegiving Gem, etc)
			}
		},
		
	},
}

BBT.OptionsSlash = {
	name = L["SlashCommand"],
	order = -3,
	type = "group",
	args = {
		on = {
			name = L["On"],
			desc = L["OnDescription"],
			type = 'execute',
			order = 1,
			func = function()
				BBT:Enable(true)
			end,
		},
		off = {
			name = L["Off"],
			desc = L["OffDescription"],
			type = 'execute',
			order = 2,
			func = function()
				BBT:Enable(false)
			end,
		},
		salv = {
			name = L["SalvationCommand"],
			order = 3,
			type = "group",
			args = {
				on = {
					name = L["On"],
					desc = L["SalvRemovalOnDescription"],
					type = 'execute',
					order = 1,
					func = function()
						BBT:EnableSalvRemoval(true)
					end,
				},
				off = {
					name = L["Off"],
					desc = L["SalvRemovalOffDescription"],
					type = 'execute',
					order = 2,
					func = function()
						BBT:EnableSalvRemoval(false)
					end,
				},
			}
			
		},
		
	}
}

local Default_Profile = {
	profile = {
		IsEnabled = true,
		IsSalvRemovalEnabled = true,
		Warnings = {
			IsEnabled = true,
			AnnounceExpirations  = true,
			Abilities = {
				Warrior = {
					[L["ABILITY_LASTSTAND"]] = { "Interface\\Icons\\Spell_Holy_AshesToAshes", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } } 					
					},
					[L["ABILITY_SHIELDWALL"]] = { "Interface\\Icons\\Ability_Warrior_ShieldWall", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } } 
					},
					[L["ABILITY_CHALLENGINGSHOUT"]] = { "Interface\\Icons\\Ability_BullRush", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } } 
					},
					[L["ABILITY_TAUNT"]] = { "Interface\\Icons\\Spell_Nature_Reincarnation", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } }  
					},
					[L["ABILITY_MOCKINGBLOW"]] = { "Interface\\Icons\\Ability_Warrior_PunishingBlow", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } }  
					},
					[L["ABILITY_SHIELDBASH"]] = { "Interface\\Icons\\ability_warrior_shieldbash", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "yell", "raid" } }  
					},
					[L["ABILITY_PUMMEL"]] = { "Interface\\Icons\\inv_gauntlets_04", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "yell", "raid" } }  
					},
				},
				Druid = {
					[L["ABILITY_CHALLENGINGROAR"]] = { "Interface\\Icons\\Ability_Druid_ChallangingRoar", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } }  
					},
					[L["ABILITY_GROWL"]] = { "Interface\\Icons\\Ability_Physical_Taunt", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } }  
					},
				}			
			},
			Items = {
				[L["ITEM_LIFEGIVINGGEM"]] = { "Interface\\Icons\\INV_Misc_Gem_Pearl_05", 
				{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "yell", "raid_warning" } }  
				},
			}
		},
	}
}

-- Strings used to insert a raid icon in chat message
BBT.RaidIconChatStrings = {
	'{rt1}', '{rt2}', '{rt3}', '{rt4}',
	'{rt5}', '{rt6}', '{rt7}', '{rt8}',
}

-- Table for looking up raid icon id from destFlags
BBT.RaidIconLookup = {
	[COMBATLOG_OBJECT_RAIDTARGET1]=1,
	[COMBATLOG_OBJECT_RAIDTARGET2]=2,
	[COMBATLOG_OBJECT_RAIDTARGET3]=3,
	[COMBATLOG_OBJECT_RAIDTARGET4]=4,
	[COMBATLOG_OBJECT_RAIDTARGET5]=5,
	[COMBATLOG_OBJECT_RAIDTARGET6]=6,
	[COMBATLOG_OBJECT_RAIDTARGET7]=7,
	[COMBATLOG_OBJECT_RAIDTARGET8]=8,
}

-- Get string for raid icon
function BBT:GetRaidIconString(raidIcon)
	local s = ''

	if raidIcon then
		s = BBT.RaidIconChatStrings[raidIcon]
	end

	return s
end

function BBT:ResetProfile()
	BBT.db.profile = Default_Profile.profile
end

function BBT:HandleProfileChanges()
end

function BBT:OnInitialize()
	self:Print("Initializing v" .. BBT.Version .. "...")
	
	local acedb = LibStub:GetLibrary("AceDB-3.0")
	self.db = acedb:New("BigBrainTankingDB", Default_Profile)
	self.db.RegisterCallback(self, "OnNewProfile", "ResetProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "ResetProfile")
	self.db.RegisterCallback(self, "OnProfileChanged", "HandleProfileChanges")
	self.db.RegisterCallback(self, "OnProfileCopied", "HandleProfileChanges")
	self:SetupOptions()
	
	self:Print("Initializing finished!")
end

function BBT:RegisterModuleOptions(name, optionTbl, displayName)
	BBT.Options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.OptionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BigBrainTanking", displayName, L["BBT Option"], name)
end

function BBT:FindActiveChannelIndex(ability, presence, channel) 
	local ActiveChannels = (((BBT.db.profile.Warnings.Abilities.Warrior[ability])[2])[presence])

	for index, value in ipairs(ActiveChannels) do
		if value == channel then
			return index
		end
	end
end

function BBT:IsAnnouncementActive(ability, presence, channel)
	local ActiveChannels = (((BBT.db.profile.Warnings.Abilities.Warrior[ability])[2])[presence])
	
	for index, value in ipairs(ActiveChannels) do
		if value == channel then
			return true
		end
	end
	
	return false
end

function BBT:SetAnnouncementActive(ability, presence, channel, state)
	local ActiveChannels = (((BBT.db.profile.Warnings.Abilities.Warrior[ability])[2])[presence])
	
	local index = self:FindActiveChannelIndex(ability, presence, channel)
	--self:Print("Index: " .. index)
	--self:Print("State: " .. tostring(state))
	
	if index == nil and state == true then
		--self:Print("Checked")
		table.insert(ActiveChannels, channel)
	end
	
	if index ~= nil and state == false then
		--self:Print("Unckecked")
		table.remove(ActiveChannels, index)
	end
	
end

function GetAnnouncementSetting(keys, index) 
	presenceType = keys[#keys] -- Alone/Party/Raid
	keyName = keys[#keys-1] -- Pummel/Life Giving Gem/etc
	
	--self:Print("presenceType: " .. keys[#keys] .. " | keyName: " .. keyName .. " | index: " .. index)
	
	local ChannelCheckbox = BBT.AnnouncementChannels[index]
	--self:Print("channelCheckbox: " .. ChannelCheckbox)

	return BBT:IsAnnouncementActive(keyName, presenceType, ChannelCheckbox)
end

function SetAnnouncementSetting(keys, index, state)
	presenceType = keys[#keys] -- Alone/Party/Raid
	keyName = keys[#keys-1] -- Pummel/Life Giving Gem/etc
	
	local ChannelCheckbox = BBT.AnnouncementChannels[index]
	--self:Print("channelCheckbox: " .. ChannelCheckbox)
	
	BBT:SetAnnouncementActive(keyName, presenceType, ChannelCheckbox, state)
end

function BBT:GenerateAnnounceSettings(itemTable) 
	local AnnounceSettingsTable = {}

	for key, value in pairs(itemTable) do
		local AnnounceSetting = {
			name = key,
			desc = key,
			type = "group",
			order = #AnnounceSettingsTable+1,
			width = "full",
			icon = value[1], 
			args = {
				Alone = { 
					name = "Alone",
					type = "multiselect",
					order = 1,
					tristate = false,
					values = BBT.AnnouncementChannels,
					get = GetAnnouncementSetting,
					set = SetAnnouncementSetting,
				},
				Party = { 
					name = "Party",
					type = "multiselect",
					order = 2,
					tristate = false,
					values = BBT.AnnouncementChannels,
					get = GetAnnouncementSetting,
					set = SetAnnouncementSetting,
				},
				Raid = { 
					name = "Raid",
					type = "multiselect",
					order = 3,
					tristate = false,
					values = BBT.AnnouncementChannels,
					get = GetAnnouncementSetting,
					set = SetAnnouncementSetting,
				},
			},
		}
		
		AnnounceSettingsTable[key] = AnnounceSetting
	end
	
	return AnnounceSettingsTable
end

function BBT:SetupOptions()
	-- Dynamic	
	local playerClass, englishClass = UnitClass("player")
	
	local AnnounceSettingsTable = nil
	
	if englishClass == "WARRIOR" then
		AnnounceSettingsTable = self:GenerateAnnounceSettings(Default_Profile.profile.Warnings.Abilities.Warrior)
	end
	
	if englishClass == "DRUID" then
		AnnounceSettingsTable = self:GenerateAnnounceSettings(Default_Profile.profile.Warnings.Abilities.Druid)
	end

	BBT.Options.args.WarningSettings.args["Abilities"] =  {
		name = "Abilities",
		desc = "Abilities",
		--disabled = true,
		type = "group",
		order = 5,
		width = "full",
		args = AnnounceSettingsTable
	}
	
	
	local ItemAnnounceTable = self:GenerateAnnounceSettings(Default_Profile.profile.Warnings.Items)
	
	BBT.Options.args.WarningSettings.args["Items"] =  {
		name = "Items",
		desc = "Items",
		disabled = true,
		type = "group",
		order = 6,
		width = "full",
		args = ItemAnnounceTable
	}
	
	-- 
	self.OptionsFrames = {}	

	local ACD3 = LibStub("AceConfigDialog-3.0")
 	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BigBrainTanking", BBT.Options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("BigBrainTanking Commands", BBT.OptionsSlash, "bbt")
	
	self.OptionsFrames.BBT = ACD3:AddToBlizOptions("BigBrainTanking", L["BBT Option"], nil, "General")
	self.OptionsFrames.WarningSettings = ACD3:AddToBlizOptions("BigBrainTanking", L["WarningSettings"], L["BBT Option"], "WarningSettings")
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), L["Profiles"])
end

function BBT:Enable(value)
	BBT.db.profile.IsEnabled = value
	
	if value then
		BBT:OnEnable()
		DEFAULT_CHAT_FRAME:AddMessage(L["BBTEnabled"])
	else
		BBT:OnDisable()
		DEFAULT_CHAT_FRAME:AddMessage(L["BBTDisabled"])
	end
end

function BBT:EnableSalvRemoval(value)
	BBT.db.profile.IsSalvRemovalEnabled = value
	
	if value then
		BBT:OnEnable()
		DEFAULT_CHAT_FRAME:AddMessage(L["SalvRemovalEnabled"])
	else
		BBT:OnDisable()
		DEFAULT_CHAT_FRAME:AddMessage(L["SalvRemovalDisabled"])
	end
end

function BBT:IsEnabled()
	return BBT.db.profile.IsEnabled
end

function BBT:IsSalvRemovalEnabled() 
	return BBT.db.profile.IsSalvRemovalEnabled
end

function BBT:CancelSalvBuff()
	-- CancelUnitBuff not working in combat
	if InCombatLockdown() then
		return
	end

	local counter = 1
	while UnitBuff("player", counter) do
		local name = UnitBuff("player", counter)
		if string.find(name, L["SalvBuffName"]) then
			CancelUnitBuff("player", counter)
			DEFAULT_CHAT_FRAME:AddMessage(L["SalvRemoved"])
			return
		end
		counter = counter + 1
	end
end

function BBT:OnUnitAuraEvent(eventName, unitTarget)
	self:PrintDebug(string.format("OnUnitAuraEvent, untitTarget: %s", unitTarget))

	if self:IsSalvRemovalEnabled() and unitTarget == "player" then
		self:CancelSalvBuff()
	end
end

function BBT:IsWarningsEnabled()
	return BBT.db.profile.Warnings.IsEnabled
end

function BBT:EnableWarnings(value)
	BBT.db.profile.Warnings.IsEnabled = value
end

function BBT:IsWarningExpirationsEnabled()
	return BBT.db.profile.Warnings.AnnounceExpirations
end

function BBT:EnableWarningExpirations(value)
	BBT.db.profile.Warnings.AnnounceExpirations = value
end

function BBT:GetChannelsToWarn(ability)
	local presence = IsInRaid() and "Raid" or (IsInGroup() and "Party" or "Alone")
	
	local abilityAnnounceTable = BBT.db.profile.Warnings.Abilities.Warrior[ability]
	
	if abilityAnnounceTable == nil then
		return nil
	end
	
	local channelsToWarn = abilityAnnounceTable[2][presence]
	return channelsToWarn
end

function BBT:SendWarningMessage(message, ability)
	if not self:IsWarningsEnabled() then
		return
	end
	
	local channels = self:GetChannelsToWarn(ability)
	
	if channels == nil then
		return
	end

	for index, channel in ipairs(channels) do
		--self:Print("channel to warn (" .. index .. "): " .. channel)
		SendChatMessage(message, channel, "Common")
	end
end

BBT.BuffTimers = {}

function BBT:KillBuffExpirationTimer(buffName) 
	if BBT.BuffTimers[buffName] ~= nil then
		self:PrintDebug(string.format("Removed %s from expiration timers, since it was canceled", buffName))
		self:CancelTimer(BBT.BuffTimers[buffName])
		BBT.BuffTimers[buffName] = nil
	end
end

function BBT:KillBuffExpirationTimers() 
	for key, timerID in pairs(BBT.BuffTimers) do
		self:KillBuffExpirationTimer(key)
	end
end

function BBT:OnPlayerDead()
	self:PrintDebug("BBT:OnPlayerDead")

	self:KillBuffExpirationTimers()
end

function BBT:OnBuffExpiration(spellName, warnSecBeforeExpire)
	self:PrintDebug(string.format("BBT:OnBuffExpiration(%s, %f)", spellName, warnSecBeforeExpire))

	BBT.BuffTimers[spellName] = nil -- remove from timer handles

	if UnitIsDeadOrGhost("player") ~= true then
		self:SendWarningMessage(string.format(L["ABILITY_EXPIRATION"], spellName, warnSecBeforeExpire), spellName)
	end
end

function BBT:PrintDebug(...)
	if self.DebugPrintEnabled ~= true then
		return
	end

	self:Print(...)
end

function BBT:OnCombatLogEventUnfiltered() 
	local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, extraSpellId, extraSpellName, extraSchool = CombatLogGetCurrentEventInfo()
	
	-- Get id of raid icon on target, or nil if none
	local raidIcon = BBT.RaidIconLookup[bit.band(destRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)]
	
	if sourceGUID == playerGUID then
		if subevent == 'SPELL_INTERRUPT' then 
			self:PrintDebug(string.format("Spell interrupt (dest: %s, spellname: %s, extraSpellName: %s)", destName, spellName, extraSpellName))
			
			local entityName = nil
			
			if self:GetRaidIconString(raidIcon) ~= "" then
				entityName = string.format("%s %s", self:GetRaidIconString(raidIcon), destName)
			else
				entityName = destName
			end
			
			self:SendWarningMessage(string.format(L["ABILITY_INTERRUPT"], entityName, extraSpellName, spellName), spellName)
		elseif subevent == "SPELL_AURA_REMOVED" then
			self:KillBuffExpirationTimer(spellName)
		elseif subevent == "SPELL_CAST_SUCCESS" then
			--Casts with critical expirations
			if spellName == L["ABILITY_LASTSTAND"] or spellName == L["ABILITY_SHIELDWALL"] then
				self:SendWarningMessage(string.format(L["ABILITY_ACTIVATED"], spellName), spellName)
				if self:IsWarningExpirationsEnabled() then
				-- find buff, get its duration and set up a timer
					local counter = 1
					while UnitBuff("player", counter) do
						local buffName, rank, icon, count, debuffType, buffDuration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId  = UnitBuff("player", counter) 
						
						if name == spellName then
							local warnSecBeforeExpire = 3
							local timeToWarn = buffDuration - warnSecBeforeExpire
							
							self:Print(string.format("Scheduling buff expiration timer %f (buffDuration: %f)", timeToWarn, buffDuration))
							BBT.BuffTimers[spellName] = self:ScheduleTimer(self.OnBuffExpiration, timeToWarn, self,  spellName, warnSecBeforeExpire)
							break
						end
						counter = counter + 1
					end
				end
			--Casts without critical expirations
			elseif spellName == L["ABILITY_CHALLENGINGSHOUT"] or spellName == L["ABILITY_CHALLENGINGROAR"] then
				self:SendWarningMessage(string.format(L["ABILITY_ACTIVATED"], spellName), spellName)
			end
		--Failures
		elseif subevent == "SPELL_MISSED" then		
			--We COULD look for the 15th argument of ... here for the type, but we'll just declare any miss as "resisted"
			if spellName == L["ABILITY_TAUNT"] or spellName == L["ABILITY_MOCKINGBLOW"] or spellName == L["ABILITY_GROWL"] then
				self:SendWarningMessage(string.format(L["ABILITY_RESISTED"], spellName), spellName)
			end
		end
	end
end

function BBT:OnPlayerLeaveCombat()
	if self:IsSalvRemovalEnabled() then
		self:CancelSalvBuff() -- Since we can't cancel while in battle, do it just right after
	end
end

function BBT:OnEnable()
	if self:IsSalvRemovalEnabled() then
		self:CancelSalvBuff() -- Cancel existing one if present
	end
	
	BBT:RegisterEvent("PLAYER_DEAD", "OnPlayerDead")
	BBT:RegisterEvent("UNIT_AURA", "OnUnitAuraEvent")
	BBT:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnCombatLogEventUnfiltered")
	BBT:RegisterEvent("PLAYER_LEAVE_COMBAT", "OnPlayerLeaveCombat")
end

function BBT:OnDisable()
	BBT:UnregisterEvent("PLAYER_DEAD")
	BBT:UnregisterEvent("UNIT_AURA")
	BBT:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	BBT:UnregisterEvent("PLAYER_LEAVE_COMBAT")
end

--- IS THIS WORKING/NEEDED?
function BBT:SetDataDb(val)
    db = val
end