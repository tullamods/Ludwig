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

local AddonName, Ludwig = ...
local L = Ludwig('Locals')

local printMsg = function(...)
	print(AddonName, ...)
end

local queryItem = function(id)
	SetItemRef(('item:%d'):format(tonumber(id)))
end

local searchItem = function(name)
	local ItemDB = self:LoadData()
	local startTime = GetTime()
	
	if not ItemDB then
		return
	end

	--[[local results = ItemDB:GetItems(itemName)
	if #results > 0 then
		--print title
		print(format(L.NumMatching, #results, itemName))

		--list result
		for i = 1, math.min(#results, MAX_RESULTS) do
			print(' - ' .. ItemDB:GetItemLink(results[i]))
		end

		--print the time it took to generate the set
		print(format(L.GenTime, GetTime() - startTime))
	else
		--print
		print(format(L.NoMatchingItems, itemName))
	end--]]
end

SlashCmdList['LudwigSlashCOMMAND'] = function(msg)
	if not msg or msg == '' then
		Ludwig:ToggleWindow()
	else
		local cmd = msg:lower():match('%-%-([%w%s]+)')
		if cmd then
			if cmd:match('q %d+') then
				queryItem(cmd:match('q (%d+)'))
			else
				printMsg(L.UnknownCommand:format(cmd))
			end
		else
			searchItem(msg)
		end
	end
end

SLASH_LudwigSlashCOMMAND1 = '/lw'
SLASH_LudwigSlashCOMMAND2 = '/ludwig'