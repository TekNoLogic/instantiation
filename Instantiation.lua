
----------------------
--      Locals      --
----------------------

local L = setmetatable({}, {__index=function(t,i) return i end})
local defaults, defaultsPC, db, dbpc = {}, {}


------------------------------
--      Util Functions      --
------------------------------

local function Print(...) ChatFrame1:AddMessage(string.join(" ", "|cFF33FF99Addon Template|r:", ...)) end

local debugf = tekDebug and tekDebug:GetFrame("Instantiation")
local function Debug(...) if debugf then debugf:AddMessage(string.join(", ", ...)) end end


-----------------------------
--      Event Handler      --
-----------------------------

Instantiation = CreateFrame("frame")
Instantiation:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
Instantiation:RegisterEvent("ADDON_LOADED")


function Instantiation:ADDON_LOADED(event, addon)
	if addon ~= "Instantiation" then return end

	InstantiationDB, InstantiationDBPC = setmetatable(InstantiationDB or {}, {__index = defaults}), setmetatable(InstantiationDBPC or {}, {__index = defaultsPC})
	db, dbpc = InstantiationDB, InstantiationDBPC

	-- Do anything you need to do after addon has loaded

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


-----------------------------
--      Slash Handler      --
-----------------------------

SLASH_INSTANTIATION1 = "/instantiation"
SlashCmdList.INSTANTIATION = function(msg)
	-- Do crap here
end
