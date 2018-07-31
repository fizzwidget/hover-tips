
local orig1, orig2 = {}, {}
local GameTooltip = GameTooltip

-- TODO: battlepet & battlePetAbil? requires our own tooltips inheriting BattlePetTooltipTemplate & SharedPetBattleAbilityTooltipTemplate
local linkTypes = {
	item = true,
	enchant = true,
	spell = true,
	quest = true,
	unit = true,
	talent = true,
	achievement = true,
	glyph = true,
	instancelock = true,
	currency = true,
	BNplayer = true,
 }

local function ShowPlayerTooltip(frame, linkContent)
	
	local playerName = strsplit(":", linkContent);
	-- TODO: reload guild roster at appropriate times so this info exists?
	local foundInGuild = false;
	for i = 1, GetNumGuildMembers(1) do
		local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(i);
		if (name == playerName) then

			local guildName = GetGuildInfo("player");
			local guildColor = ChatTypeInfo["GUILD"];
			local officerColor = ChatTypeInfo["OFFICER"];
			local C = HIGHLIGHT_FONT_COLOR; 
			local G = GRAY_FONT_COLOR;

			GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");
			if (isMobile) then
				GameTooltip:SetText(ChatFrame_GetMobileEmbeddedTexture(73/255, 177/255, 73/255).." "..name, C.r, G.g, G.b);
			elseif (not online) then
				GameTooltip:AddDoubleLine(name, PLAYER_OFFLINE, C.r, C.g, C.b, G.r, G.g, G.b);
			else
				GameTooltip:SetText(name, C.r, C.g, C.b);
			end
			GameTooltip:AddLine(format(GUILD_TEMPLATE, rank, guildName), C.r, C.g, C.b);
			GameTooltip:AddLine(format(FRIENDS_LEVEL_TEMPLATE, level, class), C.r, C.g, C.b);
			GameTooltip:AddLine(zone, C.r, C.g, C.b);
			if (note and note ~= "") then
				GameTooltip:AddLine(note, guildColor.r, guildColor.g, guildColor.b);
			end
			if (officernote and officernote ~= "") then
				GameTooltip:AddLine(officernote, officerColor.r, officerColor.g, officerColor.b);
			end
			GameTooltip:Show();

			foundInGuild = true;
			break;
		end
	end
	
	for i = 1, GetNumFriends() do
		local name, level, class, area, connected, status, note = GetFriendInfo(i);
		if (name == playerName) then

			if (not foundInGuild) then
				local C = HIGHLIGHT_FONT_COLOR; 
				local G = GRAY_FONT_COLOR;
				GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");
				if (not connected) then
					GameTooltip:AddDoubleLine(name, PLAYER_OFFLINE, C.r, C.g, C.b, G.r, G.g, G.b);
				elseif (status and status ~= "") then
					GameTooltip:AddDoubleLine(name, status, C.r, C.g, C.b, G.r, G.g, G.b);
				else
					GameTooltip:SetText(name, C.r, C.g, C.b);
				end
				if (connected) then
					GameTooltip:AddLine(format(FRIENDS_LEVEL_TEMPLATE, level, class), C.r, C.g, C.b);
					GameTooltip:AddLine(area, C.r, C.g, C.b);
				end
			end
			if (note and note ~= "") then
				GameTooltip:AddLine(note);
			end
			GameTooltip:Show();

			break;
		end
	end
		
	-- TODO: if not friend, check party/raid/bg?
end

-- for debug
function HoverTips_PrintFriends()
	for i = 1, BNGetNumFriends() do
		local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, broadcastText, noteText, isFriend, broadcastTime = BNGetFriendInfo(i);
		print(format("|HBNplayer:%s:%s:%s:%s:%s|h[%s] (%s)|h", presenceName, presenceID, 0, 0, 0, presenceName, toonName or UNKNOWN));
	end
end

local BROADCAST_FONT_COLOR = {r=0.345, g=0.667, b=0.867};
local ChatIcons = {
	[BNET_CLIENT_WOW] = "|TInterface\\ChatFrame\\UI-ChatIcon-WOW:16|t",
	[BNET_CLIENT_SC2] = "|TInterface\\ChatFrame\\UI-ChatIcon-SC2:16|t",
	[BNET_CLIENT_D3] = "|TInterface\\ChatFrame\\UI-ChatIcon-D3:16|t",
	[BNET_CLIENT_WTCG] = "|TInterface\\ChatFrame\\UI-ChatIcon-WTCG:16|t",
	[BNET_CLIENT_APP] = "|TInterface\\ChatFrame\\UI-ChatIcon-Battlenet:16|t",
	[BNET_CLIENT_HEROES] = "|TInterface\\ChatFrame\\UI-ChatIcon-HotS:16|t",
	[BNET_CLIENT_OVERWATCH] = "|TInterface\\ChatFrame\\UI-ChatIcon-Overwatch:16|t",
	[BNET_CLIENT_CLNT] = "|TInterface\\ChatFrame\\UI-ChatIcon-Battlenet:16|t",
	broadcast = "|TInterface\\FriendsFrame\\BroadcastIcon:16|t",
	note = "|TInterface\\FriendsFrame\\UI-FriendsFrame-Note:12:14|t",
	offline = "|TInterface\\FriendsFrame\\StatusIcon-Offline:16|t",
	online = "|TInterface\\FriendsFrame\\StatusIcon-Online:16|t",
	afk = "|TInterface\\FriendsFrame\\StatusIcon-Away:16|t",
	dnd = "|TInterface\\FriendsFrame\\StatusIcon-DnD:16|t",
};
local function ShowBattleNetTooltip(frame, linkContent)
	GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");

	local name, presenceID, lineid, chatType, chatTarget = strsplit(":", linkContent);	
	local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, broadcastText, noteText, isFriend, broadcastTime = BNGetFriendInfoByID(presenceID);
	
	local text;
	
	-- friend name (realID name or battletag)
	local nameText = UNKNOWN;
	local characterName = toonName;
	if ( presenceName ) then
		nameText = presenceName;
		-- if no character name but we have a BattleTag, use that
		if ( isOnline and not characterName and battleTag ) then
			characterName = battleTag;
		end
	end
	local color = FRIENDS_GRAY_COLOR;
	if (isOnline) then
		color = FRIENDS_BNET_NAME_COLOR;
	end
	local statusIcon = ChatIcons.offline;
	if (isAFK) then
		statusIcon = ChatIcons.afk;
	elseif (isDND) then
		statusIcon = ChatIcons.dnd;
	elseif (isOnline) then
		statusIcon = ChatIcons.online;
	end
	GameTooltip:AddDoubleLine(nameText, statusIcon, color.r, color.g, color.b);
	
	-- current toon
	if ( toonID ) then
		local hasFocus, _, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText = BNGetToonInfo(presenceID);
		level = level or "";
		race = race or "";
		class = class or "";
		local c = FRIENDS_GRAY_COLOR;
		if ( client == BNET_CLIENT_WOW ) then
			if ( CanCooperateWithToon(toonID, HasTravelPass()) ) then
				text = string.format(FRIENDS_TOOLTIP_WOW_TOON_TEMPLATE, characterName, level, race, class);
			else
				text = string.format(FRIENDS_TOOLTIP_WOW_TOON_TEMPLATE, characterName..CANNOT_COOPERATE_LABEL, level, race, class);
			end
			GameTooltip:AddLine(ChatIcons[client] .. text, c.r,c.g,c.b);
			local FRIENDS_TOOLTIP_WOW_INFO_TEMPLATE = "    " .. NORMAL_FONT_COLOR_CODE .. FRIENDS_LIST_ZONE .. "|r%1$s|n    " .. NORMAL_FONT_COLOR_CODE .. FRIENDS_LIST_REALM .. "|r%2$s";
			GameTooltip:AddLine(string.format(FRIENDS_TOOLTIP_WOW_INFO_TEMPLATE, zoneName, realmName), c.r,c.g,c.b);
		else
			if (ChatIcons[client]) then
				GameTooltip:AddLine(ChatIcons[client] .. characterName, c.r,c.g,c.b);
			else
				GameTooltip:AddLine(characterName, c.r,c.g,c.b);
			end
			GameTooltip:AddLine("    "..gameText, c.r,c.g,c.b);
		end
	end
	
	-- note
	if ( noteText and noteText ~= "" ) then
		local c = NORMAL_FONT_COLOR;
		GameTooltip:AddLine(ChatIcons.note .. noteText, c.r,c.g,c.b);
	end
	
	-- broadcast
	if ( broadcastText and broadcastText ~= "" ) then
		broadcastText = broadcastText .. "|n    " .. FRIENDS_BROADCAST_TIME_COLOR_CODE .. string.format(BNET_BROADCAST_SENT_TIME, FriendsFrame_GetLastOnline(broadcastTime));
		local c = BROADCAST_FONT_COLOR;
		GameTooltip:AddLine(ChatIcons.broadcast .. broadcastText, c.r,c.g,c.b);
	end

	-- last online (if offline)
	if (not isOnline ) then
		if ( lastOnline == 0 ) then
			text = FRIENDS_LIST_OFFLINE;
		else
			text = string.format(BNET_LAST_ONLINE_TIME, FriendsFrame_GetLastOnline(lastOnline)); -- TODO error here
		end
		local c = FRIENDS_GRAY_COLOR;
		GameTooltip:AddLine(text, c.r,c.g,c.b);
	end
	
	GameTooltip:Show();
end

local function ShowJournalTooltip(frame, linkContent)
	local jtype, id, difficulty = strsplit(":", linkContent);
	jtype = tonumber(jtype);
	id = tonumber(id);
	difficulty = tonumber(difficulty);
	local instanceID, encounterID, sectionID, tierIndex = EJ_HandleLinkPath(jtype, id);	
	
	if (instanceID == nil and encounterID == nil and sectionID == nil) then
		-- we can get this for dungeon tier links which appear when you level up
		-- but there's nothing sensible to put in a tooltip for them
		return;
	end
	
	EJ_SetDifficulty(difficulty);
	
	local C = HIGHLIGHT_FONT_COLOR; 
	if (encounterID == nil) then
		local name, description = EJ_GetInstanceInfo(instanceID);
		
		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");
		GameTooltip:SetText(name, C.r, C.g, C.b);
		GameTooltip:AddLine(description, nil, nil, nil, true);
		GameTooltip:Show();

	elseif (sectionID == nil) then
		local instance = EJ_GetInstanceInfo(instanceID);
		local name, description = EJ_GetEncounterInfo(encounterID);
		
		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");
		GameTooltip:SetText(name, C.r, C.g, C.b);
		GameTooltip:AddLine(instance, C.r, C.g, C.b);
		GameTooltip:AddLine(description, nil, nil, nil, true);
		GameTooltip:Show();
	
	else
		local instance = EJ_GetInstanceInfo(instanceID);
		local encounter = EJ_GetEncounterInfo(encounterID);
		local name, description = EJ_GetSectionInfo(sectionID);
		
		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT");
		GameTooltip:SetText(name, C.r, C.g, C.b);
		GameTooltip:AddLine(encounter .." - ".. instance, C.r, C.g, C.b);
		GameTooltip:AddLine(description, nil, nil, nil, true);
		GameTooltip:Show();
		
	end
		
end

local function OnHyperlinkEnter(frame, link, ...)
	local linkType, linkContent = link:match("^([^:]+):(.+)")
	if (linkType) then
		if (linkType == FDA_LINK_TYPE and FDA_ShowCurrentArtifactTooltipForRace) then
			local raceIndex = tonumber(linkContent);
			if (raceIndex) then
				GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
				FDA_ShowCurrentArtifactTooltipForRace(GameTooltip, raceIndex);
			end
		elseif (linkType == FDA_SOLVE_LINK_TYPE and FDA_ShowSolveTooltipForRace) then
			local raceIndex = tonumber(linkContent);
			if (raceIndex) then
				GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
				FDA_ShowSolveTooltipForRace(raceIndex);
			end
		elseif (linkType == "player") then
			ShowPlayerTooltip(frame, linkContent);
		elseif (linkType == "BNplayer") then
			ShowBattleNetTooltip(frame, linkContent);
		elseif (linkType == "journal") then
			ShowJournalTooltip(frame, linkContent);
		elseif linkTypes[linkType] then
			GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end
	end

	if orig1[frame] then return orig1[frame](frame, link, ...) end
end

local function OnHyperlinkLeave(frame, ...)
	GameTooltip:Hide()
	if orig2[frame] then return orig2[frame](frame, ...) end
end

local _G = getfenv(0)
for i=1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	orig1[frame] = frame:GetScript("OnHyperlinkEnter")
	frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

	orig2[frame] = frame:GetScript("OnHyperlinkLeave")
	frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
end
