--[[
	Copyright 2007-2025 João Cardoso
	All Rights Reserved
--]]

local Database = Ludwig:NewModule('Database')
local ITEM_MATCH = '(%w%w%w%w)([^_]+)'


--[[ Searches ]]--

function Database:Find(search, class, subclass, slot, quality, minLevel, maxLevel)
	local ids, names = {}, {}

	search = search and search:lower()
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
												if not search or name:lower():find(search) then
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
	local size = #search
	local search = '^' .. search:lower()
	local distance = math.huge
	local bestID, bestName, bestQuality

	for class, subclasses in pairs(Ludwig_Items) do
		for subclass, slots in pairs(subclasses) do
			for equipSlot, qualities in pairs(slots) do
				for quality, levels in pairs(qualities) do
					for level, items in pairs(levels) do
						for id, name in items:gmatch(ITEM_MATCH) do
							if name:lower():match(search) then
								local off = #name - size
								if off >= 0 and off < distance then
									bestID, bestName, bestQuality = id, name, quality
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
		return tonumber(bestID, 36), bestName, bestQuality
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


--[[ Utilities ]]--

function Database:GetLink(id, name, quality)
	return ('%s|Hitem:%d:::::::::::::::|h[%s]|h|r'):format(ITEM_QUALITY_COLORS[quality].hex, id, name)
end

ChatEdit_InsertLink = function(link)
    if link and link:find("|Hitem:") and ChatEdit_GetActiveWindow() then
        local itemID = link:match("item:(%d+)")
        if itemID then
            local itemName, itemLink = GetItemInfo(tonumber(itemID))
            if itemLink then
                local chatBox = ChatEdit_GetActiveWindow()
                local currentText = chatBox:GetText()

                -- Avoid adding multiple item links
                if not currentText:find(itemLink, 1, true) then
                    chatBox:SetText(currentText .. " " .. itemLink)
                end
                return true
            end
        end
    end
end
