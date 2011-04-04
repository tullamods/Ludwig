--[[
	Ludwig.lua
		Ludwig's globally accessible methods
--]]

local AddonName, Addon = ...; Ludwig = Addon
local L = Addon('Locals')
local ItemDB = Addon('ItemDB')

--toggle the UI frame
function Addon:ToggleSearchFrame()
	self('SearchFrame'):Toggle()
end

--query and display an item that matches <id>
function Addon:QueryItem(id)
	SetItemRef(('item:%d'):format(tonumber(id)))
end

--display a listing of all items matching <itemName>
function Addon:SearchForItem(itemName)
	local startTime = GetTime()

	local results = ItemDB:GetItems(itemName)
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
	end
end