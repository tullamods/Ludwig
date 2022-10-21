--[[
Copyright 2007-2022 João Cardoso
Ludwig is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of Ludwig.
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
