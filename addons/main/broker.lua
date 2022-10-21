--[[
	broker.lua
		LibDataBroker launcher for Ludwig
--]]

local ADDON, Addon = ...
local Broker = Addon:NewModule('Broker', LibStub('LibDataBroker-1.1'):NewDataObject('Ludwig', {
	type = 'launcher', label = ADDON,
	icon = 'Interface/Icons/inv_misc_book_04'
}))

function Broker:OnClick()
	Addon:ToggleSearchFrame()
end

function Broker:OnTooltipShow()
	self:AddLine(ADDON)
end
