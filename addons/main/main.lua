--[[
	Copyright 2007-2026 João Cardoso
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere')
_G[ADDON] = Addon

EventUtil.ContinueOnVariablesLoaded(function()
	Ludwig_Sets = Ludwig_Sets or {}
	LibStub('StaleCheck-1.0'):CheckForUpdates(ADDON, Ludwig_Sets, 'Interface/Addons/Ludwig/art/gnomed')
end)


--[[ Actions ]]--

function Addon:ToggleWindow()
	if self:Load('Window') then
		self.Frame:Toggle()
	end
end

function Addon:PrintItem(id)
	print(self:GetLink(id))
end

function Addon:GetLink(id)
	return select(2, C.Item.GetItemInfo(id))
end


--[[ Modules & Loading ]]--

function Addon:NewModule(name, obj)
	obj = obj or {}
	self[name] = obj
	return obj
end

function Addon:Load(name)
	return C.AddOns.LoadAddOn(ADDON ..'_'.. name)
end