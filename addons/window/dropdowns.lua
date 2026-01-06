--[[
	Copyright 2007-2026 João Cardoso
	All Rights Reserved
--]]

local Dropdowns = Ludwig:NewModule('Dropdowns')
local C = LibStub('C_Everywhere').Item

local function create(parent, generator, translator)
	local button = CreateFrame('DropdownButton', nil, parent, 'WowStyle1DropdownTemplate')
	button:SetSelectionText(translator)
	button:SetupMenu(generator)
	return button
end

local function compare(a, b)
	if a == b then
		return true
	elseif type(a) == 'table' and type(b) == 'table' and #a <= #b then
		for l = 1, #a do
			if a[l] ~= b[l] then
				return
			end
		end

		return true
	end
end


--[[ Public ]]--

function Dropdowns:CreateQuality(parent)
	local function menu(_, drop)
		local setter = function(v) parent:SetFilter('quality', v, true); return MenuResponse.Refresh end
		local getter = function(v) return v == tonumber(parent:GetFilter('quality')) end

		drop:CreateRadio(ALL, getter, setter, nil)

		for i = 0, #ITEM_QUALITY_COLORS do
			local color = ITEM_QUALITY_COLORS[i]
			local text = color.hex .. _G[('ITEM_QUALITY%d_DESC'):format(i)] .. '|r'

			drop:CreateRadio(text, getter, setter, i)
		end
	end

	local function translator()
		local quality = parent:GetFilter('quality')
		local color = quality and ITEM_QUALITY_COLORS[tonumber(quality)]
		return color and (color.hex .. _G[('ITEM_QUALITY%s_DESC'):format(quality)] .. '|r') or ALL
	end

	return create(parent, menu, translator)
end

function Dropdowns:CreateCategory(parent)
	local function menu(_, drop)
		local setter = function(v) parent:SetFilter('category', v, true); return MenuResponse.Refresh end
		local getter = function(v) return compare(v, parent:GetFilter('category')) end

		drop:CreateRadio(ALL, getter, setter, nil)

		for i = 0, 30 do
			if Ludwig.Database:ClassExists(i) then
				local class = drop:CreateRadio(C.GetItemClassInfo(i), getter, setter, {i})

				for j = 0, 30 do
					if Ludwig.Database:ClassExists(i,j) then
						local subclass = class:CreateRadio(C.GetItemSubClassInfo(i,j), getter, setter, {i,j})

						for k = 1, 30 do
							if Ludwig.Database:ClassExists(i,j,k) then
								subclass:CreateRadio(C.GetItemInventorySlotInfo(k), getter, setter, {i,j,k})
							end
						end
					end
				end
			end
		end
	end

	local function translator()
		local v = parent:GetFilter('category')
		if v and #v > 0 then
			local parts = {C.GetItemClassInfo(v[1])}
			parts[2] = v[2] and C.GetItemSubClassInfo(v[1], v[2])
			parts[3] = v[3] and C.GetItemInventorySlotInfo(v[3])

			return table.concat(parts, ', ')
		end
		return ALL
	end

	return create(parent, menu, translator)
end