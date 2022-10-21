--[[
	autocomplete.lua
		Finds and writes item links for you
--]]

local ADDON, Addon = ...
local Auto = Ludwig:NewModule('AutoComplete')

hooksecurefunc('ChatEdit_OnTextChanged', function(frame)
	if not Auto[frame] then
		frame:HookScript('OnChar', Auto.OnText)
		frame:HookScript('OnTabPressed', Auto.OnTab)
		Auto[frame] = true
	end
end)

function Auto.OnText(frame)
	local text = frame:GetText()
	if text and text:find('lw:(.+)$') then
		frame:SetText(text:gsub('lw:(.+)$', Auto.MakeSuggestion))
		frame:HighlightText(#text, -1)
	end
end

function Auto.OnTab(frame)
	local text = frame:GetText()
	if text and text:find('lw:(.+)$') then
		frame:SetText(text:gsub('lw:(.+)$', Auto.MakeLink))
	end
end

function Auto.MakeSuggestion(query)
	local _, name = Auto.ClosestItem(query)
	return 'lw:' .. (name or query)
end

function Auto.MakeLink(query)
	local id, name, quality = Auto.ClosestItem(query)
	if id then
		return Addon.Database:GetLink(id, name, quality)
	end
	return 'lw:' .. (name or query)
end

function Auto.ClosestItem(...)
	if Addon:Load('Data') then
		return Addon.Database:FindClosest(...)
	end
end
