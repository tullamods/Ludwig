local AddonName, Addon = ...
local L = Addon('Locals')
local ItemDB = Addon('ItemDB')


--[[ Item Button ]]--

local function itemButton_OnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	GameTooltip:SetHyperlink(ItemDB:GetItemLink(self:GetID())
	GameTooltip:Show()
end

local function itemButton_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

local function itemButton_OnClick(self, button)
	HandleModifiedItemClick(ItemDB:GetItemLink(self:GetID())
end

local function itemButton_Create(name, parent)
	local b = CreateFrame('Button', name, parent)
	b:SetSize(300, 22)
	
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


--[[ Search Box ]]--

local function searchBox_ClearDefaultText(self)
	if self:GetText() == _G['SEARCH'] then
		self:SetText('')
	end
end

local function searchBox_AddDefaultText(self)
	if self:GetText() == '' then
		self:SetText(_G['SEARCH'])
	end
end

local function searchBox_OnShow(self)
	searchBox_AddDefaultText(self)
end

local function searchBox_OnEnterPressed(self)
	self:ClearFocus()
end

local function searchBox_OnTextChanged(self, text)
	--LudwigUI_OnTextChanged(self, 'name')
end

local function searchBox_OnTabPressed(self)
	_G[self:GetParent():GetName() .. 'MinLevel']:SetFocus()
end

local function searchBox_OnEditFocusLost(self)
	self:HighlightText(0, 0)
	searchBox_AddDefaultText(self)
end

local function searchBox_OnEditFocusGained(self)
	self:HighlightText()
	searchBox_ClearDefaultText()
end

local function searchBox_Create(name, parent)
	local searchBox = CreateFrame('EditBox', name, parent, 'InputBoxTemplate')
	searchBox:SetSize(148, 20)
	searchBox:SetPoint('TOPLEFT', 84, -44)
	
	searchBox:SetScript('OnShow', searchBox_OnShow)
	searchBox:SetScript('OnEnterPressed', searchBox_OnEnterPressed)
	searchBox:SetScript('OnTextChanged', searchBox_OnTextChanged)
	searchBox:SetScript('OnTabPressed', searchBox_OnTabPressed)
	searchBox:SetScript('OnEditFocusLost', searchBox_OnEditFocusLost)
	searchBox:SetScript('OnEditFocusGained', searchBox_OnEditFocusGained)
	
	return searchBox
end


--[[ Generic Number Search Box ]]--

local function numSearchBox_Create(name, parent)
	local searchBox = CreateFrame('EditBox', name, parent, 'InputBoxTemplate')
	searchBox:SetSize(25, 16)
	searchBox:SetNumeric(true)
	searchBox:SetAutoFocus(false)
	searchBox:SetMaxLetters(2)
	
	return searchBox
end


--[[ Min Level Filter ]]--

local function minLevelSearchBox_OnTabPressed(self)
	_G[self:GetParent():GetName() .. 'MaxLevel']:SetFocus()
end

local function minLevelSearchBox_OnEnterPressed(self)
	self:ClearFocus()
end

local function minLevelSearchBox_OnTextChanged(self, text)
	--LudwigUI_OnTextChanged(self, 'minLevel')
end

local function minLevelSearchBox_Create(name, parent)
	local searchBox = numSearchBox_Create(name, parent)
	
	searchBox:SetScript('OnTabPressed', minLevelSearchBox_OnTabPressed)
	searchBox:SetScript('OnEnterPressed', minLevelSearchBox_OnEnterPressed)
	searchBox:SetScript('OnTextChanged', minLevelSearchBox_OnTextChanged)
	
	return searchBox	
end


--[[ Max Level Filter ]]--

local function maxLevelSearchBox_OnTabPressed(self)
	_G[self:GetParent():GetName() .. 'Search']:SetFocus()
end

local function maxLevelSearchBox_OnEnterPressed(self)
	self:ClearFocus()
end

local function maxLevelSearchBox_OnTextChanged(self, text)
	--LudwigUI_OnTextChanged(self, 'maxLevel')
end

local function maxLevelSearchBox_Create(name, parent)
	local searchBox = numSearchBox_Create(name, parent)
	
	searchBox:SetScript('OnTabPressed', maxLevelSearchBox_OnTabPressed)
	searchBox:SetScript('OnEnterPressed', maxLevelSearchBox_OnEnterPressed)
	searchBox:SetScript('OnTextChanged', maxLevelSearchBox_OnTextChanged)
	
	return searchBox	
end


--[[ Reset Button ]]--

local function resetButton_OnClick(self, button)
end

local function resetButton_Create(name, parent)
	local b = CreateFrame('Button', name, parent)
	b:SetSize(39, 39)
	b:SetNormalTexture([[Interface\Buttons\CancelButton-Up]])
	b:SetPushedTexture([[Interface\Buttons\CancelButton-Down]])
	b:SetHighlightTexture([[Interface\Buttons\CancelButton-Highlight]])
	
	b:SetScript('OnClick', resetButton_OnClick)
	
	return b
end


--[[ Search Frame ]]--

local function frame_OnShow(self)
	PlaySound('igCharacterInfoOpen')
end

local function frame_OnHide(self)
	PlaySound('igCharacterInfoClose')
end

local function frame_Create(name, parent)
	local frame = CreateFrame('Frame', name, parent)
	local frameName = frame:GetName()
	
	--set attributes
	frame:Hide()
	frame:SetSize(384, 512)
	frame:EnableMouse(true)
	frame:SetToplevel(true)
	frame:SetMovable(true)
	
	frame:SetAttribute('UIPanelLayout-defined', true)
	frame:SetAttribute('UIPanelLayout-enabled', true)
	frame:SetAttribute('UIPanelLayout-whileDead', true)
	frame:SetAttribute('UIPanelLayout-area', true)
	frame:SetAttribute('UIPanelLayout-pushable', true)
	
	frame:SetHitRectInsets(0, 35, 0, 75)
	
	--add textures
	local icon = frame:CreateTexture(frameName .. 'Icon', 'BACKGROUND')
	icon:SetSize(62, 62)
	icon:SetPoint('TOPLEFT', 5, -5)
	SetPortraitToTexture(icon, [[Interface\Icons\INV_Misc_Book_04]])
	
	--background textures
	local tl = frame:CreateTexture(nil, 'ARTWORK')
	tw:SetSize(256, 256)
	tw:SetPoint('TOPLEFT')
	tw:SetTexture([[Interface\TaxiFrame\UI-TaxiFrame-TopLeft]])
	
	local tr = frame:CreateTexture(nil, 'ARTWORK')
	tr:SetSize(128, 256)
	tr:SetPoint('TOPRIGHT')
	tr:SetTexture([[Interface\TaxiFrame\UI-TaxiFrame-TopRight]])
	
	local bl = frame:CreateTexture(nil, 'ARTWORK')
	bl:SetSize(256, 256)
	bl:SetPoint('BOTTOMLEFT')
	bl:SetTexture([[Interface\PaperDollInfoFrame\SkillFrame-BotLeft]])
	
	local br = frame:CreateTexture(nil, 'ARTWORK')
	br:SetSie(128, 256)
	br:SetPoint('BOTTOMRIGHT')
	br:SetTexture([[Interface\PaperDollInfoFrame\SkillFrame-BotRight]])
	
	--add title text
	local text = frame:CreateFontString(frameName .. 'Text', 'ARTWORK', 'GameFontHighlight')
	text:SetSize(300, 14)
	text:SetText(_G['TEXT'])
	text:SetPoint('TOP', 0, -16)
	
	--close button
	local closeButton = CreateFrame('Button', frameName .. 'CloseButton', 'UIPanelCloseButton')
	closeButton:SetPoint('TOPRIGHT', -29, -8)
	
	--search box
	local searchBox = searchBox_Create(frameName .. 'Search', frame)
	searchBox:SetPoint('TOPLEFT', 84, -44)
	
	--min level search
	local minLevelSearchBox = minLevelSearchBox_Create(frameName .. 'MinLevel', frame)
	minLevelSearchBox:SetPoint('LEFT', searchBox, 'RIGHT', 12, 0)
	
	local hyphenText = self:CreateFontString(frameName .. 'HyphenText', 'ARTWORK', 'GameFontHighlightSmall')
	hyphenText:SetText('-')
	hyphenText:SetPoint('LEFT', minLevelSearchBox, 'RIGHT', 1, 0)
	
	--max level search
	local maxLevelSearchBox = maxLevelSearchBox_Create(frameName .. 'MaxLevel', frame)
	maxLevelSearchBox:SetPoint('LEFT', minLevelSearchBox, 'RIGHT', 12, 0)
	
	--reset button
	local resetButton = resetButton_Create(frameName .. 'ResetButton', frame)
	resetButton:SetPoint('LEFT', maxLevelSearchBox, 'RIGHT', -2, -2)
	
	--scroll area
	
	return frame
end


--[[
	UIFrame Module
--]]

local SearchFrame = Addon:NewModule('SearchFrame')

function SearchFrame:Show()
	local frame = self.frame
	if not frame then
		frame = frame_Create('LudwigSearchFrame', UIParent)
		self.frame = frame
	end
	ShowUIPanel(frame)
end

function SearchFrame:Hide()
	local frame = self.frame
	if frame then
		HideUIPanel(frame)
	end
end

function SearchFrame:Toggle()
	if self:IsShown() then
		self:Hide()
	else
		self:Show()
	end
end

function SearchFrame:IsShown()
	if self.frame then
		return self.frame:IsShown()
	end
	return false
end