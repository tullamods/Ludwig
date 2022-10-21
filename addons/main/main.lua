--[[
	Ludwig.lua
		Most important methods
--]]

local ADDON, Addon = ...
_G[ADDON] = Addon


--[[ Actions ]]--

function Addon:ToggleSearchFrame()
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
	EnableAddOn(ADDON ..'_'.. name)
	return LoadAddOn(ADDON ..'_'.. name)
end
