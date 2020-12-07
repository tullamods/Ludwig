--[[
	broker.lua
		LibDataBroker launcher for Ludwig
--]]

local ADDON, Addon = ...
local L = Addon('Locals')
local Broker = Addon:NewModule('Broker', LibStub('LibDataBroker-1.1'):NewDataObject('Ludwig', {
	type = 'launcher',
	icon = 'Interface/Icons/inv_misc_book_04',
	label = ADDON
}))

function Broker:OnClick()
	Addon:ToggleSearchFrame()
end

function Broker:OnTooltipShow()
	self:AddLine(ADDON)
end