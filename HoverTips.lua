
local linkTypes = {
	item = true,
	enchant = true, -- any crafting recipe
	spell = true,
	quest = true,
	unit = true, -- used in combat log
	talent = true,
	achievement = true,
	glyph = true, -- no longer usable since glyph system is gone?
	instancelock = true, -- raidinfo window
	currency = true,
	-- BNplayer = true, -- disabled, needs custom handling that's broken now
	keystone = true, -- untested as of 11.0
	battlepet = true, -- semi custom handling from BattlePet UI
	-- perksactivity = true, -- TODO needs custom tooltip handling
	-- curio = true, -- TODO war within delve buddy stuff
	-- trade = true, -- TODO link your whole profession
	-- api = true, -- TODO has to do with /api command for API help
	-- battlePetAbil = true, -- TODO probably needs similar to battlepet
	-- dungeonScore = true, -- TODO mythic+ score has a tooltip
	-- outfit = true, -- TODO transmog outfit
	-- talentbuild = true, -- TODO whole talent builds has a useful tooltip?
 }

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

local function ShowBattlePetTooltip(frame, linkContent)
	GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT")
	local petInfo = {}
	for _, string in pairs({strsplit(":", linkContent)}) do
		tinsert(petInfo, tonumber(string))
	end
	BattlePetToolTip_Show(unpack(petInfo))
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
		elseif (linkType == "journal") then
			ShowJournalTooltip(frame, linkContent);
		elseif (linkType == "battlepet") then
			ShowBattlePetTooltip(frame, linkContent)
		elseif linkTypes[linkType] then
			GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end
	end

end

local function OnHyperlinkLeave(frame, ...)
	GameTooltip:Hide()
	BattlePetTooltip:Hide()
end

local _G = getfenv(0)
for i=1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	frame:HookScript("OnHyperlinkEnter", OnHyperlinkEnter)
	frame:HookScript("OnHyperlinkLeave", OnHyperlinkLeave)
end
