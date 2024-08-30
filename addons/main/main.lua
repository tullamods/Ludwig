--[[
	Copyright 2007-2024 João Cardoso
	All Rights Reserved
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere')
_G[ADDON] = Addon


--[[ Actions ]]--

function Addon:ToggleWindow()
	if self:Load('Window') then
		self.Frame:Toggle()
	end
end

function Addon:QueryItem(id)
	SetItemRef(format('item:%d', tonumber(id)))
end


--[[ Modules & Loading ]]--

function Addon:NewModule(name, obj)
	obj = obj or {}
	self[name] = obj
	return obj
end

function Addon:Load(name)
	C.AddOns.EnableAddOn(ADDON ..'_'.. name)
	return C.AddOns.LoadAddOn(ADDON ..'_'.. name)
end
