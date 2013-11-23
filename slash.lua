--[[
	slash.lua
		Slash command handler for Ludwig

	ludwig slash commands:
		/lw or /ludwig
			toggles the GUI
		/lw -q <itemID>
			queries the game for and displays the link of <itemID>
--]]

local AddonName, Addon = ...
local L = Addon('Locals')

SlashCmdList['LudwigCOMMAND'] = function(msg)
	local cmd = (msg or ''):lower():match('%-([%w%s]+)')
	if cmd then
		local id = cmd:match('q %d+')
		if id then
			Addon:QueryItem(id)
		else
			print(AddonName, L.UnknownCommand:format(cmd))
		end
	else
		Addon:ToggleSearchFrame()
	end
end

SLASH_LudwigCOMMAND1 = '/lw'
SLASH_LudwigCOMMAND2 = '/ludwig'