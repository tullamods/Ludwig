--[[
	Ludwig.lua
		Ludwig's globally accessible methods
--]]

local AddonName, Ludwig = ...
local MAX_RESULTS = 10

function Ludwig:ToggleWindow()
	if LoadAddOn(AddonName .. '_Window') then
		self['Frame']:Toggle()
	end
end

function Ludwig:LoadData()
	return LoadAddOn(AddonName .. '_Data') and Ludwig['ItemDB']
end

function Ludwig:NewModule(id, obj)
	obj = obj or {}
	self[id] = obj
	return obj
end

_G['Ludwig'] = Ludwig
EnableAddOn(AddonName .. '_Data')
EnableAddOn(AddonName .. '_Window')