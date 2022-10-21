local Others = Ludwig:NewModule('Others')

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
