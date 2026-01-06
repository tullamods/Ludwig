--[[
	Copyright 2007-2026 João Cardoso
	All Rights Reserved
--]]

local Database = Ludwig:NewModule('Database')
local ITEM_MATCH = '(%w%w%w%w)([^_]+)'
local C = LibStub('C_Everywhere')


--[[ Searches ]]--

function Database:Find(search, class, subclass, slot, quality, minLevel, maxLevel)
	local ids, names = {}, {}

	search = search and search:trim():lower()
	maxLevel = maxLevel or math.huge
	minLevel = minLevel or 0

	for category, subclasses in pairs(Ludwig_Items) do
		if not class or class == category then
			for subcat, slots in pairs(subclasses) do
				if not subclass or subclass == subcat then
					for equipSlot, qualities in pairs(slots) do
						if not slot or slot == equipSlot then
							for rarity, levels in pairs(qualities) do
								if not quality or quality == rarity then
									ids[rarity] = ids[rarity] or {}
									names[rarity] = names[rarity] or {}

									for level, items in pairs(levels) do
										if level >= minLevel and level <= maxLevel then
											for id, name in items:gmatch(ITEM_MATCH) do
												if not search or name:lower():find(search, 1, true) then
													tinsert(ids[rarity], id)
													tinsert(names[rarity], name)
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return ids, names
end

function Database:FindClosest(search)
	local search = search:trim():lower()
	local distance = math.huge
	local size = #search
	local bestID, bestName

	for class, subclasses in pairs(Ludwig_Items) do
		for subclass, slots in pairs(subclasses) do
			for equipSlot, qualities in pairs(slots) do
				for quality, levels in pairs(qualities) do
					for level, items in pairs(levels) do
						for id, name in items:gmatch(ITEM_MATCH) do
							if name:lower():sub(1, size) == search then
								local off = #name - size
								if off >= 0 and off < distance then
									bestID, bestName = id, name
									distance = off
								end
							end
						end
					end
				end
			end
		end
	end

	if bestID then
		return tonumber(bestID, 36), bestName
	end
end

function Database:ClassExists(class, subclass, slot)
	if slot then
		return Ludwig_Items[class] and Ludwig_Items[class][subclass] and Ludwig_Items[class][subclass][slot]
	elseif subclass then
		return Ludwig_Items[class] and Ludwig_Items[class][subclass]
	else
		return Ludwig_Items[class]
	end
end

function Database:HasEquipSlots(class, subclass)
	for slot in pairs(Ludwig_Items[class][subclass]) do
		if slot ~= 0 then
			return true
		end
	end
end