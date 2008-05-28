
----------------------
--      Locals      --
----------------------

local L = setmetatable({}, {__index=function(t,i) return i end})
local defaults, defaultsPC, db, dbpc = {}, {}
local IMAGEPATH = "Interface\\AddOns\\Instantiation\\Images\\"
local pins, textures = {}, {
	default = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8", -- Bosses
	["1"] = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4", -- Stairs down, etc
	["2"] = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_2", -- ST Statues
	["3"] = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_6" --Entrances
}


------------------------------
--      Util Functions      --
------------------------------

local function Print(...) ChatFrame1:AddMessage(string.join(" ", "|cFF33FF99Addon Template|r:", ...)) end

local debugf = tekDebug and tekDebug:GetFrame("Instantiation")
local function Debug(...) if debugf then debugf:AddMessage(string.join(", ", ...)) end end


-----------------------------
--      Event Handler      --
-----------------------------

Instantiation = CreateFrame("frame", nil, WorldMapDetailFrame)
Instantiation:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
Instantiation:RegisterEvent("ADDON_LOADED")


function Instantiation:ADDON_LOADED(event, addon)
	if addon ~= "Instantiation" then return end

	InstantiationDB, InstantiationDBPC = setmetatable(InstantiationDB or {}, {__index = defaults}), setmetatable(InstantiationDBPC or {}, {__index = defaultsPC})
	db, dbpc = InstantiationDB, InstantiationDBPC

	UIPanelWindows["WorldMapFrame"] = {area = "center", pushable = 9} -- Not sure why this makes our tooltips work, but who cares?

	self:SetAllPoints()
	self.tex = self:CreateTexture(nil, "BACKGROUND")
	self.tex:SetAllPoints()

	self.currentmap = 3456

	self:SetScript("OnShow", self.OnShow)

	LibStub("tekKonfig-AboutPanel").new("Instantiation", "Instantiation") -- Remove first arg if no parent config panel

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then self:PLAYER_LOGIN() else self:RegisterEvent("PLAYER_LOGIN") end
end


function Instantiation:PLAYER_LOGIN()
	self:RegisterEvent("PLAYER_LOGOUT")

	-- Do anything you need to do after the player has entered the world

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end


function Instantiation:PLAYER_LOGOUT()
	for i,v in pairs(defaults) do if db[i] == v then db[i] = nil end end
	for i,v in pairs(defaultsPC) do if dbpc[i] == v then dbpc[i] = nil end end

	-- Do anything you need to do as the player logs out
end


function Instantiation:OnShow()
	if not self.currentmap then self:Hide() return end

	self.tex:SetTexture(IMAGEPATH.. self.currentmap)

	for _,pin in pairs(pins) do pin:Hide() end

	local w, h = self:GetWidth(), self:GetHeight()
	for i,v in pairs(self.coords[self.currentmap]) do
		local pin = self:GetPin()
		pin:SetPoint("CENTER", self, "BOTTOMLEFT", tonumber(v[1])*w/100, (100-tonumber(v[2]))*h/100)
		pin.tex:SetTexture(textures[v[4] or "default"])
		pin.tiptext = v[3]
		pin:Show()
	end
end


---------------------------
--      Pin Factory      --
---------------------------

local function HideTooltip() GameTooltip:Hide() end
local function ShowTooltip(self)
	if self.tiptext then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end
end

function Instantiation:GetPin()
	for _,pin in pairs(pins) do
		if not pin:IsShown() then return pin end
	end

	local pin = CreateFrame("Button", nil, self)
	pin:SetWidth(16) pin:SetHeight(16)
	pin:SetScript("OnEnter", ShowTooltip)
	pin:SetScript("OnLeave", HideTooltip)

	pin.tex = pin:CreateTexture()
	pin.tex:SetAllPoints()

	table.insert(pins, pin)
	return pin
end


-----------------------------
--      Slash Handler      --
-----------------------------

SLASH_INSTANTIATION1 = "/instantiation"
SlashCmdList.INSTANTIATION = function(msg)
	-- Do crap here
end
