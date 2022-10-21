local Others = Ludwig:NewModule('Others')
local Database = Ludwig.Database
local ITEM_HEIGHT = 22


--[[ Item Buttons ]]--

local function itemButton_OnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	GameTooltip:SetHyperlink(Database:GetLink(self:GetID(), self.name, self.quality))
	GameTooltip:Show()
end

local function itemButton_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

local function itemButton_OnClick(self, button)
	local itemLink = Database:GetLink(self:GetID(), self.name, self.quality)
	HandleModifiedItemClick(itemLink)
end

function Others:CreateItemButton(parent, i)
	local b = CreateFrame('Button', '$parentItem'..i, parent)
	b:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
	b:SetSize(300, ITEM_HEIGHT)

	local text = b:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLeft')
	text:SetPoint('TOPLEFT', 28, 0)
	text:SetPoint('BOTTOMRIGHT')
	b:SetFontString(text)

	local icon = b:CreateTexture(nil, 'BACKGROUND')
	icon:SetSize(20, 20)
	icon:SetPoint('LEFT', 4, 0)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	b.icon = icon

	b:SetScript('OnEnter', itemButton_OnEnter)
	b:SetScript('OnLeave', itemButton_OnLeave)
	b:SetScript('OnClick', itemButton_OnClick)

	return b
end


--[[ Reset Button ]]--

local function resetButton_OnClick(self)
	self:GetParent():ClearFilters()
end

function Others:CreateResetButton(parent)
	local b = CreateFrame('Button', nil, parent)

	b:SetNormalTexture([[Interface\Buttons\CancelButton-Up]])
	b:SetPushedTexture([[Interface\Buttons\CancelButton-Down]])
	b:SetHighlightTexture([[Interface\Buttons\CancelButton-Highlight]])
	b:SetScript('OnClick', resetButton_OnClick)
	b:SetSize(39, 39)

	return b
end


--[[ Scroll Frame ]]--

local function scrollFrame_UpdateList(self)
	self:GetParent():Update()
end

local function scrollFrame_OnVerticalScroll(self, offset)
	FauxScrollFrame_OnVerticalScroll(self, offset, ITEM_HEIGHT, scrollFrame_UpdateList)
end

function Others:CreateScrollFrame(parent)
	local f = CreateFrame('ScrollFrame', '$parentScrollFrame', parent, 'FauxScrollFrameTemplate')
	f:SetScript('OnVerticalScroll', scrollFrame_OnVerticalScroll)

	return f
end
