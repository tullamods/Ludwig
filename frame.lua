local AddonName, Addon = ...
local SearchFrame = Addon:NewModule('SearchFrame')

--[[ Globals ]]--

local ItemDB = Addon('ItemDB')
local L = Addon('Locals')

local ITEMS_TO_DISPLAY = 15
local ITEM_HEIGHT = 22
local ITEM_STEP = 1
local DEFAULT_SEARCH_TEXT = _G['SEARCH']
local Search = {
	name = '',

	getItems = function(self)
		return ItemDB:GetItems(
			self.name,
			self.quality,
			self.type,
			self.subType,
			self.equipLoc,
			self.minLevel,
			self.maxLevel
		)
	end,

	reset = function(self)
		self.name = ''
		self.quality = nil
		self.type = nil
		self.subType = nil
		self.equipLoc = nil
		self.minLevel = nil
		self.maxLevel = nil
	end,
}

--[[ Item Button ]]--

local function itemButton_OnEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	GameTooltip:SetHyperlink(ItemDB:GetItemLink(self:GetID()))
	GameTooltip:Show()
end

local function itemButton_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

local function itemButton_OnClick(self, button)
	HandleModifiedItemClick(ItemDB:GetItemLink(self:GetID()))
end

local function itemButton_Create(name, parent)
	local b = CreateFrame('Button', name, parent); b:Hide()
	b:SetSize(300, 22)
	b:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])

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


--[[ Search Box ]]--

local function searchBox_ClearDefaultText(self)
	if self:GetText() == DEFAULT_SEARCH_TEXT then
		self:SetText('')
	end
end

local function searchBox_AddDefaultText(self)
	if self:GetText() == '' then
		self:SetText(DEFAULT_SEARCH_TEXT)
	end
end

local function searchBox_OnShow(self)
	searchBox_AddDefaultText(self)
end

local function searchBox_OnEnterPressed(self)
	self:ClearFocus()
end

local function searchBox_OnTextChanged(self, isUserInput)
	if isUserInput then
		SearchFrame:SetSearchFilter('name', self:GetText())
	end
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
	searchBox_ClearDefaultText(self)
end

local function searchBox_Create(name, parent)
	local searchBox = CreateFrame('EditBox', name, parent, 'InputBoxTemplate')
	searchBox:SetSize(148, 20)
	searchBox:SetPoint('TOPLEFT', 84, -44)
	searchBox:SetAutoFocus(false)

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

local function minLevelSearchBox_OnTextChanged(self, isUserInput)
	if isUserInput then
		SearchFrame:SetSearchFilter('minLevel', tonumber(self:GetText()))
	end
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

local function maxLevelSearchBox_OnTextChanged(self, isUserInput)
	if isUserInput then
		SearchFrame:SetSearchFilter('maxLevel', tonumber(self:GetText()))
	end
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
	--reset the search window
	SearchFrame:ClearSearch()
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


--[[ Scroll Frame ]]--

local function scrollFrame_UpdateList(self)
	SearchFrame:UpdateList()
end

local function scrollFrame_OnVerticalScroll(self, offset)
	FauxScrollFrame_OnVerticalScroll(self, offset, ITEM_HEIGHT, scrollFrame_UpdateList)
end

local function scrollFrame_Create(name, parent)
	local f = CreateFrame('ScrollFrame', name, parent, 'FauxScrollFrameTemplate')
	f:SetScript('OnVerticalScroll', scrollFrame_OnVerticalScroll)

	return f
end


--[[ Quality Filter ]]--

local function qualityFilter_OnClick(self, dropdown, ...)
	UIDropDownMenu_SetSelectedValue(dropdown, self.value)
	SearchFrame:SetSearchFilter('quality', self.value > -1 and self.value or nil)
end

local function qualityFilter_Initialize(self, level)
	local info = UIDropDownMenu_CreateInfo()
	info.text = ALL
	info.value = -1
	info.func = qualityFilter_OnClick
	info.arg1 = self
	UIDropDownMenu_AddButton(info)

	for i = 0, #ITEM_QUALITY_COLORS do
		local color = ITEM_QUALITY_COLORS[i]
		info.text = color.hex .. _G[format('ITEM_QUALITY%d_DESC', i)] .. '|r'
		info.value = i
		info.func = qualityFilter_OnClick
		info.arg1 = self
		info.checked = nil
		UIDropDownMenu_AddButton(info)
	end
end

local function qualityFilter_Create(name, parent)
	local f = CreateFrame('Frame', name, parent, 'UIDropDownMenuTemplate')
	UIDropDownMenu_Initialize(f, qualityFilter_Initialize)
	UIDropDownMenu_SetSelectedValue(f, -1);
	UIDropDownMenu_SetWidth(f, 90)

	return f
end


--[[ Type Filter ]]--

local function typeFilter_Create(name, parent)
	local f = CreateFrame('Frame', name, parent, 'UIDropDownMenuTemplate')
--	UIDropDownMenu_Initialize(self, Quality_Initialize)
	UIDropDownMenu_SetWidth(f, 200)

	return f
end


--[[ Search Frame ]]--

local searchResults = Search:getItems()
local function frame_UpdateList(self)
	local numResults = #searchResults
	_G[self:GetName() .. 'Title']:SetText(L.FrameTitle:format(numResults))

	local offset = FauxScrollFrame_GetOffset(_G[self:GetName() .. 'ScrollFrame']) or 0

	for i = 1, ITEMS_TO_DISPLAY do
		local index = offset + i
		if index > numResults then
			local button = rawget(self.itemButtons, i)
			if button then
				button:Hide()
			end
		else
			local button = self.itemButtons[i]
			local itemId = searchResults[index]
			local name, hex = ItemDB:GetItemName(itemId)

			button.icon:SetTexture(GetItemIcon(itemId))
			button:SetFormattedText('%s%s|r', hex, name)
			button:SetID(itemId)
			button:Show()
		end
	end

	FauxScrollFrame_Update(
		_G[self:GetName() .. 'ScrollFrame'],
		numResults,
		ITEMS_TO_DISPLAY,
		ITEM_STEP,
		self:GetName() .. 'Item',
		300,
		320,
		nil,
		nil,
		nil,
		false
	)
end

local function frame_OnUpdate(self, elapsed)
	if self.timer > 0 then
		self.timer = self.timer - elapsed
	else
		self:SetScript('OnUpdate', nil)
		searchResults = Search:getItems()
		frame_UpdateList(self)
	end
end

local function frame_OnShow(self)
	searchResults = Search:getItems()
	frame_UpdateList(self)
	PlaySound('igCharacterInfoOpen')
end

local function frame_OnHide(self)
	searchResults = nil
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
	tl:SetSize(256, 256)
	tl:SetPoint('TOPLEFT')
	tl:SetTexture([[Interface\TaxiFrame\UI-TaxiFrame-TopLeft]])

	local tr = frame:CreateTexture(nil, 'ARTWORK')
	tr:SetSize(128, 256)
	tr:SetPoint('TOPRIGHT')
	tr:SetTexture([[Interface\TaxiFrame\UI-TaxiFrame-TopRight]])

	local bl = frame:CreateTexture(nil, 'ARTWORK')
	bl:SetSize(256, 256)
	bl:SetPoint('BOTTOMLEFT')
	bl:SetTexture([[Interface\PaperDollInfoFrame\SkillFrame-BotLeft]])

	local br = frame:CreateTexture(nil, 'ARTWORK')
	br:SetSize(128, 256)
	br:SetPoint('BOTTOMRIGHT')
	br:SetTexture([[Interface\PaperDollInfoFrame\SkillFrame-BotRight]])

	--add title text
	local text = frame:CreateFontString(frameName .. 'Title', 'ARTWORK', 'GameFontHighlight')
	text:SetSize(300, 14)
	text:SetPoint('TOP', 0, -16)

	--close button
	local closeButton = CreateFrame('Button', frameName .. 'CloseButton', frame, 'UIPanelCloseButton')
	closeButton:SetPoint('TOPRIGHT', -29, -8)

	--search box
	local searchBox = searchBox_Create(frameName .. 'Search', frame)
	searchBox:SetPoint('TOPLEFT', 84, -44)

	--min level search
	local minLevelSearchBox = minLevelSearchBox_Create(frameName .. 'MinLevel', frame)
	minLevelSearchBox:SetPoint('LEFT', searchBox, 'RIGHT', 12, 0)

	local hyphenText = frame:CreateFontString(frameName .. 'HyphenText', 'ARTWORK', 'GameFontHighlightSmall')
	hyphenText:SetText('-')
	hyphenText:SetPoint('LEFT', minLevelSearchBox, 'RIGHT', 1, 0)

	--max level search
	local maxLevelSearchBox = maxLevelSearchBox_Create(frameName .. 'MaxLevel', frame)
	maxLevelSearchBox:SetPoint('LEFT', minLevelSearchBox, 'RIGHT', 12, 0)

	--reset button
	local resetButton = resetButton_Create(frameName .. 'ResetButton', frame)
	resetButton:SetPoint('LEFT', maxLevelSearchBox, 'RIGHT', -2, -2)

	--scroll area
	local scrollFrame = scrollFrame_Create(frameName .. 'ScrollFrame', frame)
	scrollFrame:SetPoint('TOPLEFT', 24, -78)
	scrollFrame:SetPoint('BOTTOMRIGHT', -68, 106)

	--quality filter
	local qualityFilter = qualityFilter_Create(frameName .. 'Quality', frame)
	qualityFilter:SetPoint('BOTTOMLEFT', 0, 72)

	--item type filter
	local typeFilter = typeFilter_Create(frameName .. 'Type', frame)
	typeFilter:SetPoint('BOTTOMLEFT', 110, 72)

	--item buttons
	frame.itemButtons = setmetatable({}, {__index = function(t, k)
		local item = itemButton_Create(frameName .. 'Item' .. k, frame)
		item:SetPoint('TOPLEFT', scrollFrame, 'TOPLEFT', 0, -item:GetHeight() * (k-1))
		t[k] = item
		return item
	end})

	return frame
end


--[[
	UIFrame Module
--]]

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


--[[ Searching ]]--

local function scheduleUpdate(self)
	local frame = self.frame
	if frame then
		frame.timer = 0.3
		frame:SetScript('OnUpdate', frame_OnUpdate)
	end
end

function SearchFrame:SetSearchFilter(index, value)
	print('setFilter', index, value)
	if Search[index] ~= value then
		Search[index] = value
		scheduleUpdate(self)
	end
end

function SearchFrame:ClearSearch()
	--clear search values
	Search:reset()

	--clear ui values
	local frame = self.frame
	if frame then
		local frameName = self.frame:GetName()
		_G[frameName .. 'Search']:ClearFocus()
		_G[frameName .. 'Search']:SetText(DEFAULT_SEARCH_TEXT)

		_G[frameName .. 'MinLevel']:ClearFocus()
		_G[frameName .. 'MinLevel']:SetText('')

		_G[frameName .. 'MaxLevel']:ClearFocus()
		_G[frameName .. 'MaxLevel']:SetText('')

		UIDropDownMenu_SetSelectedValue(_G[frameName .. 'Quality'], -1)
	end

	--update the frame
	scheduleUpdate(self)
end

function SearchFrame:UpdateList()
	frame_UpdateList(self.frame)
end