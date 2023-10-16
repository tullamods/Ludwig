--[[
Copyright 2007-2023 João Cardoso
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
local L = Addon.Locals

SlashCmdList['LudwigCOMMAND'] = function(msg, ...)
	local cmd = (msg or ''):lower():match('([%w%s]+)')
	if cmd then
		if cmd:sub(1,1) == 'q' then
			local id = cmd:match('q (%d+)')
			if id then
				Addon:QueryItem(id)
			else
				print(ADDON ..': '.. L.MissingNumber)
			end
		else
			print(ADDON ..': '.. L.UnknownCommand:format(cmd))
		end
	else
		Addon:ToggleWindow()
	end
end

SLASH_LudwigCOMMAND1 = '/lw'
SLASH_LudwigCOMMAND2 = '/ludwig'
