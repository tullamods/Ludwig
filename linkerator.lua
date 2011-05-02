--[[
	linkerator.lua
		Linkerator functionality for adapted for Ludwig
		Thanks to N00bZXI for the autocomplete changes
--]]

local function onFullMatch(match)
	local ItemDB = self:LoadData()
	if not ItemDB then
		return
	end

	local id = ItemDB:GetItemNamedLike(match)
	if id then
		return ItemDB:GetItemLink(id)
	end
	return match
end

local function onPartialMatch(match)
	local ItemDB = self:LoadData()
	if not ItemDB then
		return
	end

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