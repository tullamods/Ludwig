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
	if self:LoadWindow() then
		SearchFrame:Toggle()
	end
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

	local results = self:GetItemsByName(itemName)
	if results and #results > 0 then
		--print title
		print(format(L.NumMatching, #results, itemName))

		--list result
		for i, result in ipairs(results) do
			if i <= MAX_RESULTS then
				print(' - ' .. ItemDB:GetItemLink(result.id, result.name, result.hex))
			else
				break
			end
		end

		--print the time it took to generate the set
		print(format(L.GenTime, GetTime() - startTime))
	else
		--print
		print(format(L.NoMatchingItems, itemName))
	end
end

local function loadSubAddon(name)
	EnableAddOn(name)
	return LoadAddOn(name)
end

function Addon:LoadWindow()
	if loadSubAddon(AddonName .. '_Window') then
		SearchFrame = self('Frame')
		self.LoadWindow = function() return true end
		return true
	end
end

function Addon:LoadData()
	if loadSubAddon(AddonName .. '_Data') then
		ItemDB = self('ItemDB')
		self.LoadData = function() return true end
		return true
	end
end

--transform itemresult data into a sortable format
local function getSortableItems(data)
	local results = {}
	
	local ids, names, limits = unpack(data)
	for quality = 0, #ITEM_QUALITY_COLORS do
		local hex = ITEM_QUALITY_COLORS[quality].hex
		for index, itemId in pairs(ids[quality]) do
			local name = names[quality][index]
			table.insert(results, {id = itemId, name = name, hex = hex})
		end
	end
	
	return results
end

local function getDistance(str1, str2)
	--a few optimizations for when we already know distance
	if str1 == str2 then
		return 0
	end

	if not str1 then
		return #str2
	end

	if not str2 then
		return #str1
	end

	return abs(#str1 - #str2)
end

function Addon:GetItemsByName(name)
	if not self:LoadData() then return end
	
	local items, numItems = ItemDB:GetItems(name)
	if numItems > 0 then
		local sortableItems = getSortableItems(items)

		local search = name:lower()
		table.sort(sortableItems, function(a, b) 
			return getDistance(search, a.name:lower()) < getDistance(search, b.name:lower())
		end)
		
		return sortableItems
	end
end