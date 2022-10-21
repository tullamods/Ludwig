local Frame = Ludwig:NewModule('Frame', CreateFrame('Frame', 'LudwigFrame', UIParent, 'LudwigFrameTemplate'))
local filters, numResults, ids, names = {}, 0
local L = Ludwig.Locals


--[[ Startup ]]--

function Frame:Startup()
	-- portrait
	local portrait = self.portrait or self.PortraitContainer.portrait
	portrait:SetTexture('Interface/Icons/INV_Misc_Book_04')

	local backdrop = portrait:GetParent():CreateTexture(nil, 'BORDER')
	backdrop:SetColorTexture(0, 0, 0)
	backdrop:SetAllPoints(portrait)

	local mask = portrait:GetParent():CreateMaskTexture()
	mask:SetTexture('Interface/CHARACTERFRAME/TempPortraitAlphaMask')
	mask:SetAllPoints(backdrop)
	backdrop:AddMaskTexture(mask)
	portrait:AddMaskTexture(mask)

	-- top search
	self.SearchBox = Ludwig.Editboxes:CreateSearch(self)
	self.SearchBox:SetPoint('TOPLEFT', 74, -34)
	self.MinLevel = Ludwig.Editboxes:CreateMinLevel(self)
	self.MinLevel:SetPoint('LEFT', self.SearchBox, 'RIGHT', 12, 0)

	self.MaxLevel = Ludwig.Editboxes:CreateMaxLevel(self)
	self.MaxLevel:SetPoint('LEFT', self.MinLevel, 'RIGHT', 12, 0)

	local hyphen = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	hyphen:SetPoint('LEFT', self.MinLevel, 'RIGHT', 1, 0)
	hyphen:SetText('-')

	local resetButton = CreateFrame('Button', nil, self)
	resetButton:SetNormalTexture('Interface/Buttons/CancelButton-Up')
	resetButton:SetPushedTexture('Interface/Buttons/CancelButton-Down')
	resetButton:SetHighlightTexture('Interface/Buttons/CancelButton-Highlight')
	resetButton:SetScript('OnClick', function() self:ClearFilters() end)
	resetButton:SetPoint('LEFT', self.MaxLevel, 'RIGHT', -2, -2)
	resetButton:SetSize(39, 39)

	-- bottom filters
	self.Quality = Ludwig.Dropdowns:CreateQuality(self)
	self.Quality:SetPoint('BOTTOMLEFT', -10, -3)
	self.Category = Ludwig.Dropdowns:CreateCategory(self)
	self.Category:SetPoint('BOTTOMRIGHT', 10, -3)

	-- frame itself
	self:SetAttribute('UIPanelLayout-defined', true)
	self:SetAttribute('UIPanelLayout-enabled', true)
	self:SetAttribute('UIPanelLayout-whileDead', true)
	self:SetAttribute('UIPanelLayout-area', 'left')
	self:SetAttribute('UIPanelLayout-pushable', 1)
	self:SetAttribute('UIPanelLayout-xoffset', 0)

	tinsert(UISpecialFrames, self:GetName())
	wipe(Ludwig.Dropdowns)
	wipe(Ludwig.Editboxes)

	self.Startup = nil
	self:EnableMouse(true)
	self:SetSize(384, LE_EXPANSION_LEVEL_CURRENT > 4 and 530 or 425)
	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.OnHide)
	self:Hide()
end


--[[ Toggle ]]--

function Frame:Toggle()
	if self:IsShown() then
		HideUIPanel(self)
	else
		ShowUIPanel(self)
	end
end

function Frame:OnShow()
	if not self.Scroll.buttons then
		HybridScrollFrame_CreateButtons(self.Scroll, 'LudwigItemButtonTemplate', 1, -2, 'TOPLEFT', 'TOPLEFT', 0, -3)
	end

	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
	self:Update(true)
end

function Frame:OnHide()
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
	ids, names = nil
	collectgarbage() -- necessary given the amount of memory we're consuming
end


--[[ Update ]]--

function Frame:ScheduleUpdate()
	self.timer = 0.4
	self:SetScript('OnUpdate', self.DelayUpdate)
end

function Frame:DelayUpdate(elapsed)
	if self.timer > 0 then
		self.timer = self.timer - elapsed
	else
		self:SetScript('OnUpdate', nil)
		self:Update(true)
	end
end

function Frame:Update(search)
	if not ids or search then
		ids, names = Ludwig.Database:Find(
			filters.search,
			filters.category and filters.category[1],
			filters.category and filters.category[2],
			filters.category and filters.category[3],
			filters.quality,
			tonumber(filters.minLevel), tonumber(filters.maxLevel))

		numResults = 0
		for i, items in pairs(ids) do
			numResults = numResults + #items
		end

		(self.TitleText or self.TitleContainer.TitleText):SetText(L.FrameTitle:format(numResults))
	end

	self.Scroll:update()
end

function Frame.Scroll:update()
	local self = Frame
	local focus = GetMouseFocus()
	local offset = HybridScrollFrame_GetOffset(self.Scroll)
	local width = (numResults > 17 and 296 or 318) + 52

	for i, button in ipairs(self.Scroll.buttons) do
		local index = i + offset
		if index <= numResults then
			local quality
			for q = 0, #ITEM_QUALITY_COLORS do
				if ids[q] then
					if index > #ids[q] then
						index = index - #ids[q]
					else
						quality = q
						break
					end
				end
			end

			local name = names[quality][index]
			local id = tonumber(ids[quality][index], 36)

			button.id, button.name, button.quality = id, name, quality
			button.Text:SetFormattedText('%s%s|r', ITEM_QUALITY_COLORS[quality].hex, name)
			button.Stripe:SetShown(mod(index, 2) == 0)
			button.Icon:SetTexture(GetItemIcon(id))
			--button.Text:SetText(name)
			button:SetWidth(width)
			button:Show()

			if focus == button then
				button:GetScript('OnEnter')(button)
			end
		else
			button:Hide()
		end
	end

	HybridScrollFrame_Update(self.Scroll, numResults * 20 + 2, #self.Scroll.buttons * 18)
	self.Scroll:SetWidth(width + 5)
end


--[[ Filters ]]--

function Frame:SetFilter(index, value, force)
	if filters[index] ~= value then
		filters[index] = value

		if force then
			self:Update(true)
		else
			self:ScheduleUpdate()
		end
	end
end

function Frame:GetFilter(index)
	return filters[index]
end

function Frame:ClearFilters()
	local name = self:GetName()
	wipe(filters)

	self.SearchBox:Default()
	self.MinLevel:Default()
	self.MaxLevel:Default()
	self.Category:UpdateText()
	self.Quality:UpdateText()
	self:Update(true)
end

Frame:Startup()
