--[[
	linkerator.lua
		Linkerator functionality for adapted for Ludwig
		Thanks to N00bZXI for the autocomplete changes
--]]

local ADDON, Addon = ...

local function getClosestItem(...)
	if Addon:LoadData() then
		return Addon('Database'):FindClosestItem(...)
	end
end

local function onFullMatch(match)
	local id, name, quality = getClosestItem(match)
	if id then
		return Addon('Database'):GetItemLink(id, name, quality)
	end

	return '[[' .. match
end

local function onPartialMatch(match)
	local _, name = getClosestItem(match)
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
