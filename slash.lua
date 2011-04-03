--[[
	slash.lua
		Slash command handler for Ludwig

	ludwig slash commands:
		/lw or /ludwig
			toggles the GUI
		/lw <name>
			prints a list of items matching <name>
		/lw --q <itemID>
			queries the game for and displays the link of <itemID>
--]]

local AddonName, Addon = ...
local L = Addon('Locals')


--[[ Slash Command Setup ]]--

local printMsg = function(...)
	print(AddonName, ...)
end

SlashCmdList['LudwigSlashCOMMAND'] = function(msg)
	if not msg or msg == '' then
		Addon:ToggleSearchFrame()
	else
		local cmd = msg:lower():match('%-%-([%w%s]+)')
		if cmd then
			if cmd:match('q %d+') then
				Addon:QueryItemId(cmd:match('q (%d+)'))
			else
				printMsg(L.UnknownCommand:format(cmd))
			end
		else
			Addon:SearchForItem(msg)
		end
	end
end
SLASH_LudwigSlashCOMMAND1 = '/lw'
SLASH_LudwigSlashCOMMAND2 = '/ludwig'