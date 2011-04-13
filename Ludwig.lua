--[[
	Ludwig.lua
		Ludwig's globally accessible methods
--]]

local AddonName, Addon = ...; Ludwig = Addon
local L = Addon('Locals')
local ItemDB, SearchFrame
local MAX_RESULTS = 10


--toggle the UI frame
function Addon:ToggleSearchFrame()
	if not self:LoadData() then
		return
	end
	SearchFrame:Toggle()
end

--query and display an item that matches <id>
function Addon:QueryItem(id)
	SetItemRef(('item:%d'):format(tonumber(id)))
end

--display a listing of all items matching <itemName>
function Addon:SearchForItem(itemName)
	if not self:LoadData() then
		return
	end

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

function Addon:LoadData()
	if EnableAddOn(AddonName .. '_Data') or LoadAddOn(AddonName .. '_Data') then
		ItemDB = self('ItemDB')
		SearchFrame = self('SearchFrame')
		self.LoadData = function() return true end
	end
end