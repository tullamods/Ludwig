--[[
	Ludwig.lua
		Ludwig's globally accessible methods
--]]

local AddonName, Addon = ...; Ludwig = Addon
local L = Addon('Locals')
local MAX_RESULTS = 10


--[[ Actions ]]--

function Addon:ToggleSearchFrame()
	if self:LoadWindow() then
		self('Frame'):Toggle()
	end
end

function Addon:QueryItem(id)
	SetItemRef(('item:%d'):format(tonumber(id)))
end


--[[ Loading ]]--

function Addon:LoadWindow()
	if self:LoadSub('_Window') then
		self.LoadWindow = function() return true end
		return true
	end
end

function Addon:LoadData()
	if self:LoadSub('_Data') then
		self.LoadData = function() return true end
		return true
	end
end

function Addon:LoadSub(name)
	EnableAddOn(AddonName .. name)
	return LoadAddOn(AddonName .. name)
end