--[[
	linkerator.lua
		Linkerator functionality for adapted for Ludwig
		Thanks to N00bZXI for the autocomplete changes
--]]

local ItemDB

local function loadItemDB()
	if Ludwig:LoadData() then
		ItemDB = Ludwig['ItemDB']
		return true
	end
end

local function onFullMatch(match)
	if not (ItemDB or loadItemDB()) then return end

	local id = ItemDB:GetItemNamedLike(match)
	if id then
		return ItemDB:GetItemLink(id)
	end
	return match
end

local function onPartialMatch(match)
	if not (ItemDB or loadItemDB()) then return end

	local id, name = ItemDB:GetItemNamedLike(match)
	if id then
		return '[[' .. name
	end
	return '[[' .. match
end

local function chatFrame_OnChar(self, ...)
	local text = self:GetText()
	if text ~= '' then
		if text:match('%[%[(.+)%]$') then
			--self:SetText(text:gsub('%[%[(.+)%]$', onFullMatch))
		else
			--self:SetText(text:gsub('%[%[(.+)$', onPartialMatch))
			self:HighlightText(#text, -1)
		end
	end
end

local hookedFrames = {}
hooksecurefunc('ChatEdit_OnTextChanged', function(self, isUserInput)
	if not hookedFrames[self] then
		self:HookScript('OnChar', chatFrame_OnChar)
		hookedFrames[self] = true
	end
end)