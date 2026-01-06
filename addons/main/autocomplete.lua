--[[
	Copyright 2007-2026 João Cardoso
	All Rights Reserved
--]]

local ADDON, Addon = ...
local Auto = Ludwig:NewModule('AutoComplete')

function Auto:OnLoad()
	if ChatEdit_OnTextChanged then
		hooksecurefunc('ChatEdit_OnTextChanged', Auto.OnFrame)
	else
		local i = 1
		local frame = _G['ChatFrame' .. i .. 'EditBox']
		while frame do
			Auto.OnFrame(frame)
			
			i = i + 1
			frame = _G['ChatFrame' .. i .. 'EditBox']
		end

		hooksecurefunc(ChatFrameEditBoxMixin, 'OnTextChanged', Auto.OnFrame)
	end
end

function Auto.OnFrame(frame)
	if not Auto[frame] then
		frame:HookScript('OnTabPressed', Auto.OnTab)
		frame:HookScript('OnChar', Auto.OnText)
		Auto[frame] = true
	end
end

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
	local id, name = Auto.ClosestItem(query)
	return id and Addon:GetLink(id) or ('lw:' .. (name or query))
end

function Auto.ClosestItem(...)
	if Addon:Load('Data') then
		return Addon.Database:FindClosest(...)
	end
end

Auto:OnLoad()
