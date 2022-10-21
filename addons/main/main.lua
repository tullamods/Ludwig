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
_G[ADDON] = Addon


--[[ Actions ]]--

function Addon:ToggleWindow()
	if self:Load('Window') then
		self.Frame:Toggle()
	end
end

function Addon:QueryItem(id)
	SetItemRef(format('item:%d', tonumber(id)))
end


--[[ Modules & Loading ]]--

function Addon:NewModule(name, obj)
	obj = obj or {}
	self[name] = obj
	return obj
end

function Addon:Load(name)
	EnableAddOn(ADDON ..'_'.. name)
	return LoadAddOn(ADDON ..'_'.. name)
end
