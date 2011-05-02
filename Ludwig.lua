--[[
	Ludwig.lua
		Ludwig's globally accessible methods
--]]

local AddonName, Ludwig = ...
local MAX_RESULTS = 10

function Ludwig:ToggleFrame()
	if self:LoadData() then
		self['Frame']:Toggle()
	end
end

function Ludwig:LoadData()
	EnableAddOn(AddonName .. '_Data')
	return LoadAddOn(AddonName .. '_Data')
end

function Ludwig:NewModule(id, obj)
	obj = obj or {}
	self[id] = obj
	return obj
end

_G['Ludwig'] = Ludwig