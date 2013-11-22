--[[
	linkerator.lua
		Linkerator functionality for adapted for Ludwig
		Thanks to N00bZXI for the autocomplete changes
--]]

local AddonName, Addon = ...

local function onFullMatch(match)
	local id, name = Addon:GetClosestItem(match)
	if id then
		return Addon('ItemDB'):GetItemLink(id, name, '|cffffffff')
	end

	return '[[' .. match
end

local function onPartialMatch(match)
	local _, name = Addon:GetClosestItem(match)
	if name then
		return '[[' .. name
	end
	return '[[' .. match
end

local function chatFrame_OnChar(self, ...)
	local text = self:GetText()
	if text ~= '' then
		if text:find('%[%[(.+)%]$') then
			self:SetText(text:gsub('%[%[(.+)%]$', onFullMatch))
		else
			self:SetText(text:gsub('%[%[(.+)$', onPartialMatch))
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