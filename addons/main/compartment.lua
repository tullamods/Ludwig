--[[
	Copyright 2007-2026 João Cardoso
	All Rights Reserved
--]]

local ADDON, Addon = ...
if not AddonCompartmentFrame then
    return
end

AddonCompartmentFrame:RegisterAddon {
    text = ADDON, keepShownOnClick = true, notCheckable = true,
    icon = 'interface/addons/ludwig/art/gnomed',
    func = function() Addon:ToggleWindow() end
}