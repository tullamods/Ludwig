--[[
	Copyright 2007-2025 João Cardoso
	All Rights Reserved
--]]

local ADDON, Addon = ...
local L = Addon.Locals

SlashCmdList['LudwigCOMMAND'] = function(msg, ...)
	local cmd = (msg or ''):lower():match('([%w%s]+)')
	if cmd then
		local id = cmd:match('q?%s*(%d+)')
		if id then
			Addon:PrintItem(id)
		else
			print(ADDON ..': '.. L.UnknownCommand:format(cmd))
		end
	else
		Addon:ToggleWindow()
	end
end

SLASH_LudwigCOMMAND1 = '/lw'
SLASH_LudwigCOMMAND2 = '/ludwig'
