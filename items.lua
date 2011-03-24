--[[
	The API for retrieveing data from the database
		By João Libório Cardoso (Jaliborc)
		
			
	:GetItems(name, quality, class, subClass, slot, minLevel, maxLevel)
		returns an ordered list of the item IDs that match the provided terms
		
	:GetItemsNamedLike(name)
		just like the above method, but just searches for names (for linkerator support)
		
	:GetItemInfo(id)
		returns quality, name
--]]


LudwigDB = {}
local Markers = {'{', '}', '$', '¢'} --, '£'}
local Caches, Values = {}, {}
local List, Results = {}, ''

for i, marker in ipairs(Markers) do
	Markers[marker] = marker..'([^'..marker..']*)'
end


--[[ API ]]--

function LudwigDB:GetItems(name, quality, class, subClass, slot, minLevel, maxLevel)
	local terms, level = {class, subClass, slot, quality}, 0
	Results = Ludwig_Data
	wipe(List)
	
	-- Check Caches
	for i, term in ipairs(terms) do
		if term == Values[i] then
			Results = Caches[i] or Ludwig_Data
			level = i
		else
			break
		end
	end
	
	-- Search Categories
	for i = level + 1, #Markers do
		Results = strmatch(Markers[i], Results)
		Caches[i] = Results
	end
	
	-- Search Name
	for id, name in gmatch('(%d+):([^:]*)') do
		if strmatch(search, name) then
			tinsert(List, id)
		end
	end
	
	Values = terms
	return List
end

function LudwigDB:GetItemInfo(id)
	return strmatch('(%d+)¢[^¢]*'..id..':([^:]*)', Ludwig_Data)
end