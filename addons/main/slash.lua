--[[
	Copyright 2007-2026 João Cardoso
	All Rights Reserved
--]]

local ADDON, Addon = ...
local L = Addon.Locals

SlashCmdList.Ludwig = function(msg, ...)
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

SLASH_Ludwig1 = '/lw'
SLASH_Ludwig2 = '/ludwig'
