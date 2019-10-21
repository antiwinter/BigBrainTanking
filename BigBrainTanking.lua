local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local HBD = LibStub("HereBeDragons-2.0")
local HBDP = LibStub("HereBeDragons-Pins-2.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("BigBrainTanking")
local AceGUI = LibStub("AceGUI-3.0")
local _

local playerGUID = UnitGUID("player")

BBT = LibStub("AceAddon-3.0"):NewAddon("BigBrainTanking", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0")
BBT.Version = "1.0.0"
BBT.DatabaseVersion = "1.0"
BBT.Signature = "[BBT]"

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
					name = "Announcement setup (Not yet implemented)",
					type = "header",
					order = 4,
					width = "full"
				},
				-- order = 5 filled with Class speicifc settings (Warrior/Druid)
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
					[L["Last Stand"]] = { "Interface\\Icons\\Spell_Holy_AshesToAshes", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } } 					
					},
					[L["Shield Wall"]] = { "Interface\\Icons\\Ability_Warrior_ShieldWall", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } } 
					},
					[L["Challenging Shout"]] = { "Interface\\Icons\\Ability_BullRush", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } } 
					},
					[L["Taunt"]] = { "Interface\\Icons\\Spell_Nature_Reincarnation", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } }  
					},
					[L["Mocking Blow"]] = { "Interface\\Icons\\Ability_Warrior_PunishingBlow", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } }  
					},
					[L["Shield Bash"]] = { "Interface\\Icons\\ability_warrior_shieldbash", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "yell", "raid" } }  
					},
					[L["Pummel"]] = { "Interface\\Icons\\inv_gauntlets_04", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "yell", "raid" } }  
					},
				},
				Druid = {
					[L["Challenging Roar"]] = { "Interface\\Icons\\Ability_Druid_ChallangingRoar", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } }  
					},
					[L["Growl"]] = { "Interface\\Icons\\Ability_Physical_Taunt", 
					{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "raid_warning" } }  
					},
				}			
			},
			Items = {
				[L["Lifegiving Gem"]] = { "Interface\\Icons\\INV_Misc_Gem_Pearl_05", 
				{ Alone = { "yell" }, Party = { "yell", "party" }, Raid = { "yell", "raid_warning" } }  
				},
			}
		},
	}
}

function BBT:ResetProfile()
	BBT.db.profile = Default_Profile.profile
end

function BBT:HandleProfileChanges()
end

function BBT:OnInitialize()
	self:Print("Initializing...")
	
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

--[[
function BBT:GetXXX(keys) 
	for key, value in pairs(keys) do
		self:Print("key: " .. key .. " | value: " .. value)
	end

	presenceType = keys[#keys].name -- Alone/Party/Raid
	keyName = keys[#keys-1].name -- Pummel/Life Giving Gem/etc
	
	self:Print("presenceType: " .. presenceType .. " | keyName: " .. keyName)
	
	return true
end
--]]

BBT.AnnouncementChannels = {
	"say", "yell", "party", "raid", "raid_warning" 
}

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
	self:Print("State: " .. tostring(state))
	
	if index == nil and state == true then
		self:Print("Checked")
		table.insert(ActiveChannels, channel)
	end
	
	if index ~= nil and state == false then
		self:Print("Unckecked")
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
		--disabled = true,
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

function BBT:OnUnitAuraEvent()
	if self:IsSalvRemovalEnabled() then
		self:CancelSalvBuff()
	end
end

function BBT:IsWarningsEnabled()
	return BBT.db.profile.Warnings.IsEnabled
end

function BBT:EnableWarnings(value)
	BBT.db.profile.Warnings.IsEnabled = value
end

function BBT:IsWarningEnabled(spellName)
	--return BBT.db.profile.Warnings.Abilities[spellName]
	return true
end

function BBT:IsWarningExpirationsEnabled()
	return BBT.db.profile.Warnings.AnnounceExpirations
end

function BBT:EnableWarningExpirations(value)
	BBT.db.profile.Warnings.AnnounceExpirations = value
end

function BBT:GetChannelsToWarn(ability)
	local presence = IsInRaid() and "Raid" or (IsInGroup() and "Party" or "Alone")
	
	local channelsToWarn = BBT.db.profile.Warnings.Abilities.Warrior[ability][2][presence]
	return channelsToWarn
end

function BBT:SendWarningMessage(message, ability)
	if not self:IsWarningsEnabled() then
		return
	end
	
	local channels = self:GetChannelsToWarn(ability)

	for index, channel in ipairs(channels) do
		SendChatMessage(message, channel, "Common")
	end
end

function BBT:OnCombatLogEventUnfiltered() 
	local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceflags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool = CombatLogGetCurrentEventInfo()
	
	if sourceGUID == playerGUID then
		if not self:IsWarningEnabled(spellName) then
			return
		end
		
		if subevent == "SPELL_CAST_SUCCESS" then
			--Casts with critical expirations
			if spellName == L["Last Stand"] or spellName == L["Shield Wall"] then
				self:SendWarningMessage(string.format(L["%s activated!"], spellName), spellName)
				if self:IsWarningExpirationsEnabled() then
				-- find buff, get its duration and set up a timer
					local counter = 1
					while UnitBuff("player", counter) do
						local unitBuff = { UnitBuff("player", counter) }
						local buffName = unitBuff[1]
						local buffDuration = unitBuff[5]
						
						if name == spellName then
							C_Timer.After(buffDuration - 3, function()
									if UnitIsDeadOrGhost("player") ~= true then
										self:SendWarningMessage(string.format(L["%s will expire in 3 seconds!"], spellName), spellName)
									end
								end)
							break
						end
						counter = counter + 1
					end
				end
			--Casts without critical expirations
			elseif spellName == L["Challenging Shout"] or spellName == L["Challenging Roar"] then
				self:SendWarningMessage(string.format(L["%s activated!"], spellName), spellName)
			end
		--Failures
		elseif subevent == "SPELL_MISSED" then		
			--We COULD look for the 15th argument of ... here for the type, but we'll just declare any miss as "resisted"
			if spellName == L["Taunt"] or spellName == L["Mocking Blow"] or spellName == L["Growl"] then
				self:SendWarningMessage(string.format(L["%s resisted!"], spellName), spellName)
			end
		end
	end
end

function BBT:OnEnable()
	if self:IsSalvRemovalEnabled() then
		self:CancelSalvBuff() -- Cancel existing one if present
	end
	
	BBT:RegisterEvent("UNIT_AURA", "OnUnitAuraEvent")
	BBT:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnCombatLogEventUnfiltered")
end

function BBT:OnDisable()
	BBT:UnregisterEvent("UNIT_AURA")
	BBT:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

--- IS THIS WORKING/NEEDED?
function BBT:SetDataDb(val)
    db = val
end