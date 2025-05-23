------------------------------------------------------
-- Addon loading & shared infrastructure
------------------------------------------------------
local addonName, T = ...
_G[addonName] = T

T.Title = C_AddOns.GetAddOnMetadata(addonName, "Title")
T.Version = C_AddOns.GetAddOnMetadata(addonName, "Version")

------------------------------------------------------
 -- Link handler functions
 ------------------------------------------------------

function T:ShowDefaultTooltip(link)
    local anchorFrame = self
    GameTooltip:SetOwner(anchorFrame, "ANCHOR_TOPLEFT")
    GameTooltip:SetHyperlink(link)
    GameTooltip:Show()
end

function T:ShowJournalTooltip(link)
    local anchorFrame = self
    local _, jtype, id, difficulty = strsplit(":", link)
    jtype = tonumber(jtype)
    id = tonumber(id)
    difficulty = tonumber(difficulty)
    local instanceID, encounterID, sectionID, tierIndex = EJ_HandleLinkPath(jtype, id)
    if (instanceID == nil and encounterID == nil and sectionID == nil) then
        -- we can get this for dungeon tier links which appear when you level up
        -- but there's nothing sensible to put in a tooltip for them
        return
    end
    
    EJ_SetDifficulty(difficulty)
    local C = HIGHLIGHT_FONT_COLOR
    if (encounterID == nil) then
        local name, description = EJ_GetInstanceInfo(instanceID)
        GameTooltip:SetOwner(anchorFrame, "ANCHOR_TOPLEFT")
        GameTooltip:SetText(name, C.r, C.g, C.b)
        GameTooltip:AddLine(description, nil, nil, nil, true)
        GameTooltip:Show()
    elseif (sectionID == nil) then
        local instance = EJ_GetInstanceInfo(instanceID)
        local name, description = EJ_GetEncounterInfo(encounterID)
        GameTooltip:SetOwner(anchorFrame, "ANCHOR_TOPLEFT")
        GameTooltip:SetText(name, C.r, C.g, C.b)
        GameTooltip:AddLine(instance, C.r, C.g, C.b)
        GameTooltip:AddLine(description, nil, nil, nil, true)
        GameTooltip:Show()
    else
        local instance = EJ_GetInstanceInfo(instanceID)
        local encounter = EJ_GetEncounterInfo(encounterID)
        local name, description = EJ_GetSectionInfo(sectionID)
        GameTooltip:SetOwner(anchorFrame, "ANCHOR_TOPLEFT")
        GameTooltip:SetText(name, C.r, C.g, C.b)
        GameTooltip:AddLine(encounter .." - ".. instance, C.r, C.g, C.b)
        GameTooltip:AddLine(description, nil, nil, nil, true)
        GameTooltip:Show()
    end
        
end

function T:ShowBattlePetTooltip(link)
    local anchorFrame = self
    GameTooltip:SetOwner(anchorFrame, "ANCHOR_TOPRIGHT")

    local petInfo = {select(2, strsplit(":", link))} -- skip link type
    for i, element in pairs(petInfo) do 
       petInfo[i] = tonumber(element)
    end
    BattlePetToolTip_Show(unpack(petInfo))
end

function T:ShowMapPinTooltip(link)
    local anchorFrame = self
    GameTooltip:SetOwner(anchorFrame, "ANCHOR_TOPLEFT")
    
    local _, mapID, x, y = strsplit(":", link)
    local info = C_Map.GetMapInfo(tonumber(mapID))
    local coordText = ("%.2f, %.2f"):format(tonumber(x) / 100, tonumber(y) / 100)

    local C = NORMAL_FONT_COLOR
    local G = GRAY_FONT_COLOR
    GameTooltip:SetText(info.name, C.r, C.g, C.b)
    GameTooltip:AddLine(coordText, G.r, G.g, G.b)

    GameTooltip:Show()
end

function T:HandleAddonTooltip(link)
    local anchorFrame = self
    local _, addon = strsplit(":", link)
    
    -- prefer manually registered handler
    local handler = T.AddonLinkHandlers[addon]
    if handler and type(hander) == "function" then
        return handler(anchorFrame, link)
    end
    
    -- look for a GFW-convention no-registry-needed handler
    local addonTable = _G[addon]
    if addonTable and type(addonTable) == "table" then
        local handler = addonTable.ShowAddonTooltip
        if handler and type(handler) == "function" then
            return handler(anchorFrame, link)
        end
    end
end

-- TODO not hooked up yet, move to new addon system
function T:ShowDiggerAidTooltip(link)
    local linkType, linkContent = link:match("^([^:]+):(.+)")
    if (linkType == FDA_LINK_TYPE and FDA_ShowCurrentArtifactTooltipForRace) then
        local raceIndex = tonumber(linkContent)
        if (raceIndex) then
            GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
            FDA_ShowCurrentArtifactTooltipForRace(GameTooltip, raceIndex)
        end
    elseif (linkType == FDA_SOLVE_LINK_TYPE and FDA_ShowSolveTooltipForRace) then
        local raceIndex = tonumber(linkContent)
        if (raceIndex) then
            GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
            FDA_ShowSolveTooltipForRace(raceIndex)
        end
    end
end

------------------------------------------------------
-- Link handler registry
------------------------------------------------------
T.LinkHandlers = {
    item = T.ShowDefaultTooltip,
    enchant = T.ShowDefaultTooltip, -- any crafting recipe
    spell = T.ShowDefaultTooltip,
    quest = T.ShowDefaultTooltip,
    unit = T.ShowDefaultTooltip, -- used in combat log
    talent = T.ShowDefaultTooltip,
    achievement = T.ShowDefaultTooltip,
    glyph = T.ShowDefaultTooltip, -- no longer usable since glyph system is gone?
    instancelock = T.ShowDefaultTooltip, -- raidinfo window
    currency = T.ShowDefaultTooltip,
    keystone = T.ShowDefaultTooltip,
    curio = T.ShowDefaultTooltip, -- war within delve buddy stuff
    azessence = T.ShowDefaultTooltip, -- battle for azeroth stuff
    conduit = T.ShowDefaultTooltip, -- shadowlands stuff
    mawpower = T.ShowDefaultTooltip, -- more shadowlands stuff
    
    -- custom handlers
    journal = T.ShowJournalTooltip,
    battlepet = T.ShowBattlePetTooltip,
    worldmap = T.ShowMapPinTooltip,
    
    -- special
    addon = T.HandleAddonTooltip,
    
    -- BNplayer = true, -- disabled, needs custom handling that's broken now
    -- player = true, -- disabled, needs custom handling that's broken now
    -- perksactivity = true, -- TODO needs custom tooltip handling
    -- trade = true, -- TODO link your whole profession
    -- api = true, -- TODO has to do with /api command for API help
    -- battlePetAbil = true, -- TODO probably needs similar to battlepet
    -- dungeonScore = true, -- TODO mythic+ score has a tooltip
    -- outfit = true, -- TODO transmog outfit
    -- talentbuild = true, -- TODO whole talent builds has a useful tooltip?

}

T.AddonLinkHandlers = {}

function T:OnHyperlinkEnter(link)
    local anchorFrame = self -- when hooked this will be the moused-over frame
    local linkType = strsplit(":", link) -- first element only
    
    handler = T.LinkHandlers[linkType]
    if handler == nil then return; end
    
    -- TODO: make handlers return the tooltip shown, so that we can hide it OnLeave
    handler(anchorFrame, link)
end

function T:OnHyperlinkLeave(...)
    GameTooltip:Hide()
    BattlePetTooltip:Hide()
end

local _G = getfenv(0)
for i=1, NUM_CHAT_WINDOWS do
    local frame = _G["ChatFrame"..i]
    frame:HookScript("OnHyperlinkEnter", T.OnHyperlinkEnter)
    frame:HookScript("OnHyperlinkLeave", T.OnHyperlinkLeave)
end
