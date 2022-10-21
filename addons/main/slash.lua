--[[
	slash.lua
		Slash command handler for Ludwig
--]]

local ADDON, Addon = ...
local L = Addon.Locals

SlashCmdList['LudwigCOMMAND'] = function(msg, ...)
	local cmd = (msg or ''):lower():match('([%w%s]+)')
	if cmd then
		if cmd:sub(1,1) == 'q' then
			local id = cmd:match('q (%d+)')
			if id then
				Addon:QueryItem(id)
			else
				print(ADDON ..': '.. L.MissingNumber)
			end
		else
			print(ADDON ..': '.. L.UnknownCommand:format(cmd))
		end
	else
		Addon:ToggleSearchFrame()
	end
end

SLASH_LudwigCOMMAND1 = '/lw'
SLASH_LudwigCOMMAND2 = '/ludwig'
