--[[
	The API for retrieveing data from the database
		By João Libório Cardoso (Jaliborc)
		
			
	:GetItems(name, quality, class, subClass, slot, minLevel, maxLevel)
		returns an ordered list of the item IDs that match the provided terms
		
	:GetItemsNamedLike(name)
		just like the above method, but just searches for names (for linkerator support)
		
	:GetItemName(id)
		returns name, colorHex
		
	:GetItemLink(id)
--]]


LudwigDB = {}
local Markers = {'{', '}', '$', '€'} --, '£'}
local Caches, Values = {}, {}

for i, marker in ipairs(Markers) do
	Markers[i] = marker..'([^'..marker..']+)'
end


--[[ API ]]--

function LudwigDB:GetItems(search, quality, class, subClass, slot, minLevel, maxLevel)
	local terms = {class, subClass, slot, quality}
	local results = Ludwig_Data
	
	for i, term in pairs(terms) do
		-- Check Caches
		if term == Values[i] then
			results = Caches[i]
			
		else
			-- Search
			for i = i, 4 do
				local term = terms[i]
				if term then
					local marker = term .. Markers[i]
					
					-- Categories
					if i < 4 then
						results = strmatch(results, marker)
						
					-- Quality
					else
						local items = ''
						for section in gmatch(results, marker) do
							items = items .. section
						end
						results = items
					end
					
					Caches[i] = results
				end
			end
		end
	end
	
	Values = terms
	return self:GetItemsNamedLike(search, results)
end

function LudwigDB:GetItemsNamedLike(search, source)
	local search = strlower(search or '')
	local list = {}
	
	for id, name in gmatch(source or Ludwig_Data, '(%d+);([^;]+)') do
		if strmatch(strlower(name), search) then
			tinsert(list, id)
		end
	end
	return list
end

function LudwigDB:GetItemName(id)
	local quality, name = strmatch(Ludwig_Data, '(%d+)€[^€]*'..id..';([^;]+)')
	return name, select(4, GetItemQualityColor(tonumber(quality)))
end

function LudwigDB:GetItemLink(id)
	local name, hex = self:GetItemName(id)
	return hex..'|Hitem:'..id..'|h['..name..']|h|r'
end