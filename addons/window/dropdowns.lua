local Dropdowns = Ludwig:NewModule('Dropdowns')
local Database = Ludwig.Database

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


--[[ Common ]]--

function Dropdowns:Create(name, width, initialize, onclick, getlabel, parent)
	local drop = CreateFrame('Frame', '$parent'..name, parent, 'UIDropDownMenuTemplate')
  drop.UpdateText = self.UpdateText
  drop.AddItem = self.AddItem
  drop.OnClick = self.OnClick

  drop.getlabel = getlabel
  drop.onclick = onclick

	UIDropDownMenu_Initialize(drop, initialize)
	UIDropDownMenu_SetWidth(drop, width)
	drop:UpdateText()

	return drop
end

function Dropdowns:UpdateText()
	_G[self:GetName() .. 'Text']:SetText(self:getlabel())
end

function Dropdowns:AddItem(text, value, selection, arrow)
	if text and text ~= '' then
	  return UIDropDownMenu_AddButton({
				func = self.OnClick,
	      checked = compare(value, selection),
	      hasArrow = arrow,
	      text = text,
	      arg1 = self,
	      arg2 = value,
	      value = value
	  }, UIDROPDOWNMENU_MENU_LEVEL)
	end
end

function Dropdowns:OnClick(self, ...)
	self:onclick(...)
	self:UpdateText()
	CloseDropDownMenus()
end


--[[ Category ]]--

local function category_Initialize(self, level)
    if not level then
        return
    end

    local selection = self:GetParent():GetFilter('category')
    local current = UIDROPDOWNMENU_MENU_VALUE or {}

    if level == 1 then
      	self:AddItem(ALL, nil, selection)

				for id = 0, 30 do
					if Database:ClassExists(id) then
						self:AddItem(GetItemClassInfo(id), {id}, selection, GetItemSubClassInfo(id, 0))
					end
				end
		elseif level == 2 then
			for id = 0, 30 do
				if Database:ClassExists(current[1], id) then
					local hasSlots = Database:HasEquipSlots(current[1], id)
					self:AddItem(GetItemSubClassInfo(current[1], id), {current[1], id}, selection, hasSlots)
				end
			end
		elseif level == 3 then
			for slot = 1, 30 do
				if Database:ClassExists(current[1], current[2], slot) then
					self:AddItem(GetItemInventorySlotInfo(slot), {current[1], current[2], slot}, selection)
				end
			end
    end
end

local function category_Select(self, values)
    self:GetParent():SetFilter('category', values, true)
end

local function category_GetText(self)
    local class = self:GetParent():GetFilter('category')
    if not class then
        return ALL
		end

		local text = GetItemClassInfo(class[1])
		if #class >= 2 then
			text = text .. ' - ' .. GetItemSubClassInfo(class[1], class[2])

			if #class >= 3 then
				text = text .. ' - ' .. GetItemInventorySlotInfo(class[3])
			end
		end

		return text
end

function Dropdowns:CreateCategory(parent)
	return self:Create('Category', 200, category_Initialize, category_Select, category_GetText, parent)
end


--[[ Quality ]]--

local function quality_Initialize(self)
	local quality = tonumber(self:GetParent():GetFilter('quality'))
  self:AddItem(ALL, nil, quality)

	for i = 0, #ITEM_QUALITY_COLORS do
		local color = ITEM_QUALITY_COLORS[i]
		local text = color.hex .. _G[('ITEM_QUALITY%d_DESC'):format(i)] .. '|r'
    self:AddItem(text, i, quality)
	end
end

local function quality_Select(self, i)
  self:GetParent():SetFilter('quality', i, true)
end

local function quality_UpdateText(self)
	local quality = self:GetParent():GetFilter('quality')
	if quality then
		local color = ITEM_QUALITY_COLORS[tonumber(quality)]
		return color.hex .. _G[('ITEM_QUALITY%s_DESC'):format(quality)] .. '|r'
	else
		return ALL
	end
end

function Dropdowns:CreateQuality(parent)
	return self:Create('Quality', 90, quality_Initialize, quality_Select, quality_UpdateText, parent)
end
