--[[
	The API for retrieveing data from the database
		By João Libório Cardoso (Jaliborc)
		
			
	:GetItems(name, quality, class, subClass, slot, minLevel, maxLevel)
		returns an ordered list of the item IDs that match the provided terms
		
	:GetItemNamedLike(name)
		returns the id and name of the closest match (for linkerator support)
		
	:IterateItems(string)
		iterates all items in the database or the given string, returning id and name
		
	:GetItemName(id)
		returns name, colorHex
		
	:GetItemLink(id)
--]]


LudwigDB = {}
local Markers, Matchers = {'{', '}', '$', '€', '£'}, {}
local ItemMatch = '(%d+);([^;]+)'
local Caches, Values = {}, {}

for i, marker in ipairs(Markers) do
	Matchers[i] = marker..'[^'..marker..']+'
end


--[[ Search API ]]--

function LudwigDB:GetItems(search, quality, class, subClass, slot, minLevel, maxLevel)
	local search = search and {strsplit(' ', strlower(search))}
	local terms = {class, subClass, slot, quality}
	local results = Ludwig_Data
	local list, match = {}
	local level = 5
	
	-- Check Caches
	for i = 1, 4 do
		if terms[i] == Values[i] then
			results = Caches[i]
		else
			level = i
			break
		end
	end
	
	-- Apply Filters
	for i = level, 4 do
		local term = terms[i]
		if term then
			local match = term .. Matchers[i]
			
			-- Categories
			if i < 4 then
				results = strmatch(results, match)
				
			-- Quality
			else
				local items = ''
				for section in gmatch(results, match) do
					items = items .. section
				end
				results = items
			end
			
			Caches[i] = results
		end
	end
	Values = terms
	
	-- Search Level
	if (minLevel or maxLevel) and (level < 5 or Values[5] ~= minLevel or Values[6] ~= maxLevel) then
		local items = ''
		local min = minLevel or -1/0
		local max = maxLevel or 1/0
		
		for section in gmatch(results or Ludwig_Data, '%d+'..Matchers[5]) do
			local level = tonumber(strmatch(section, '^(%d+)'))
			if level > min and level < max then
				items = items .. section
			end
		end
		
		Caches[5] = items
		results = items
	else
		results = Caches[5]
	end
	
	-- Search Name
	for id, name in self:IterateItems(results) do
		match = true
		
		if search then
			name = strlower(name)
			
			for i, word in ipairs(search) do
				if not strmatch(name, word) then
					match = nil
					break
				end
			end
		end
		
		if match then
			tinsert(list, id)
		end
	end
	return list
end

function LudwigDB:GetItemNamedLike(search)
	search = '^'..search
	for id, name in self:IterateItems() do
		if strmatch(name, search) then
			return id, name
		end
	end
end

function LudwigDB:IterateItems(section)
	return gmatch(section or Ludwig_Data, ItemMatch)
end


--[[ Data API ]]--

function LudwigDB:GetItemName(id)
	if id then
		local quality, name = strmatch(Ludwig_Data, '(%d+)€[^€]*'..id..';([^;]+)')
		if name then
			return name, select(4, GetItemQualityColor(tonumber(quality)))
		else
			return 'Error: Item' .. id .. ' Not Found', ''
		end
	end
end

function LudwigDB:GetItemLink(id)
	local name, hex = self:GetItemName(id)
	return hex..'|Hitem:'..id..'|h['..name..']|h|r'
end