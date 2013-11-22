--[[
	linkerator.lua
		Linkerator functionality for adapted for Ludwig
		Thanks to N00bZXI for the autocomplete changes
--]]

local AddonName, Addon = ...

local function getBestMatch(match)
	local results = Addon:GetItemsByName('^' .. match)
	if results then
		return results[1]
	end
end

local function onFullMatch(match)
	local item = getBestMatch(match)
	if item then
		return Addon('ItemDB'):GetItemLink(item.id, item.name, item.hex)
	end
	return '[[' .. match
end

local function onPartialMatch(match)
	local item = getBestMatch(match)
	if item then
		return '[[' .. item.name
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